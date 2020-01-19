package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.employeeCenter.entity.User;
import com.ecspace.business.knowledgeCenter.administrator.dao.UserHouseDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.UserHouse;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.UserHouseService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 用户收藏
 * @author zhangch
 * @date 2020/1/17 0017 下午 17:46
 */
@Service
public class UserHouseServiceImpl implements UserHouseService {

    @Autowired
    private UserHouseDao userHouseDao;


    @Override
    public List<UserHouse> userHouseList(String pid, String userName) {
        List<UserHouse> list = userHouseDao.findByPidAndUserName(pid, userName);

        for (UserHouse userHouse : list) {
            int i = userHouseDao.countMenuByPid(userHouse.getId());
            if (i > 0) {
                //该菜单有子节点
                userHouse.setState("closed");
//                menu.setChildren(menuDao.findByPid(menu.getId()));
//                menu.setState("open");
            }
        }
        return list;
    }

    @Override
    public GlobalResult insertUserHouse(UserHouse userHouse) {
        //获取pid
        String pid = userHouse.getPid();
        if ("root".equals(pid)) {
            //库下根目录

        }
        //定义文件夹名称
        String text = getText(userHouse, pid);
        //根据pid查找url
        //设置id
        String generateId = TNOGenerator.generateId();
        userHouse.setId(generateId);
        //设置名称
        userHouse.setText(text);
        UserHouse house = userHouseDao.save(userHouse);
        return new GlobalResult(true, 2000, "ok", house);
    }

    @Override
    public GlobalResult updateUserHouse(UserHouse userHouse) {


        //如果此id是根目录, 不执行方法
        String pid = userHouse.getPid();
        if ("000000000000000000".equals(pid)) {
            return new GlobalResult(false, 2001, "根目录不允许修改");
        }
        //提取老菜单
        UserHouse oldHouse = userHouseDao.findById(userHouse.getId()).orElse(new UserHouse());
        //获取原有文件夹
        String oldUrl = oldHouse.getUrl();
        //定义文件夹名称
        String text = getText(userHouse, pid);
        //根据名称定义url
        UserHouse phouse = userHouseDao.findById(pid).orElse(new UserHouse());
        String purl = phouse.getUrl();
        //拼接该目录的url
        String url = purl + "/" + text;
        //设置新名称
        userHouse.setText(text);
        //设置新路径
        userHouse.setUrl(url);
        //保存
        UserHouse save = userHouseDao.save(userHouse);//此时菜单中有id存在, 执行更新操作

        if (save != null) {
            return new GlobalResult(true, 2000, "操作成功");
        }

        return new GlobalResult(false, 2001, "操作失败");
    }

    @Override
    public GlobalResult delete(String id) {
        //如果此id是根目录, 不执行删除方法
        String pid = userHouseDao.findById(id).get().getPid();
        if ("000000000000000000".equals(pid)) {
            return new GlobalResult(false, 2001, "操作失败");
        }
        //删除本地文件夹
        UserHouse userHouse = userHouseDao.findById(id).orElse(new UserHouse());
//        boolean file = delUrlLocalFile(userHouse.getUrl());

        //根据id删除目录及其子目录
        boolean es = recursiveDelete(id);

        if (es) {
            return new GlobalResult(true, 2000, "干得漂亮");
        }
        return new GlobalResult(false, 2001, "错误! 请再仔细看看哪里有问题");
    }

    /**
     * 递归删除es中目录数据
     *
     * @param id
     * @return
     */
    private boolean recursiveDelete(String id) {
        try {
            //根据id查找目录及其子目录
            UserHouse userHouse = userHouseDao.findById(id).orElse(new UserHouse());//当前目录
            List<UserHouse> userHouseList = userHouseDao.findByPid(id);//子目录

            //删除当前目录
            userHouseDao.delete(userHouse);

            //遍历其子目录
            for (UserHouse m : userHouseList) {
                //执行当前方法
                recursiveDelete(m.getId());
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //获取目录名称
    private String getText(UserHouse userHouse, String pid) {
        //判断当前节点中是否有存在的名称
        String text = userHouse.getText();
        List<UserHouse> userHouseList = userHouseDao.findByPid(pid);
        //如果名称重复, 加个标识符, 例: 新建文件夹(1)
        int i = 1;
        String temp = text;
        for (UserHouse m : userHouseList) {
            if (temp.equals(m.getText())) {
                temp = text + "(" + i + ")";
                i++;
            }
        }
        text = temp;
        return text;
    }
}
