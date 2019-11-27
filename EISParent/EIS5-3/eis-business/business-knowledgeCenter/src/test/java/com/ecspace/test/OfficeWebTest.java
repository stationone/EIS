package com.ecspace.test;

import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.PageDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileDirectoryNode;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Page;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 文件离散测试
 *
 * @author zhangch
 * @date 2019/11/21 0021 下午 15:45
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class OfficeWebTest {

    @Autowired
    PageDao pageDao;

    @Autowired
    ElasticsearchTemplate elasticsearchTemplate;

    @Test
    public void test1(){
        elasticsearchTemplate.createIndex(Page.class);
        elasticsearchTemplate.putMapping(Page.class);

        elasticsearchTemplate.createIndex(FileInfo.class);
        elasticsearchTemplate.putMapping(FileInfo.class);

    }

    @Test
    public void test(){
        Page page = new Page();
        page.setFileId("111");
        page.setPageNO(1);
        page.setContent("本文转载自：ES数据操作 本章就不详细示例ES数据的基本操作，只记录一些知识点，便于读者阅读后面的章节有帮助； 一、文档及文档元数据 对象(object)是一种语言相关，记录在内存中的的数据结...\n" +
                "\n" +
                "淡淡的倔强 02/28  0  0\n" +
                "如何监控Elasticsearch\n" +
                "什么是Elasticsearch Elasticsearch是一个开源的分布式文档存储和搜索引擎，可以近乎实时地存储和检索数据结构，它很大程度上依赖于Apache Lucence--一个用Java编写的全文搜索引擎。 Elasti...\n" +
                "\n" +
                "大蟒传奇 2018/07/03  0  0\n" +
                "\n" +
                "阿里云Elasticsearch性能优化实践\n" +
                "Elasticsearch是一款流行的分布式开源搜索和数据分析引擎，具备高性能、易扩展、容错性强等特点。它强化了Apache Lucene的搜索能力，把掌控海量数据索引和查询的方式提升到一个新的层次。本文...\n" +
                "\n" +
                "小扑 2018/11/16  0  0\n" +
                "Elasticsearch学习（1）—— 简介\n" +
                "【简介】 Elasticsearch ( ES ) 是一个基于 Lucene 的实时分布式开源的全文搜索和分析引擎。它不但稳定、可靠、快速，而且也具有良好的水平扩展能力，是专门为分布式环境设计的。 Elasticsea...\n" +
                "\n" +
                "叶枫啦啦 2018/07/07  159  0\n" +
                "Elasticsearch数据库\n" +
                "1、什么是Elasticsearch 1、概念以及特点 1、Elasticsearch和MongoDB/Redis/Memcache一样，是非关系型数据库。是一个接近实时的搜索平台，从索引这个文档到这个文档能够被搜索到只有一个轻");
//        page.setPdfPage(new File(""));
        page.settNO(111L);
//        page.setKnowledge(new FileInfo());
//        page.setNodeList(new ArrayList<>());

        pageDao.save(page);
    }


    @Autowired
    FileService fileService;
    @Autowired
    FileInfoDao fileDao;
    @Test
    public void test2(){
        Pageable pageable = new PageRequest(1,3);
        org.springframework.data.domain.Page<FileInfo> byMenuId = fileDao.findByMenuId("1911221924470968010", pageable);
        System.out.println(byMenuId.getTotalPages());
        List<FileInfo> content = byMenuId.getContent();
        for (FileInfo fileInfo : content) {
            System.out.println(fileInfo.getFileNamePrefix());
        }
        System.out.println(byMenuId.getNumberOfElements());
        System.out.println(byMenuId.getTotalElements());
//        fileDao.findAll();
    }




    @Test
    public void test3(){
        FileInfo fileInfo = fileDao.findById("1911221941622696173").get();
        System.out.println(fileInfo.getFileNamePrefix());

        List<FileInfo> byMenuId = fileDao.findByMenuId("1911221924470968010");
        byMenuId.forEach(System.out::println);

    }

}
