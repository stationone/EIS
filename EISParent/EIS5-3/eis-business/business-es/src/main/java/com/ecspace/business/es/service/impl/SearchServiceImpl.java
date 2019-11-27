package com.ecspace.business.es.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.es.pojo.Column;
import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.service.ElasticsearchService;
import com.ecspace.business.es.service.SearchService;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author zhangch
 * @date 2019/11/4 0004 上午 11:13
 */
@Service
public class SearchServiceImpl implements SearchService {

    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;
    @Autowired
    private ElasticsearchService elasticsearchService;
    @Autowired
    private TransportClient client;


    /**
     * 获取跨库表头
     *
     * @param indexNames
     * @return
     */
    @Override
    public List getSearchTitle(List<String> indexNames) {
        Set<String> fields = new HashSet<String>();
        for (String indexName : indexNames) {
            List<String> indexField = elasticsearchService.getIndexField(indexName);
            if (indexField == null) {
                return new ArrayList();
            }
            fields.addAll(indexField);
        }
        //开始封装页面需要的表头数据
        List<Column> columnList = new ArrayList<Column>();

        for (String s : fields) {

            Column column = new Column();
            column.setField(s);
            column.setTitle(s);
            column.setWidth(250);

            column.setSortable(true);

            columnList.add(column);
        }

        //再套一层
        List titleList = new ArrayList();
        titleList.add(columnList);

        return titleList;

    }

    /**
     * 跨库查询
     *
     * @param indexNames
     * @param json
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @Override
    public PageData searchAll(String[] indexNames, String json, Integer page, Integer rows, String sort, String order) {
        //获取客户端, 构建查询
        Client client = elasticsearchTemplate.getClient();//获取客户端
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();//构建查询


        //设置分页参数
        if (page > 0 && rows > 0) {
            searchRequestBuilder.setFrom((page - 1) * rows);
            searchRequestBuilder.setSize(rows);
        }

/*        //设置排序规则 只能设置数字, 日期类型
        if (!StringUtils.isBlank(sort) && !StringUtils.isBlank(order)) {

            searchRequestBuilder.addSort(sort, SortOrder.fromString(order));

        }*/
        searchRequestBuilder.setExplain(true);//按照匹配度排序
        searchRequestBuilder.setSearchType(SearchType.QUERY_THEN_FETCH);//默认查询方式
        searchRequestBuilder.setIndices(indexNames);//检索的目标index

        //构建布尔查询
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        //高亮构建
        HighlightBuilder highlightBuilder = new HighlightBuilder();

        //设置高亮前后缀(页面高亮的标签)
        highlightBuilder.preTags("<tag style=\"color: red;\">");//设置前缀
        highlightBuilder.postTags("</tag>");//设置后缀

        JSONObject jsonObject = JSON.parseObject(json);//表单数据[{'search',''},{'',''},{'',''}后边动态获取]
        String search = (String) jsonObject.get("search");//获取搜索框中的检索词
        if (StringUtils.isBlank(search)) {
            //无检索词, 进行全部搜索高级检索中, 设置关系为must, 符合条件的数据进行响应
            boolQueryBuilder.must(QueryBuilders.matchAllQuery());//匹配所有

        } else {
            //有检索词, 进行多字段匹配的同时进行基础字段的高级检索, 提取字段
            HashMap<String, String[]> stringHashMap = elasticsearchService.getStringHashMap(indexNames);
            String[] analyzerArrs = stringHashMap.get("analyzerArr");
            String[] notAnalyzerArrs = stringHashMap.get("notAnalyzerArr");
            String[] allFields = (String[]) ArrayUtils.addAll(analyzerArrs, notAnalyzerArrs);

            if (allFields != null && allFields.length > 0) {
                boolQueryBuilder.must(QueryBuilders.multiMatchQuery(search, allFields)).minimumShouldMatch("80%");
                //对字段挨个进行高亮配置
                for (String s : allFields) {
                    highlightBuilder.field(s);
                }
            }
            //剔除没个字段精确匹配, 和多字段匹配冲突, 在此全部换成多字段匹配
            /*  if (notAnalyzerArrs != null && notAnalyzerArrs.length > 0) {
                for (String notAnalyzerArr : notAnalyzerArrs) {
                    boolQueryBuilder.must(QueryBuilders.termQuery(notAnalyzerArr, search));
                }
            }*/

        }
        //高级检索处理
        //1. 剔除"search"and"dateScope"
        jsonObject.remove("search");
        jsonObject.remove("dateScope");
        //2. 提取所有的基础text字段
        Set<String> keySet = jsonObject.keySet();

