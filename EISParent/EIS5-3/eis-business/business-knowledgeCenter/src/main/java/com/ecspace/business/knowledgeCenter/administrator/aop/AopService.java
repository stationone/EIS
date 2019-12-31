package com.ecspace.business.knowledgeCenter.administrator.aop;

import org.springframework.stereotype.Service;

/**
 * @author zhangch
 * @date 2019/12/31 0031 上午 11:26
 */
@Service
public class AopService {
    // 用户登入
    public void login() {
        System.out.println("登入成功");
    }

    // 用户退出
    public void loginOut() {
        System.out.println("用户退出系统");
    }

    // 用户操作
    public void writeABlog() {
        System.out.println("用户编写博客");
    }

    // 用户操作
    public void deleteABlog() {
        System.out.println("用户删除博客");
    }
}
