package com.ecspace.business.employeeCenter.user.controller;

import com.ecspace.business.employeeCenter.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/login")
    public void login(){
        System.out.println("到后台了");
        System.out.println(userService.list());
        System.out.println("查询结束");
    }



}
