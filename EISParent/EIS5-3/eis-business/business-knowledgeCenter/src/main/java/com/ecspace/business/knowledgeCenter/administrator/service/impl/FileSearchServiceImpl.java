package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileSearchService;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import com.ecspace.business.knowledgeCenter.administrator.util.ESUtil;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.Client;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
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

            //统计词频
            String content = (String) sourceAsMap.get("content");
            int count = wordCount(content, search);
            sourceAsMap.put("wordCount", count);

            String fileId = (String) sourceAsMap.get("fileId");//根据源文档内容获取fileId
            //根据fileId查找file文档
            FileInfo fileInfo = fileInfoDao.findById(fileId).orElse(new FileInfo());
            //将fileInfo信息一并返回
            /*
            authorName filename keyword creationTime pageTotal downloadCount
             */
            String fileName = fileInfo.getFileName();
            sourceAsMap.put("fileName", fileName);
            sourceAsMap.put("authorName", fileInfo.getUploadUser());
            sourceAsMap.put("keyword", fileInfo.getKeyword());
            sourceAsMap.put("creationTime", fileInfo.getCreationTime());
            sourceAsMap.put("pageTotal", fileInfo.getPageTotal());
            sourceAsMap.put("downloadCount", fileInfo.getDownloadCount());

            //取出高亮内容, 并替换源文档内容
            Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
            ESUtil.replaceSourceWithHighlight(sourceAsMap, highlightFields);
            list.add(sourceAsMap);
        }

        pageData.setRows(list);
        return pageData;
    }

    /**
     * matchAll
     *
     * @param page
     * @param rows
     * @return
     */
    @Override
    public PageData fileList(Integer page, Integer rows , String[] indexNames, String[] menus) {
        if (page == null) {
            page = 0;
        } else {
            page = page - 1;
        }
        if (rows == null) {
            rows = 10;
        }
        Pageable pageable = PageRequest.of(page, rows);
        Page<FileInfo> info = fileInfoDao.findByStatus(4,pageable);//入库文档可被检索

        List<FileInfo> content = info.getContent();
        for (FileInfo fileInfo : content) {
            //正文过长截取
            if (fileInfo.getContent() != null && fileInfo.getContent().length() > 400) {
                String substring = fileInfo.getContent().substring(0, 399);
                fileInfo.setContent(substring);
            }
        }
        return new PageData((int) info.getTotalElements(), info.getContent());
    }

    /**
     * DSL
     *
     * @param search
     * @param page
     * @param rows
     * @return
     */
    @Override
    public PageData fileList(String search, Integer page, Integer rows ,  String[] indexNames, String[] menus) {
        //获取客户端, 构建查询
        Client client = elasticsearchTemplate.getClient();
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        //设置分页参数
        if (page != null && page > 0 && rows != null && rows > 0) {
            searchRequestBuilder.setFrom((page - 1) * rows);
            searchRequestBuilder.setSize(rows);
        }
        //设置索引库
        searchRequestBuilder.setIndices("file");
        searchRequestBuilder.setExplain(true);//按照匹配度排序
        searchRequestBuilder.setSearchType(SearchType.QUERY_THEN_FETCH);//默认搜索方式
        //构建布尔查询和高亮查询
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        HighlightBuilder highlightBuilder = new HighlightBuilder();
        //设置高亮前后缀(页面高亮的标签)
        highlightBuilder.preTags("<tag style=\"color: red;\">");//设置前缀
        highlightBuilder.postTags("</tag>");//设置后缀

        //正文字段进行匹配
        boolQueryBuilder.must(QueryBuilders.multiMatchQuery(search, "content"))
                .minimumShouldMatch("80%");
        //状态码匹配
        boolQueryBuilder.must(QueryBuilders.termQuery("status", 4));//状态为4可被罗列

        //范围缩小
        if (indexNames.length > 0) {//选库
            if (menus.length > 0) {//选目录
                //匹配库和目录
                boolQueryBuilder.must(QueryBuilders.termsQuery("indexName", indexNames));//匹配库
                boolQueryBuilder.must(QueryBuilders.termsQuery("menuId", menus));//匹配目录
            } else {
                //匹配库
                boolQueryBuilder.must(QueryBuilders.termsQuery("indexName", indexNames));//匹配库
            }
        } else {
            if (menus.length > 0) {//没选库单选了目录, 目录id唯一, 匹配目录
                boolQueryBuilder.must(QueryBuilders.termsQuery("menuId", menus));//匹配目录
            }
        }
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

            //统计词频
            String content = (String) sourceAsMap.get("content");
            int count = wordCount(content, search);
            sourceAsMap.put("wordCount", count);

            String fileId = (String) sourceAsMap.get("fileId");//根据源文档内容获取fileId
            //根据fileId查找file文档
            FileInfo fileInfo = fileInfoDao.findById(fileId).orElse(new FileInfo());
            //将fileInfo信息一并返回
            /*
            authorName filename keyword creationTime pageTotal downloadCount
             */
            String fileName = fileInfo.getFileName();
            sourceAsMap.put("fileName", fileName);
            sourceAsMap.put("authorName", fileInfo.getUploadUser());
            sourceAsMap.put("keyword", fileInfo.getKeyword());
            sourceAsMap.put("creationTime", fileInfo.getCreationTime());
            sourceAsMap.put("pageTotal", fileInfo.getPageTotal());
            sourceAsMap.put("downloadCount", fileInfo.getDownloadCount());

            //取出高亮内容, 并替换源文档内容
            Map<String, HighlightField> highlightFields = searchHit.getHighlightFields();
            ESUtil.replaceSourceWithHighlight(sourceAsMap,highlightFields);
            list.add(sourceAsMap);
        }

        pageData.setRows(list);
        return pageData;
    }

    /**
     * 统计词频
     *
     * @param document 查询文档
     * @param word     检索词
     * @return 词频
     */
    private int wordCount(String document, String word) {
        int count = 0;
        while (document.contains(word)) {
            document = document.substring(document.indexOf(word) + word.length());
            count++;
        }
//        System.out.println("指定字符串在原字符串中出现：" + count + "次");
        return count;
    }

}
