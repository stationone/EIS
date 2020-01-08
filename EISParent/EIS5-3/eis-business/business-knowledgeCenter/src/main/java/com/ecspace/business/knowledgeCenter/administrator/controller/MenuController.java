package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.MenuService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *  菜单
 *
 * @author zhangch
 * @date 2019/11/12 0012 下午 16:27
 */
@RestController
@RequestMapping("/menu")
public class MenuController {

    @Autowired
    private MenuService menuService;

    /**
     * 获取文件夹目录, 递归所有的目录及根目录文件夹, 返回
     * @return
     */
    @GetMapping("/listTree")
    public List<Menu> listTree(String id , String indexName){

        if(id == null || "".equals(id)){
            //第一次加载, 设置pid为000000000000000000
                    //改为root
            id = "root";
        }
        //从elasticsearch中的document中获取文件夹目录列表
        return menuService.getMenuList(id , indexName);
    }

    /**
     * 目录表单操作
     */
    @LogAnno(operateType = "文档管理/目录添加或修改")

    @PostMapping("/submit")
    public GlobalResult create(Menu menu){
        if (menu == null || "".equals(menu.getText())) {
            return new GlobalResult(false, 2001,"非法参数");
        }
        if (menu.getId() == null || "".equals(menu.getId())) {
            //新建
            return menuService.insertMenu(menu);
        } else {
            //编辑
//            return menuService.insertMenu(menu);
            return menuService.updateMenu(menu);

        }
    }

    /**
     * 目录表单操作
     */
    @LogAnno(operateType = "文档管理/目录删除")

    @PostMapping("/delete")
    public GlobalResult delete(String id){
        if (id == null) {
            return new GlobalResult(false, 2001,"非法参数");
        }

        return menuService.delete(id);
    }

//    public static void main(String[] args) {
//        //创建根节点
//
//        Menu menu = new Menu();
//        menu.setPid("000000000000000000");
//        menu.setUrl("E:/knowledgeCenter");
//        menu.setText("knowledgeCenter");
//        menu.setId(TNOGenerator.generateId());
//        menuService.insertMenu(menu);
//    }




}
