package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.employeeCenter.entity.User;
import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.dao.UserInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.UserHouse;
import com.ecspace.business.knowledgeCenter.administrator.pojo.UserInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.LogService;
import com.ecspace.business.knowledgeCenter.administrator.service.UserHouseService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 *  用户信息
 *
 * @author zhangch
 * @date 2020/1/17 0012 下午 16:26
 */
@RestController
@RequestMapping("/userInfo")
public class UserInfoController {

    @Autowired
    private UserInfoDao userInfoDao;
    @Autowired
    private UserHouseService userHouseService;

    @LogAnno(operateType = "用户/添加")
    @GetMapping("save")
    public void save(){
        UserInfo userInfo = new UserInfo();
        userInfo.setCreationTime(new Date());
        userInfo.setFileIds(new String[]{"1", "2", "3", "4"});
        userInfo.setId(TNOGenerator.generateId());
        userInfo.setUsername("蜡笔小新");
        userInfo.setPassword("123");

        UserInfo save = userInfoDao.save(userInfo);
        System.out.println(save);
    }

    @GetMapping("userList")
    public List<UserInfo> userList(){
        ArrayList<UserInfo> userInfos = new ArrayList<>();
        Iterable<UserInfo> all = userInfoDao.findAll();
        all.forEach(userInfos::add);
        all.forEach(userInfo -> System.out.println(Arrays.toString(userInfo.getFileIds())));
        return userInfos;
    }

    /**
     * 获取文件夹目录, 递归所有的目录及根目录文件夹, 返回
     * @return
     */
    @GetMapping("/listTree")
    public List<UserHouse> listTree(String id , String userName){
        if(id == null || "".equals(id)){
            //第一次加载, 设置pid为000000000000000000
            //改为root
            id = "root";
        }
        //从elasticsearch中的document中获取文件夹目录列表
        return userHouseService.userHouseList(id , userName);
    }

    /**
     * 目录表单操作
     */
    @LogAnno(operateType = "用户收藏/目录添加或修改")
    @PostMapping("/submit")
    public GlobalResult create(UserHouse userHouse){
        if (userHouse == null || "".equals(userHouse.getText())) {
            return new GlobalResult(false, 2001,"非法参数");
        }
        if (userHouse.getId() == null || "".equals(userHouse.getId())) {
            //新建
            return userHouseService.insertUserHouse(userHouse);
        } else {
            //编辑
//            return menuService.insertMenu(menu);
            return userHouseService.updateUserHouse(userHouse);
        }
    }


    /**
     * 目录表单操作
     */
    @LogAnno(operateType = "用户收藏/目录删除")

    @PostMapping("/delete")
    public GlobalResult delete(String id){
        if (id == null) {
            return new GlobalResult(false, 2001,"非法参数");
        }

        return userHouseService.delete(id);
    }

}
