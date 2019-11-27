package com.ecspace.business.es.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.Index;
import com.ecspace.business.es.pojo.T;
import com.ecspace.business.es.service.impl.EsService;
import org.elasticsearch.common.xcontent.XContentType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Set;

/**
 * @Auther: menb
 * @Date: 2019/8/5
 * @Description: com.ecspace.business.es.controller
 * @version:
 */
@RestController
@RequestMapping("/es")
public class EsController {
    @Autowired
    private ElasticsearchTemplate template;
    @Autowired
    private EsService esService;

    @RequestMapping(value = "/deleteIndex")
    public Ajax deleteIndex(String indexName) throws Exception {
        template.deleteIndex(indexName);
        esService.deleteIndexFiled(indexName);
        return new Ajax("删除成功!", true);
    }

    @RequestMapping(value = "/addIndex")
    public Ajax addIndex(String indexName) throws Exception {
        template.createIndex(indexName);
        return new Ajax("新增成功!", true);
    }

    @RequestMapping(value = "/indices")
    public List<T> getIndices() throws Exception {

        return esService.getIndices();
    }

    @RequestMapping(value = "/getIndex")
    public Index getByIndex(String indexName) throws Exception {
        return esService.getByIndex(indexName);
    }

    @RequestMapping(value = "/getList")
    public List getList(String indexName, String json) throws Exception {
        if (json != null) {
            JSONObject o = JSON.parseObject(json);
            Set<String> strings = o.keySet();
            if (strings.isEmpty())
                return esService.getByIndex(indexName).getList();
            else
                return esService.getByValue(indexName,o);
        }else
            return esService.getByIndex(indexName).getList();
    }

    @RequestMapping(value = "/deleteDocument")
    public Ajax deleteDocument(String indexName, String type, String gridId) throws Exception {
        esService.deleteDocument(indexName, type, gridId);
        return new Ajax("删除成功!", true);
    }

    @RequestMapping(value = "/addDocument")
    public Ajax addDocument(String json, String indexName) throws Exception {
        JSONObject o = JSON.parseObject(json);
        template.getClient().prepareIndex(indexName, indexName).setSource(o.toString(), XContentType.JSON).get();
        return new Ajax("新增成功!", true);
    }

    @RequestMapping(value = "/updateDocument")
    public Ajax updateDocument(String json, String indexName, String id) throws Exception {
        JSONObject o = JSON.parseObject(json);
        template.getClient().prepareUpdate(indexName, indexName,id).setDoc(o).setId(id).get();
        return new Ajax("更新成功!", true);
    }

}
