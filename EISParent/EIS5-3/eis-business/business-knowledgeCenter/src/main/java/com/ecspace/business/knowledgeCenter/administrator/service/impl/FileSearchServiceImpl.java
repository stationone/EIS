package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.alibaba.fastjson.JSON;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileSearchService;
import org.apache.lucene.index.Fields;
import org.apache.lucene.index.Terms;
import org.apache.lucene.index.TermsEnum;
import org.apache.lucene.util.BytesRef;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.action.termvectors.MultiTermVectorsRequestBuilder;
import org.elasticsearch.action.termvectors.TermVectorsFields;
import org.elasticsearch.action.termvectors.TermVectorsRequestBuilder;
import org.elasticsearch.action.termvectors.TermVectorsResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * DSL实现类
 *
 * @author zhangch
 * @date 2019/11/26 0026 下午 14:24
 */
@Service
public class FileSearchServiceImpl implements FileSearchService {


    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;

    @Autowired
    private FileInfoDao fileInfoDao;

    /**
     * 无检索词
     *
     * @param menuId
     * @param page
     * @param rows
     * @return
     */
    @Override
    public PageData getFilePageList(String menuId, Integer page, Integer rows) {


        return null;
    }

    /**
     * 有检索词
     *
     * @param menuId
     * @param search
     * @param page
     * @param rows
     * @return
     */
    @Override
    public PageData getFilePageList(String menuId, String search, Integer page, Integer rows) throws IOException {
        //获取搜索词
//        String search = (String) JSON.parseObject(json).get("search");
        //获取客户端, 构建查询
        Client client = elasticsearchTemplate.getClient();
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        //设置分页参数
        if (page != null && page > 0 && rows != null && rows > 0) {
            searchRequestBuilder.setFrom((page - 1) * rows);
            searchRequestBuilder.setSize(rows);
        }
        //设置索引库
        searchRequestBuilder.setIndices("page");
        searchRequestBuilder.setExplain(true);//按照匹配度排序
        searchRequestBuilder.setSearchType(SearchType.QUERY_THEN_FETCH);//默认搜索方式
        //构建布尔查询和高亮查询
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        HighlightBuilder highlightBuilder = new HighlightBuilder();
        //设置高亮前后缀(页面高亮的标签)
        highlightBuilder.preTags("<tag style=\"color: red;\">");//设置前缀
        highlightBuilder.postTags("</tag>");//设置后缀

//        menuId匹配
//        TermVectorsFields fields = new TermVectorsFields();
        //词频
        TermVectorsRequestBuilder termVectorsRequestBuilder = client.prepareTermVectors();
//        MultiTermVectorsRequestBuilder multiTermVectorsRequestBuilder = client.prepareMultiTermVectors();

        TermVectorsResponse termVectorResponse = client.prepareTermVectors().setIndex("page").setType("page")
                .setId("0wsoTCufR7KrXX_OpnXFxw").setSelectedFields("content").setTermStatistics(true).execute()
                .actionGet();
//        Fields fields = termVectorsResponse.getFields();

        XContentBuilder builder = XContentFactory.contentBuilder(XContentType.JSON);
        termVectorResponse.toXContent(builder, null);
        System.out.println(":");
        System.out.println(builder.string());
        Fields fields = termVectorResponse.getFields();
        Iterator<String> iterator1 = fields.iterator();

        Iterator<String> iterator = fields.iterator();
        while (iterator.hasNext()) {
            String field = iterator.next();
            Terms terms = fields.terms(field);
            TermsEnum termsEnum = terms.iterator();
            while (termsEnum.next() != null) {
                BytesRef term = termsEnum.term();
                if (term != null) {
                    System.out.println(":");
                    System.out.println(term.utf8ToString() + termsEnum.totalTermFreq());
                }
            }
        }


//
        //正文字段进行匹配
        boolQueryBuilder.must(QueryBuilders.multiMatchQuery(search, "content"))
                .minimumShouldMatch("80%");
        //字段高亮
        highlightBuilder.field("content");
        searchRequestBuilder.setQuery(boolQueryBuilder);
        searchRequestBuilder.highlighter(highlightBuilder);
        SearchResponse searchResponse = searchRequestBuilder.get();

        //处理数据
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        //提取数据进行封装处理
        PageData pageData = new PageData();//创建一个新的数据对象
        SearchHits hits = null;
        if (searchResponse != null) {
            hits = searchResponse.getHits();
        }
        if (hits == null) {
            return new PageData(new ArrayList());
        }
        Long totalHits = hits.getTotalHits();//匹配到的总条数  page库的总条数
        pageData.setTotal(totalHits.intValue());//设置pageData


        //        System.out.println(hits.getTotalHits());// 打印总条数
        SearchHit[] searchHits = hits.getHits();
        //创建一个集合存储数据

        for (SearchHit searchHit : searchHits) {
            //源文档内容
            Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
            String fileId = (String) sourceAsMap.get("fileId");//根据源文档内容获取fileId
            //根据fileId查找file文档
            FileInfo fileInfo = fileInfoDao.findById(fileId).orElse(new FileInfo());
            //将fileInfo信息一并返回
            /*
            authorName filename keyword creationTime pageTotal downloadCount
             */
            String fileName = fileInfo.getFileName();
            sourceAsMap.put("fileName", fileName);
            sourceAsMap.put("authorName", fileInfo.getAuthorName());
            sourceAsMap.put("keyword", fileInfo.getKeyword());
            sourceAsMap.put("creationTime", fileInfo.getCreationTime());
            sourceAsMap.put("pageTotal", fileInfo.getPageTotal());
            sourceAsMap.put("downloadCount", fileInfo.getDownloadCount());

            //取出高亮内容, 并替换源文档内容
            Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
            if (highlightFields != null) {
//                int size = highlightFields.keySet().size();
                //遍历高亮字段数组
                for (String field : highlightFields.keySet()) {
//                    System.out.println(field);//field代表的是index中的field
                    //对每个高亮字段进行处理
                    HighlightField nameField = highlightFields.get(field);
                    if (nameField != null) {
                        Text[] fragments = nameField.getFragments();

//                        System.out.println(fragments);

                        StringBuffer stringBuffer = new StringBuffer();
                        for (Text str : fragments) {
//                            System.out.println(str);
                            stringBuffer.append(str.string());
                        }
//                    name = stringBuffer.toString();
                        //替换原文档内容为高亮内容
                        sourceAsMap.put(field, stringBuffer.toString());
                    }
                }
            }
            list.add(sourceAsMap);
        }

        pageData.setRows(list);
        return pageData;
    }
}
