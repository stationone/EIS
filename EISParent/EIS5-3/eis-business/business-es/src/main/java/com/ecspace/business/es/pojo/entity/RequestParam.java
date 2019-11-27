package com.ecspace.business.es.pojo.entity;

import org.springframework.data.domain.Page;

import java.util.Date;
import java.util.List;

/**
 * 查询入参
 * @author zhangch
 * @date 2019/10/17 0017 下午 19:28
 */
public class RequestParam {

    //索引名称集合
   private List<String> indexNames;

    //分页参数
   private Integer page;
   private Integer rows;
    //日期区间
   private String startDate;
   private String endDate;

    //排序字段
   private String sort;
    //排序规则
   private String order;

    //搜索关键词
   private String search;



}
