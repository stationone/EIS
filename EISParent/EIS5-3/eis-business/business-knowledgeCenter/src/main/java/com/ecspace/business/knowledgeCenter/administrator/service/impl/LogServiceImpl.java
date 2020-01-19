package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.LogDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Log;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.LogService;
import com.ecspace.business.knowledgeCenter.administrator.util.ESUtil;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.RangeQueryBuilder;
import org.elasticsearch.index.query.TermQueryBuilder;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.elasticsearch.search.sort.SortOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author zhangch
 * @date 2020/1/3 0003 下午 13:46
 */
@Service
public class LogServiceImpl implements LogService {

    @Autowired
    private LogDao logDao;

    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;

    /**
     * 获取全部
     *
     * @param page
     * @param size
     * @return
     */
    @Override
    public PageData logList(Integer page, Integer size) {
        if (page == null) {
            page = 0;
        } else {
            page = page - 1;
        }
        if (size == null) {
            size = 10;
        }

        Pageable pageable = PageRequest.of(page, size, Sort.Direction.DESC, "operationDate");
        Page<Log> logPage = logDao.findAll(pageable);
        Long totalElements = logPage.getTotalElements();
        PageData pageData = new PageData();
        pageData.setTotal(totalElements.intValue());
        pageData.setRows(logPage.getContent());
        return pageData;
    }

    /**
     * 删除
     *
     * @return
     */
    @Override
    public GlobalResult deleteLog(String id) {
        logDao.deleteById(id);
        return new GlobalResult(true, 200, "ok", null);
    }

    /**
     * 删除全部
     *
     * @return
     */
    @Override
    public GlobalResult deleteAll() {
        logDao.deleteAll();
        return new GlobalResult(true, 200, "ok", null);
    }

    @Override
    public GlobalResult save(Log log) {
        Log save = logDao.save(log);
        return new GlobalResult(true, 200, "ok", save);
    }

    @Override
    public PageData logList(Integer page, Integer rows, String search, String startTime, String endTime, String sort, String order, String status, String searchDate, Integer dateOrUser) throws ParseException {
        Client client = elasticsearchTemplate.getClient();
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        //设置分页参数
        if (page != null && page > 0 && rows != null && rows > 0) {
            searchRequestBuilder.setFrom((page - 1) * rows);
            searchRequestBuilder.setSize(rows);
        }
        //设置索引库
        searchRequestBuilder.setIndices("log");
        searchRequestBuilder.setExplain(true);//按照匹配度排序

        //构建布尔查询和高亮查询
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        HighlightBuilder highlightBuilder = new HighlightBuilder();
        //设置高亮前后缀(页面高亮的标签)
        highlightBuilder.preTags("<tag style=\"color: red;\">");//设置前缀
        highlightBuilder.postTags("</tag>");//设置后缀

        //查询操作人
        if (search != null && !"".equals(search)) {
            boolQueryBuilder.must(QueryBuilders.wildcardQuery("operator", "*" + search + "*"));//模糊查询
        }

        //设置时间范围
        RangeQueryBuilder operationDate = QueryBuilders.rangeQuery("operationDate");//
        if (startTime != null && !"".equals(startTime)) {
            Long date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime).getTime();
            operationDate.from(date);
        }
        if (endTime != null && !"".equals(endTime)) {
            Long date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime).getTime();
            operationDate.to(date);
        }
        if ((startTime != null && !"".equals(startTime)) || endTime != null && !"".equals(startTime))
            boolQueryBuilder.must(operationDate);

        //设置排序
        SortOrder sortOrder = SortOrder.DESC;
        if (sort == null) {
            sort = "operationDate";
        }
        if (order != null && "asc".equals(order)) {
            sortOrder = SortOrder.ASC;
//            switch (order) {
//                case "asc":
//                    sortOrder = SortOrder.ASC;
//                    break;
//                case "desc":
//
//                    break;
//            }
        }
        searchRequestBuilder.addSort(sort, sortOrder);

        //status : 0 全部 , 1 operationType = 全文检索, 2 operationType != 全文检索
        TermQueryBuilder termQueryBuilder = QueryBuilders.termQuery("operationType", "全文检索");
        if (status == null) {
            status = "0";
        }
        switch (status) {
            case "0":
                break;
            case "1":
                boolQueryBuilder.must(termQueryBuilder);
                break;
            case "2":
                boolQueryBuilder.mustNot(termQueryBuilder);
                break;
        }
