package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.pojo.IndexMenu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.IndexMenuService;
import com.ecspace.business.knowledgeCenter.administrator.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.List;

/**
 *  index菜单
 *
 * @author zhangch
 * @date 2019/12/3 0012 下午 16:27
 */
@RestController
@RequestMapping("/indexMenu")
public class IndexMenuController {

    @Autowired
    private IndexMenuService indexMenuService;

    /**
     * 获取库目录
     * @return
     */
    @PostMapping("/listIndexMenu")
    public List<IndexMenu> listIndexMenu(){
        return indexMenuService.listIndexMenu();
    }

    /**
     * 创建
     */
    @PostMapping("/create")
    public GlobalResult create(IndexMenu indexMenu) throws ParseException {
        return indexMenuService.save(indexMenu);
    }

    /**
     * 删除
     */
    @PostMapping("/delete")
    public GlobalResult delete(String indexName){
        return indexMenuService.delete(indexName);
    }




}
