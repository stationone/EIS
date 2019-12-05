package com.ecspace.business.knowledgeCenter.administrator.service.impl;

//import com.ecspace.business.knowledgeCenter.administrator.dao.MenuDao;

import com.ecspace.business.knowledgeCenter.administrator.dao.MenuDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.MenuService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.List;

/**
 * @author zhangch
 * @date 2019/11/12 0012 下午 20:46
 */
@Transactional
@Service
public class MenuServiceImpl implements MenuService {

    @Autowired
    private MenuDao menuDao;


    /**
     * 获取文件夹目录
     *
     * @param pid
     * @return
     */
    @Override
    public List<Menu> getMenuList(String pid , String indexName) {
//        List<Menu> byPid = menuDao.findByPid(pid);

        List<Menu> list = menuDao.findByPidAndIndexName(pid, indexName);

        for (Menu menu : list) {
            int i = menuDao.countMenuByPid(menu.getId());
            if (i > 0) {
                //该菜单有子节点
                menu.setState("closed");
            }
        }
        return list;
    }

    /**
     * 新增目录
     *          改为不在本地同步更新文件夹, 只需添加虚拟目录
     *              新增: 分为“库”→“目录”→“对象”三级结构；每一级结构都包括增删改查的功能；
     *
     * @param menu
     * @return
     */
    @Override
    @Transactional
    public GlobalResult insertMenu(Menu menu) {
        //获取pid
        String pid = menu.getPid();
        if ("root".equals(pid)) {
            //库下根目录

        }
        //定义文件夹名称
        String text = getText(menu, pid);
        //根据pid查找url
        Menu pmenu = menuDao.findById(pid).orElse(new Menu());

        String purl = pmenu.getUrl() == null? "E:" : pmenu.getUrl();
        //拼接该目录的url
        String url = purl + "/" + text;

        //设置id
        String generateId = TNOGenerator.generateId();
        menu.setId(generateId);
        //设置url
        menu.setUrl(url);
        //设置名称
        menu.setText(text);
        //保存
        Menu data = menuDao.save(menu);
        return new GlobalResult(true, 2000, "干的漂亮");
    }

    //获取目录名称
    private String getText(Menu menu, String pid) {
        //判断当前节点中是否有存在的名称
        String text = menu.getText();
        List<Menu> menuList = menuDao.findByPid(pid);
        //如果名称重复, 加个标识符, 例: 新建文件夹(1)
        int i = 1;
        String temp = text;
        for (Menu m : menuList) {
            if (temp.equals(m.getText())) {
                temp = text + "(" + i + ")";
                i++;
            }
        }
        text = temp;
        return text;
    }

    /**
     * 编辑目录
     *
     * @param menu
     * @return
     */
    @Transactional
    @Override
    public GlobalResult updateMenu(Menu menu) {
        //如果此id是根目录, 不执行方法
        String pid = menu.getPid();
        if ("000000000000000000".equals(pid)) {
            return new GlobalResult(false, 2001, "根目录不允许修改");
        }
        //提取老菜单
        Menu oldMenu = menuDao.findById(menu.getId()).orElse(new Menu());
        //获取原有文件夹
        String oldUrl = oldMenu.getUrl();
        //定义文件夹名称
        String text = getText(menu, pid);
        //根据名称定义url
        Menu pmenu = menuDao.findById(pid).orElse(new Menu());
        String purl = pmenu.getUrl();
        //拼接该目录的url
        String url = purl + "/" + text;
        //设置新名称
        menu.setText(text);
        //设置新路径
        menu.setUrl(url);
        //保存
        Menu save = menuDao.save(menu);//此时菜单中有id存在, 执行更新操作

        //修改本地文件夹
//        java.io.File file = new java.io.File(oldUrl);
//        boolean rename = file.renameTo(new File(url));
        if (save != null) {
            return new GlobalResult(true, 2000, "操作成功");
        }

        return new GlobalResult(false, 2001, "操作失败");
    }

    /**
     * 删除目录及目录下的所有文件
     * @param id
     * @return
     */
    @Override
    public GlobalResult delete(String id) {
        //如果此id是根目录, 不执行删除方法
        String pid = menuDao.findById(id).get().getPid();
        if ("000000000000000000".equals(pid)) {
            return new GlobalResult(false, 2001, "操作失败");
        }
        //删除本地文件夹
        Menu menu = menuDao.findById(id).orElse(new Menu());
        boolean file = delUrlLocalFile(menu.getUrl());

        //根据id删除目录及其子目录
        boolean es = recursiveDelete(id);

        if (es && file) {
            return new GlobalResult(true, 2000, "干得漂亮");
        }
        return new GlobalResult(false, 2001, "错误! 请再仔细看看哪里有问题");
    }

    /**
     * 递归删除es中目录数据
     * @param id
     * @return
     */
    private boolean recursiveDelete(String id){
        try {
            //根据id查找目录及其子目录
            Menu menu = menuDao.findById(id).orElse(new Menu());//当前目录
            List<Menu> menuList = menuDao.findByPid(id);//子目录

            //删除当前目录
            menuDao.delete(menu);

            //遍历其子目录
            for (Menu m : menuList) {
                //执行当前方法
                recursiveDelete(m.getId());
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 递归删除文件夹及文件夹下所有的文件
     * @param urlPath
     * @return boolean
     */
    private static boolean delUrlLocalFile(String urlPath) {
        if (urlPath == null) {
            return false;
        }
        try {
            java.io.File file = new java.io.File(urlPath);
            if(file.isDirectory()){
                java.io.File[] files = file.listFiles();
                assert files != null;
                if(files.length>0){
                    for (java.io.File tmpFile:files) {
                        delUrlLocalFile(tmpFile.getAbsolutePath());
                    }
                }
                boolean delete = file.delete();
            }else{
                if(file.exists()){
                    boolean delete = file.delete();
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //测试递归
    public static void main(String[] args) {
        delUrlLocalFile("F:/delete");
    }

}
