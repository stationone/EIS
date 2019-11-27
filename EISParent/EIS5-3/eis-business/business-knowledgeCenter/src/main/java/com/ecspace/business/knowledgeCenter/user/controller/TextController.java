package com.ecspace.business.knowledgeCenter.user.controller;

import com.ecspace.business.knowledgeCenter.user.service.TextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/text")
public class TextController {
    @Autowired
    private TextService userService;

    @RequestMapping("/demo1")
    public String login(){
        System.out.println("测试后台");
        System.out.println(userService.list());


        return "成功";
    }

}
