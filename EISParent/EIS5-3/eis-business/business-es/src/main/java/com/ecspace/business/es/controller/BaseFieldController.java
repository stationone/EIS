package com.ecspace.business.es.controller;

import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.BaseField;
import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.service.BaseFieldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 基础字段
 *
 * @author zhangch
 * @date 2019/10/30 0030 下午 20:29
 */
@RestController
@RequestMapping("/baseField")
public class BaseFieldController {

    @Autowired
    private BaseFieldService baseFieldService;

    /**
     * 保存基础字段
     * @return baseField
     */
    @RequestMapping("/save")
    public Ajax save(BaseField baseField){
        if (baseField == null) {
            return new Ajax("参数异常", false);
        }

        if (baseField.getId() != null) {
            //调用修改
            return baseFieldService.updateField(baseField);
        }
            //调用新增
        return baseFieldService.save(baseField);
    }

    @RequestMapping("/updateField")
    public Ajax updateField(BaseField baseField){
        if (baseField == null) {
            return new Ajax("参数异常", false);
        }
        return baseFieldService.updateField(baseField);
    }

    /**
     * 获取所有字段
     * @return baseField
     */
    @RequestMapping("/findAll")
    public PageData findAll(){

        return baseFieldService.findAll();
    }

    /**
     * 删除基础字段
     * @return id
     */
    @RequestMapping("/deleteField")
    public Ajax deleteField(String id){

        return baseFieldService.deleteField(id);
    }

}
