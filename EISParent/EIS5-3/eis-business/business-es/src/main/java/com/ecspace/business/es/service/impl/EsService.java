package com.ecspace.business.es.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.es.dao.IndexFieldDao;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.Index;
import com.ecspace.business.es.pojo.IndexField;
import com.ecspace.business.es.pojo.T;
import org.elasticsearch.action.admin.indices.get.GetIndexResponse;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.Client;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * @Auther: menb
 * @Date: 2019/8/5
 * @Description: com.ecspace.business.es.service
 * @version:
 */
@Service
@Transactional
public class EsService {

    @Autowired
    private ElasticsearchTemplate template;

    @Autowired
    private IndexFieldDao indexFieldDao;

    public List<T> getIndices() {
        Client client = template.getClient();
        GetIndexResponse response = client.admin().indices().prepareGetIndex().execute().actionGet();
        String[] indices = response.getIndices();
        List<T> list = new ArrayList<>();
        for (int i = 0; i < indices.length; i++) {
            T t = new T();
            t.setText(indices[i]);
            list.add(t);
        }
        return list;
    }

    public Index getByIndex(String indexName) {
        Client client = template.getClient();
        GetIndexResponse response = client.admin().indices().prepareGetIndex().execute().actionGet();
        Index index = new Index(indexName);
        //String[] indices = response.getIndices();
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        //SearchResponse response1 = searchRequestBuilder.setSize(9999).execute().actionGet();
        SearchResponse response1 = searchRequestBuilder.setQuery(QueryBuilders.matchQuery("_index", indexName)).setSize(9999).execute().actionGet();
        SearchHits hits = response1.getHits();
        List list = new ArrayList();
        for (int i = 0; i < hits.getHits().length; i++) {
            SearchHit hit = hits.getHits()[i];
            String id = hit.getId();
            String type = hit.getType();
            Map<String, Object> map = hit.getSourceAsMap();
            map.put("id", id);
            map.put("type", type);
            String s = JSON.toJSONString(map);
            Object parse = JSON.parse(s);
            index.setTypeName(hit.getType());
            list.add(parse);
        }
        index.setList(list);
        return index;
    }

    public Set<String> getTittle(String indexName) {
        Client client = template.getClient();
        GetIndexResponse response = client.admin().indices().prepareGetIndex().execute().actionGet();
        Index index = new Index(indexName);
        //String[] indices = response.getIndices();
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        //SearchResponse response1 = searchRequestBuilder.setSize(9999).execute().actionGet();
        SearchResponse response1 = searchRequestBuilder.setQuery(QueryBuilders.matchQuery("_index", indexName)).setSize(9999).execute().actionGet();
        SearchHits hits = response1.getHits();
        Set<String> titles = new HashSet<>();
        for (int i = 0; i < hits.getHits().length; i++) {
            SearchHit hit = hits.getHits()[i];
            String s = hit.getSourceAsString();
            JSONObject jsonObject = JSON.parseObject(s);
            Set<String> keySet = jsonObject.keySet();
            keySet.forEach(ks -> titles.add(ks));
        }
        return titles;
    }

    public void deleteDocument(String indexName, String type, String gridId) {
        template.delete(indexName, type, gridId);
    }

    public Ajax addFiled(String indexName, String filedName,String isIndex) {
        IndexField indexField = indexFieldDao.get(indexName, filedName);
        if (indexField == null){
            indexFieldDao.save(indexName, filedName,isIndex);
            return new Ajax("新增成功!", true);
        }
        else {
            return new Ajax("字段已存在，请勿重复添加!", true);
        }

    }

    public List<IndexField> getFiledByIndex(String indexName) {
        return indexFieldDao.getFieldByIndex(indexName);
    }

    public void deleteIndexFiled(String indexName) {
        indexFieldDao.deleteIndexField(indexName);
    }

    /*public void updateDocument(String indexName) {
        indexFieldDao.deleteIndexFiled(indexName);
    }*/

    public List getByValue(String indexName, JSONObject o) {
        List list = new ArrayList();
        Set<String> strings = o.keySet();
        SearchRequestBuilder searchRequestBuilder = template.getClient().prepareSearch().setIndices(indexName)
                .setTypes(indexName)
                .setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
                .setScroll(TimeValue.timeValueMinutes(30)) //游标维持时间
                .setSize(9999);//实际返回的数量为10*index的主分片数
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        for (String s : strings) {
            String value = o.getString(s);
            if (!"".equals(value)) {
                boolQueryBuilder.must(QueryBuilders.wildcardQuery(s, "*" + o.getString(s).toLowerCase() + "*"));
                //searchRequestBuilder = searchRequestBuilder.setQuery(QueryBuilders.wildcardQuery(s, "*" + o.getString(s) + "*"));
            }
        }
        searchRequestBuilder.setQuery(boolQueryBuilder);
        SearchResponse response = searchRequestBuilder.execute().actionGet();
        SearchHits hits = response.getHits();
        for (int i = 0; i < hits.getHits().length; i++) {
            SearchHit hit = hits.getHits()[i];
            if (indexName.equals(hit.getIndex())) {
                String s = hit.getSourceAsString();
                Object parse = JSON.parse(s);
                list.add(parse);
            }
        }
        return list;
    }
}
