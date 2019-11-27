package com.ecspace.business.es.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.Column;
import com.ecspace.business.es.pojo.IndexField;
import com.ecspace.business.es.service.impl.EsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * @Auther: menb
 * @Date: 2019/8/9
 * @Description: com.ecspace.business.es.controller
 * @version:
 */
@RestController
@RequestMapping("/column")
public class ColumnController {

    @Autowired
    private ElasticsearchTemplate template;
    @Autowired
    private EsService esService;

    @RequestMapping(value = "/getTitle")
    public List getTitle(String indexName) {
        List tm_list = new ArrayList<>();
        //List list = esService.getByIndex(indexName).getList();
        Set<String> tittle = esService.getTittle(indexName);
        if (tittle == null) {
            return tm_list;
        } else {
            //自定义JSON格式
            List columns = new ArrayList<>();
            for (String s : tittle) {
                Column column = new Column();
                column.setField(s);
                column.setTitle(s);
                column.setAlign("");
                //column.setWidth(150);
                String json = JSON.toJSONString(column);
                JSONObject object = JSON.parseObject(json);
                columns.add(object);
            }
            tm_list.add(columns);
        }
        System.out.println(tm_list);
        return tm_list;
    }

    @RequestMapping(value = "/addFiled")
    public Ajax addFiled(String indexName, String filedName,String isIndex) {
        return esService.addFiled(indexName,filedName,isIndex);
    }

    @RequestMapping(value = "/getFiled")
    public List<IndexField> getFiledByIndex(String indexName) {
        List<IndexField> filedByIndex = esService.getFiledByIndex(indexName);
        return filedByIndex;
    }
}
