package com.ecspace.business.es.controller;

import com.alibaba.fastjson.JSON;
import com.ecspace.business.es.pojo.Index;
import com.ecspace.business.es.pojo.T;
import com.ecspace.business.es.service.impl.EsService;
import org.elasticsearch.action.admin.indices.get.GetIndexResponse;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;

/**
 * @Auther: menb
 * @Date: 2019/7/30
 * @Description: com.ecspace.business.es.controller
 * @version:
 */
@RestController
@RequestMapping("/testes")
public class TestController {

    /*@Autowired
    ArticleRepository articleRepository;*/
    @Autowired
    private ElasticsearchTemplate template;
    @Autowired
    private EsService esService;


    @RequestMapping(value = "/e")
    public List<T> te() throws Exception{
        Settings settings = Settings.builder().put("cluster.name", "elasticsearch").build();
        // 创建client
        TransportClient client = new PreBuiltTransportClient(settings)
                .addTransportAddress(new TransportAddress(InetAddress.getByName("127.0.0.1"), 9300));
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

    @RequestMapping(value = "/ee")
    public List<Index> ee() throws Exception{

        Client client = template.getClient();

        GetIndexResponse response = client.admin().indices().prepareGetIndex().execute().actionGet();
        List<Index> list = new ArrayList<>();
        String[] indices = response.getIndices();
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        SearchResponse response1 = searchRequestBuilder.setSize(9999).execute().actionGet();
        //SearchResponse response1 = searchRequestBuilder.setQuery(QueryBuilders.matchQuery("_index","pdm_menu")).setSize(9999).execute().actionGet();
        SearchHits hits = response1.getHits();
        for (String indice : indices) {
            Index index = new Index(indice);
            List list1 = new ArrayList();
            for (int i = 0; i < hits.getHits().length; i++) {
                SearchHit hit = hits.getHits()[i];
                if (indice.equals(hit.getIndex())) {
                    String s = hit.getSourceAsString();
                    Object parse = JSON.parse(s);
                    index.setTypeName(hit.getType());
                    list1.add(parse);
                }
            }
            index.setList(list1);
            list.add(index);
            list1=null;
        }
        return list;
    }

    /*@RequestMapping(value = "/a")
    public List<Article> aa() throws Exception{
        return esService.a();
    }*/
}