        for (String s : keySet) {
            String value = (String) jsonObject.get(s);
            if (!StringUtils.isBlank(value)) {
                //字段值不为空, 一对一进行匹配
                boolQueryBuilder.must(QueryBuilders.matchQuery(s, value))
                        .minimumShouldMatch("80%");
                //对每个key匹配到的值进行高亮显示
                highlightBuilder.field(s);
            }
        }

        searchRequestBuilder.highlighter(highlightBuilder);
        searchRequestBuilder.setQuery(boolQueryBuilder);
        SearchResponse searchResponse = searchRequestBuilder.get();

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
        Long totalHits = hits.getTotalHits();//匹配到的总条数
        pageData.setTotal(totalHits.intValue());//设置pageData

        //        System.out.println(hits.getTotalHits());// 打印总条数
        SearchHit[] searchHits = hits.getHits();
        //创建一个集合存储数据

        for (SearchHit searchHit : searchHits) {

            //源文档内容
            Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
            //取出高亮内容, 并替换源文档内容
            Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
            if (highlightFields != null) {
                //遍历高亮字段数组
                for (String field : highlightFields.keySet()) {
                    //对每个高亮字段进行处理
                    HighlightField nameField = highlightFields.get(field);
                    if (nameField != null) {
                        Text[] fragments = nameField.getFragments();
                        StringBuffer stringBuffer = new StringBuffer();
                        for (Text str : fragments) {
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

//    /**
//     * 条件查询
//     *
//     * @param indexNames
//     * @param json
//     * @param page
//     * @param rows
//     * @param sort
//     * @param order
//     * @return
//     */
//    @Override
//    public List searchList(String[] indexNames, String json, Integer page, Integer rows, String sort, String order) {
//        //搜索请求对象
//        SearchRequest searchRequest = new SearchRequest(indexNames);
//        //指定类型
//        //searchRequest.types(indexName);
//        //搜索源构建对象
//        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
//
//        //创建bool查询, 使用or 即should
//        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
//
//        //设置分页参数
//        //计算出记录起始下标
//        int from = (page - 1) * rows;
//        searchSourceBuilder.from(from);//起始记录下标，从0开始
//        searchSourceBuilder.size(rows);//每页显示的记录数
//
//        //设置高亮有哪些字段
//        String[] highlightField = null;
//        //搜索方式, 使用bool搜索方式
//
//        //解析搜索关键词
//        String search = (String) JSON.parseObject(json).get("search");
//
//        //提取建立了索引并进行分词的text字段
//        List<IndexField> IndexFieldList = null;
//        for (String indexName : indexNames) {
//            IndexFieldList = elasticsearchService.getFieldAndMapping(indexName).getRows();
//        }
//
//        //拼接可被查询且分词的字段名, 和可被查询但不分词的字段名
//        StringBuilder indexAndAnalyzer = new StringBuilder();
//        StringBuilder indexNotAnalyzer = new StringBuilder();
//        elasticsearchService.joint(IndexFieldList, indexAndAnalyzer, indexNotAnalyzer);
//
//        //转换成String数组
//        String[] strings = {};
//        if (indexAndAnalyzer.toString().length() > 0) {
//            strings = indexAndAnalyzer.toString().split(",");
//        }
//
//        //先定义一个MultiMatchQuery, 参数意义(参数, 字段列表)
//        if (strings.length > 0) {
//            MultiMatchQueryBuilder multiMatchQueryBuilder = QueryBuilders.multiMatchQuery(search, strings)
//                    //匹配度达到多少百分比就算合格
//                    .minimumShouldMatch("80%");
//            //设置某个字段的分值, 该字段匹配度越高, 排名越靠前
////                    .field("name", 10);
//            boolQueryBuilder.should(multiMatchQueryBuilder);
//        }
//
//        //获取检索的所有key{search,field,field,...}
//        JSONObject jsonObject = JSON.parseObject(json);
//        Set<String> searchKey = jsonObject.keySet();
//        searchKey.remove("search");
//        //如果key值不存在, 则全字段模糊匹配, 存在则根据传入字段精确匹配
//        jsonObject.remove("search");
//        if ("all".equals(jsonObject.get("dateScope"))) {
//            jsonObject.remove("dateScope");
//            Collection<Object> values = jsonObject.values();
//            StringBuilder stringBuilder = new StringBuilder();
//            for (Object value : values) {
//                stringBuilder.append(value);
//            }
//
//            if ("".equals(stringBuilder.toString())) {
//                //普通检索, 模糊匹配所有字段
//
//                //再定义一个termQuery , 由于String 数组的原因, 可以建立多个(参数: 字段名, 参数)
//                String[] stringArr = {};
//                if (indexNotAnalyzer.toString().length() > 0) {
//                    stringArr = indexNotAnalyzer.toString().split(",");
//                }
//                if (stringArr.length > 0) {
//                    for (String s : stringArr) {
//                        TermQueryBuilder termQueryBuilder = QueryBuilders.termQuery(s, search);
//                        //bool匹配设置为must, 多条件全匹配是有效文档
//                        boolQueryBuilder.should(termQueryBuilder);
//                    }
//                }
//
//
//                //设置高亮字段, 动态设置
//                //将待查询的两个数组字段进行合并
//                highlightField = (String[]) ArrayUtils.addAll(strings, stringArr);
//            } else {
//                jsonObject.remove("dateScope");
//                //精确匹配, 传入的字段
////                {search,field1, field2, }
//                Set<String> stringSet = jsonObject.keySet();
//                stringSet.remove("search");
//                for (String string : stringSet) {
//                    //                    精确的模糊查询, 每个值和每个字段进行匹配
//                    MultiMatchQueryBuilder multiMatchQueryBuilder = QueryBuilders.multiMatchQuery(jsonObject.get(string), string).minimumShouldMatch("80%");
//                    boolQueryBuilder.must(multiMatchQueryBuilder);
//                }
//
//                highlightField = (String[]) ArrayUtils.addAll(strings, stringSet.toArray());
//            }
//
//        }
//
//
//        //高亮显示构建
//        HighlightBuilder highlightBuilder = new HighlightBuilder();
//        //设置高亮前后缀(页面高亮的标签)
//        highlightBuilder.preTags("<tag style=\"color: red;\">");//设置前缀
//        highlightBuilder.postTags("</tag>");//设置后缀
//
//
//   /*     highlightBuilder.field("name");//设置高亮字段
//        highlightBuilder.field("description");//设置高亮字段*/
//
//        //[field]进行高亮构建
//        if (highlightField.length > 0) {
//            for (String field : highlightField) {
//                //对每个字段进行高亮构建
//                highlightBuilder.field(field);
//            }
//        }
//
//        //设置搜索高亮构件
//        searchSourceBuilder.highlighter(highlightBuilder);
//        //设置搜索方式为bool查询
//        searchSourceBuilder.query(boolQueryBuilder);
//        //设置排序
//        if (!StringUtils.isBlank(sort) && !StringUtils.isBlank(order)) {
//            searchSourceBuilder.sort(sort, SortOrder.fromString(order));
//        }
////        设置时间范围
//
////        QueryBuilders.rangeQuery("dateScope");
//        //设置源字段过虑,第一个参数结果集包括哪些字段，第二个参数表示结果集不包括哪些字段
////        searchSourceBuilder.fetchSource(new String[]{"name","studymodel","price","timestamp"},new String[]{});
//        //向搜索请求对象中设置搜索源
//        searchRequest.source(searchSourceBuilder);
//        //执行搜索,向ES发起http请求
////        SearchResponse searchResponse = client.search(searchRequest);
//        SearchResponse searchResponse = client.search(searchRequest).actionGet();
//        //搜索结果
//        SearchHits hits = searchResponse.getHits();
//        //匹配到的总记录数
//        long totalHits = hits.getTotalHits();
//        //得到匹配度高的文档
//        SearchHit[] searchHits = hits.getHits();
////        日期格式化对象
//        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        List list = new ArrayList();
//        for (SearchHit hit : searchHits) {
//            //文档的主键
//            String id = hit.getId();
//            String type = hit.getType();
//
//            //源文档内容
//            Map<String, Object> sourceAsMap = hit.getSourceAsMap();
//            //取出高亮内容
//            Map<String, HighlightField> highlightFields = hit.getHighlightFields();
//            if (highlightFields != null) {
//                //遍历高亮字段数组
//                for (String field : highlightField) {
//                    //对每个高亮字段进行处理
//                    HighlightField nameField = highlightFields.get(field);
//                    if (nameField != null) {
//                        Text[] fragments = nameField.getFragments();
//                        StringBuffer stringBuffer = new StringBuffer();
//                        for (Text str : fragments) {
//                            stringBuffer.append(str.string());
//                        }
////                    name = stringBuffer.toString();
//                        //替换原文档内容为高亮内容
//                        sourceAsMap.put(field, stringBuffer.toString());
//                    }
//                }
//            }
//            list.add(sourceAsMap);
//        }
//        return list;
//    }

}