//        根据检索日期精确查询
        if (searchDate != null && !"".equals(searchDate)) {//有检索日期
            boolQueryBuilder.must(QueryBuilders.termQuery("dateStr", searchDate));
        }

        searchRequestBuilder.setQuery(boolQueryBuilder);
        highlightBuilder.field("operator");//要展示高亮的字段
        searchRequestBuilder.highlighter(highlightBuilder);

        //执行查询
        SearchResponse searchResponse = searchRequestBuilder.get();
        //处理数据
        //处理数据
//        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        List<Log> list = new ArrayList<Log>();
        List<Log> logTrees = new ArrayList<Log>();
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

        SearchHit[] searchHits = hits.getHits();
        for (SearchHit searchHit : searchHits) {
            //源文档内容
            Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
            //取出高亮内容, 并替换源文档内容
            Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
            //替换yuan为高亮
            ESUtil.replaceSourceWithHighlight(sourceAsMap, highlightFields);
            //将日期详细取出, 分为date和time
            Long operationTime = (Long) sourceAsMap.get("operationDate");
            Date date = new Date(operationTime);
            String dateStr = new SimpleDateFormat("yyyy-MM-dd").format(date);
            String timeStr = new SimpleDateFormat("HH:mm:ss").format(date);
            sourceAsMap.put("dateStr", dateStr);
            sourceAsMap.put("timeStr", timeStr);


            //将sourceAsMap转为实体
            Log log = new Log((String) sourceAsMap.get("id"),
                    (String) sourceAsMap.get("operator"),
                    (String) sourceAsMap.get("operationType"),
                    new Date((Long) sourceAsMap.get("operationDate")),
                    (String) sourceAsMap.get("operationResult"),
                    (String) sourceAsMap.get("ip"),
                    (String) sourceAsMap.get("search"),
                    (String) sourceAsMap.get("dateStr"),
                    (String) sourceAsMap.get("timeStr"));
            //list为没分组的数据
            list.add(log);
        }

        if ( dateOrUser == null || dateOrUser == 0) {
            //按时间分类
            dateSort(list, logTrees);
        } else {
            //按用户分类
            userSort(list, logTrees);
        }



        pageData.setRows(logTrees);
        return pageData;
    }

    /**
     * 按时间分类
     * @param list 源数据 dataList
     * @param logTrees 分类后treeList数据
     */
    public void dateSort(List<Log> list, List<Log> logTrees) {
        Map<String, List<Log>> collect = list.stream().collect(Collectors.groupingBy(Log::getDateStr));
            /*
            2019-1-1 : [log1,log2,log3]
             */
        Set<String> stringSet = collect.keySet();
        Set<String> sortSet = new TreeSet<String>((o1, o2) -> o2.compareTo(o1));
        sortSet.addAll(stringSet);
        for (String key : sortSet) {

            Log logTree  = new Log();
            String id = TNOGenerator.generateId();

            logTree.setId(id);

            logTree.setText(key);
            List<Log> logList = collect.get(key);
//            logList.forEach(log -> log.set_parentId(id));
            for (Log log : logList) {
                log.set_parentId(id);
                log.setText(log.getTimeStr());
            }
//            logTree.setChildren(logList);
            logTree.setState("open");

            //这个logTree就是一个之前的sourceAsMap对象
            //将logTree存入list
            logTrees.add(logTree);
            logTrees.addAll(logList);
        }
//        list.stream().collect();
//        list.stream().collect(Collectors.groupingBy(Log::getDateStr));
    }

    /**
     * 按人员分类
     * @param list 源数据 dataList
     * @param logTrees 分类后treeList数据
     */
    public void userSort(List<Log> list, List<Log> logTrees) {
        Map<String, List<Log>> collect = list.stream().collect(Collectors.groupingBy(Log::getOperator));
            /*
            2019-1-1 : [log1,log2,log3]
             */
        Set<String> stringSet = collect.keySet();
        Set<String> sortSet = new TreeSet<String>((o1, o2) -> o2.compareTo(o1));
        sortSet.addAll(stringSet);
        for (String key : sortSet) {//key --> 系统管理员

            Log logTree  = new Log();
            String id = TNOGenerator.generateId();

            logTree.setId(id);

            logTree.setText(key);
            List<Log> logList = collect.get(key);
//            logList.forEach(log -> log.set_parentId(id));
            for (Log log : logList) {
                log.set_parentId(id);
                log.setText(log.getOperator());
                log.setTimeStr(log.getDateStr() + " " + log.getTimeStr());
            }
//            logTree.setChildren(logList);
            logTree.setState("open");

            //这个logTree就是一个之前的sourceAsMap对象
            //将logTree存入list
            logTrees.add(logTree);
            logTrees.addAll(logList);
        }
//        list.stream().collect();
//        list.stream().collect(Collectors.groupingBy(Log::getDateStr));

    }

}
