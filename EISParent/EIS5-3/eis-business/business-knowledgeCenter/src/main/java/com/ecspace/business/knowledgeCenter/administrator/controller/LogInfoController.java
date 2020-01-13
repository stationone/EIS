package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.pojo.IndexMenu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.IndexMenuService;
import com.ecspace.business.knowledgeCenter.administrator.service.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 *  index菜单
 *
 * @author zhangch
 * @date 2020/1/3 0012 下午 16:26
 */
@RestController
@RequestMapping("/logInfo")
public class LogInfoController {

    @Autowired
    private LogService logService;

    /**
     * 日志列表
     * @param search 操作人
     * @param status 类型
     * @param page 分页
     * @param rows 分页
     * @param sort 排序
     * @param order 排序
     * @param startTime 日期范围
     * @param endTime 日期范围
     * @return 封装对象
     */
    @PostMapping("/listLogInfo")
    public PageData listLogInfo(String search, String status, String startTime, String endTime, Integer page, Integer rows , String sort, String order) throws ParseException {

//        return logService.logList(page, rows);

            return logService.logList(page, rows, search, startTime, endTime, sort, order, status);
    }

//    @PostMapping("/listLogInfo")
//    public PageData listLogInfo(Integer page, Integer rows , String sort, String order){
//
//        return logService.logList(page, rows);
//
////        return logService.logList(page, rows, search, startTime, endTime, sort, order, status);
//    }


    /**
     * 删除
     */
    @LogAnno(operateType = "日志管理/删除")
    @PostMapping("/delete")
    public GlobalResult delete(String id){

        return logService.deleteLog(id);
    }

    /**
     * 清空
     */
    @LogAnno(operateType = "日志管理/清空")
    @PostMapping("/deleteAll")
    public GlobalResult deleteAll(){

        return logService.deleteAll();
    }

}
