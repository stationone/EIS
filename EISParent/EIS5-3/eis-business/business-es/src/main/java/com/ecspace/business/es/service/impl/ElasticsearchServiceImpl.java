package com.ecspace.business.es.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.es.pojo.*;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.service.BaseFieldService;
import com.ecspace.business.es.service.ElasticsearchService;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsResponse;
import org.elasticsearch.action.admin.indices.get.GetIndexResponse;
import org.elasticsearch.action.admin.indices.mapping.get.GetMappingsResponse;
import org.elasticsearch.action.admin.indices.settings.get.GetSettingsRequestBuilder;
import org.elasticsearch.action.admin.indices.settings.get.GetSettingsResponse;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.action.update.UpdateResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.IndicesAdminClient;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.cluster.metadata.MappingMetaData;
import org.elasticsearch.common.collect.ImmutableOpenMap;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author zhangch
 * @date 2019/10/15 0015 下午 13:35
 */
@Service(value = "elasticsearchService")
@Transactional
public class ElasticsearchServiceImpl implements ElasticsearchService {

    /**
     * 注入操作es的模板对象
     */
    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;

    @Autowired
    private TransportClient client;

    @Autowired
    private BaseFieldService baseFieldService;


    /**
     * 创建索引库
     *
     * @param indexName
     * @param shardNum
     * @param replicaNum
     * @return
     */
    @Override
    public Ajax createIndex(String indexName, String shardNum, String replicaNum) {
        if (StringUtils.isBlank(indexName)) {
            return new Ajax("索引名称为空", false);
        }
        //将索引库名称变为小写
        indexName = indexName.toLowerCase();

        //判断索引库是否存在
        IndicesAdminClient indices = elasticsearchTemplate.getClient().admin().indices();
        IndicesExistsResponse response = indices.prepareExists(indexName).get();
        if (response.isExists()) {
            return new Ajax("索引名称已存在", false);
        }

        //设置分片数和副本数
        Integer shards = null;
        if (!StringUtils.isBlank(shardNum)) {
            shards = Integer.parseInt(shardNum);
        }
        Integer replicas = null;
        if (!StringUtils.isBlank(replicaNum)) {
            replicas = Integer.parseInt(replicaNum);
        }

        //使用模板对象操作es
        Map<String, Object> settings = new HashMap<>();
        settings.put("number_of_shards", shards);

        settings.put("number_of_replicas", replicas);
        elasticsearchTemplate.createIndex(indexName, settings);

        // 设置映射关系字符串 , 可以用json对象进行put , 初始化索引库
        // 1. 提取初始化的基本字段
        List<BaseField> rows = baseFieldService.findAll().getRows();
        /*
        rows数据类型
        [{
            "id": 1,
            "name": "专业",
            "type": "text",
            "valueScope": "取值范围",
            "description": "专业"
        }, {
            "id": 2,
            "name": "类型",
            "type": "text",
            "valueScope": "取值范围",
            "description": "类型"
        }]
         */
        //2. 提取rows中有用的信信息, 拼接要put的json数据, 创建映射
        for (BaseField baseField : rows) {
            StringBuilder map = new StringBuilder();
            map.append("{\"properties\": {\"" + baseField.getName() + "\":{\"type\":\"" + baseField.getType() + "\",\"index\":\"true\"");
            if ("date".equals(baseField.getType())) {
                map.append(",");
                map.append("\"format\":\"yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||yyyy-MM-dd HH:mm||yyyy/MM/dd\"");
            }
            if ("text".equals(baseField.getType())) {
                map.append(",");
                map.append("\"analyzer\":\"ik_max_word\"");
                map.append(",");
                map.append("\"search_analyzer\":\"ik_smart\"");
            }
            map.append("}}}");
            //创建该字段的映射
            elasticsearchTemplate.putMapping(indexName, indexName, JSON.parse(map.toString()));
        }

        return new Ajax("创建成功,请及时设置映射!", true);
    }

    /**
     * 创建映射字段, 存入索引库
     *
     * @param indexName
     * @param filedName
     * @param filedType
     * @param isIndex
     * @param isSplit
     * @param ikSave
     * @param ikSearch
     * @return
     */
    @Override
    public Ajax createMapping(String indexName, String filedName, String filedType, String isIndex, String isSplit, String ikSave, String ikSearch) {
        //翻数据库字段是否存在, 存在则不能创建,
        boolean flag = isExist(indexName, filedName);
        if (flag) {
            return new Ajax("字段已存在，请勿重复添加!", true);
        }
        String index = "1".equals(isIndex) ? "true" : "false";


        // 设置映射关系字符串 , 可以用json对象进行put
        StringBuilder map = new StringBuilder();
        map.append("{\"properties\": {\"" + filedName + "\":{\"type\":\"" + filedType + "\",\"index\":\"" + index + "\"");
        if ("date".equals(filedType)) {
            map.append(",");
            map.append("\"format\":\"yyyy-MM-dd HH:mm:ss||yyyy-MM-dd\"");
        }
        if ("text".equals(filedType) && "true".equals(index) && "1".equals(isSplit) && !"default".equals(ikSave) && ikSave != null) {
            map.append(",");
            map.append("\"analyzer\":\"" + ikSave + "\"");
        }

        if ("text".equals(filedType) && "true".equals(index) && "1".equals(isSplit) && !"default".equals(ikSearch) && ikSearch != null) {
            map.append(",");
            map.append("\"search_analyzer\":\"" + ikSearch + "\"");
        }
        map.append("}}}");

        //创建单个字段的映射
        boolean b = elasticsearchTemplate.putMapping(indexName, indexName, JSON.parse(map.toString()));
//        System.out.println(map.toString());

//        //sql数据库不需要数据
//        //将字段信息存入之前的数据库用来添加数据,
//        indexFieldDao.save(indexName, filedName, isIndex);
//
//        //将字段json信息存入数据库
//        indexMappingDao.save(indexName, map.toString());

        return b ? new Ajax("创建成功, 可选择继续添加或以后添加", true) : new Ajax("失败", false);
    }

    //创建mapping判断字段是否存在
    private boolean isExist(String indexName, String filedName) {
        List indexField = getIndexField(indexName);
        if (indexField == null) {
            return false;
        }
        return indexField.contains(filedName);
    }

    /**
     * 获取索引库所有数据
     *
     * @param indexName
     * @param json
     * @param page
     * @param size
     * @return
     */
    @Override
    public PageData getByIndex(String indexName, String json, Integer page, Integer size) throws Exception {
        SearchResponse searchResponse = null;
        //获取客户端
        Client client = elasticsearchTemplate.getClient();
        //计算出from查询起点位置
        int from = (page - 1) * size;
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch();
        searchResponse = searchRequestBuilder.setQuery(QueryBuilders.matchQuery("_index", indexName)) //matchAllQuery()查询所有索引库中的数据
                .setSearchType(SearchType.QUERY_THEN_FETCH)
                .setFrom(from).setSize(size) //分页属性
                .get();
        SearchHits hits = null;
        if (searchResponse != null) {
            hits = searchResponse.getHits();
        }
        if (hits == null) {
            return new PageData();
        }
//        System.out.println(hits.getTotalHits());// 打印总条数
        //匹配到的总条数
        long totalHits = hits.getTotalHits();

        SearchHit[] searchHits = hits.getHits();
        //创建一个集合存储数据
        List list = new ArrayList();
        for (SearchHit searchHit : searchHits) {
            String id = searchHit.getId();
            String type = searchHit.getType();
            Map<String, Object> sourceAsMap = searchHit.getSourceAsMap();
//            System.out.println(searchHit.getSourceAsString());
            //这块没必要, 需要一个更复杂的实体类封装查询出来的数据,
            sourceAsMap.put("id", id);
            sourceAsMap.put("type", type);
            String s = JSON.toJSONString(sourceAsMap);
            Object parse = JSON.parse(s);
//            System.out.println(searchHit.getSourceAsMap());
//            System.out.println(parse);
            list.add(parse);
        }
        PageData pageData = new PageData();
        pageData.setTotal(new Long(totalHits).intValue());
        pageData.setRows(list);

        return pageData;
    }


    /**
     * 进行全文检索
     *
     * @return
     */
    @Override
    public PageData query(String indexName, String json, Integer page, Integer size) throws ParseException {
        //解析搜索关键词
        String search = (String) JSON.parseObject(json).get("search");
        //搜索请求对象
        SearchRequest searchRequest = new SearchRequest(indexName);
        //指定类型, 经过测试可以不用指定
//        searchRequest.types(indexName);
        //搜索源构建对象
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        //设置分页参数
        //计算出记录起始下标
        int from = (page - 1) * size;
        searchSourceBuilder.from(from);//起始记录下标，从0开始
        searchSourceBuilder.size(size);//每页显示的记录数

        //搜索方式, 使用bool搜索方式

        //提取建立了索引并进行分词的text字段
        HashMap<String, String[]> stringHashMap = getStringHashMap(indexName);

        //创建bool查询, 使用or 即should
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();

        //高亮显示构建
        HighlightBuilder highlightBuilder = new HighlightBuilder();

        //先定义一个MultiMatchQuery, 参数意义(参数, 字段列表)
        String[] analyzerArrs = stringHashMap.get("analyzerArr");
        if (analyzerArrs.length > 0) {
            MultiMatchQueryBuilder multiMatchQueryBuilder = QueryBuilders.multiMatchQuery(search, analyzerArrs)
                    //匹配度达到多少百分比就算合格
                    .minimumShouldMatch("80%")
                    //设置某个字段的分值, 该字段匹配度越高, 排名越靠前
                    .field("name", 10);
            boolQueryBuilder.should(multiMatchQueryBuilder);
        }

        //再定义一个termQuery , 由于String 数组的原因, 可以建立多个(参数: 字段名, 参数)
        String[] notAnalyzerArrs = stringHashMap.get("notAnalyzerArr");

        if (notAnalyzerArrs.length > 0) {
            for (String s : notAnalyzerArrs) {
                TermQueryBuilder termQueryBuilder
                        = QueryBuilders.termQuery(s, search);
                //bool匹配设置为should
                boolQueryBuilder.should(termQueryBuilder);
            }
        }


        //设置高亮前后缀(页面高亮的标签)
        highlightBuilder.preTags("<tag style=\"color: red;\">");//设置前缀
        highlightBuilder.postTags("</tag>");//设置后缀


   /*     highlightBuilder.field("name");//设置高亮字段
        highlightBuilder.field("description");//设置高亮字段*/

        //设置高亮字段, 动态设置
        //将待查询的两个数组字段进行合并
        String[] highlightField = (String[]) ArrayUtils.addAll(analyzerArrs, notAnalyzerArrs);

        if (highlightField.length > 0) {

            for (String field : highlightField) {
                //对每个字段进行高亮构建
                highlightBuilder.field(field);
            }
        }

        //设置搜索高亮构件
        searchSourceBuilder.highlighter(highlightBuilder);
        //设置搜索方式为bool查询
        searchSourceBuilder.query(boolQueryBuilder);
        //设置源字段过虑,第一个参数结果集包括哪些字段，第二个参数表示结果集不包括哪些字段
//        searchSourceBuilder.fetchSource(new String[]{"name","studymodel","price","timestamp"},new String[]{});
        //向搜索请求对象中设置搜索源
        searchRequest.source(searchSourceBuilder);
        //执行搜索,向ES发起http请求
//        SearchResponse searchResponse = client.search(searchRequest);
        SearchResponse searchResponse = client.search(searchRequest).actionGet();
        //搜索结果
        SearchHits hits = searchResponse.getHits();
        //匹配到的总记录数
        long totalHits = hits.getTotalHits();
        //得到匹配度高的文档
        SearchHit[] searchHits = hits.getHits();
        List list = new ArrayList();
        for (SearchHit hit : searchHits) {
            //文档的主键
            String id = hit.getId();
            String type = hit.getType();

            //源文档内容
            Map<String, Object> sourceAsMap = hit.getSourceAsMap();
            //取出高亮内容
            Map<String, HighlightField> highlightFields = hit.getHighlightFields();
            if (highlightFields != null) {
                //遍历高亮字段数组
                for (String field : highlightField) {
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
        PageData pageData = new PageData();
        pageData.setRows(list);
        pageData.setTotal(new Long(totalHits).intValue());
        return pageData;
    }

    /**
     * 获取索引库中可被查询的字段名数组, 存入map中返回
     *
     * @param indexName
     * @return map[{"analyzerArr":text字段},{"notAnalyzer":keyword字段}]
     */
    public HashMap<String, String[]> getStringHashMap(String indexName) {
        List<IndexField> IndexFieldList = getFieldAndMapping(indexName).getRows();
        //拼接可被查询且分词的字段名, 和可被查询但不分词的字段名
        StringBuilder indexAndAnalyzer = new StringBuilder();
        StringBuilder indexNotAnalyzer = new StringBuilder();

        joint(IndexFieldList, indexAndAnalyzer, indexNotAnalyzer);
        String analyzerStr = indexAndAnalyzer.toString();
        String notAnalyzerStr = indexNotAnalyzer.toString();

        HashMap<String, String[]> stringHashMap = new HashMap<String, String[]>();
        stringHashMap.put("analyzerArr", analyzerStr.length() > 0 ? analyzerStr.split(",") : new String[]{});
        stringHashMap.put("notAnalyzerArr", notAnalyzerStr.length() > 0 ? notAnalyzerStr.split(",") : new String[]{});
        return stringHashMap;
    }

    /**
     * 获取索引库数组中可被查询的字段名数组, 存入map中返回
     *
     * @param indexNames
     * @return map[{"analyzerArr":text字段},{"notAnalyzer":keyword字段}]
     */
    @Override
    public HashMap<String, String[]> getStringHashMap(String[] indexNames) {
        if (indexNames == null || indexNames.length == 0) {
            return new HashMap<>();
        }
        List<IndexField> tempList = new ArrayList<>();
        for (String indexName : indexNames) {//获取全部索引的全部字段, 组装indexFieldList
            List<IndexField> rows = getFieldAndMapping(indexName).getRows();
            tempList.addAll(rows);
        }
        //字段去重
        Map<String, IndexField> map = new HashMap<>();
        for (IndexField indexField : tempList) {
            map.put(indexField.getFieldName(), indexField);
        }
        //去重后的字段对象存入list
        ArrayList<IndexField> IndexFieldList = new ArrayList<IndexField>(map.values());
        //拼接可被查询且分词的字段名, 和可被查询但不分词的字段名
        StringBuilder indexAndAnalyzer = new StringBuilder();
        StringBuilder indexNotAnalyzer = new StringBuilder();
        joint(IndexFieldList, indexAndAnalyzer, indexNotAnalyzer);
        String analyzerStr = indexAndAnalyzer.toString();
        String notAnalyzerStr = indexNotAnalyzer.toString();

        HashMap<String, String[]> stringHashMap = new HashMap<String, String[]>();
        stringHashMap.put("analyzerArr", analyzerStr.length() > 0 ? analyzerStr.split(",") : new String[]{});
        stringHashMap.put("notAnalyzerArr", notAnalyzerStr.length() > 0 ? notAnalyzerStr.split(",") : new String[]{});
        return stringHashMap;
    }


    /**
     * 拼接可被查询且分词的字段名, 和可被查询但不分词的字段名, 拼好以后, 可以直接拿取有值的参数
     *
     * @param indexFieldList
     * @param indexAndAnalyzer
     * @param indexNotAnalyzer
     */
    @Override
    public void joint(List<IndexField> indexFieldList, StringBuilder indexAndAnalyzer, StringBuilder indexNotAnalyzer) {
        for (IndexField indexField : indexFieldList) {
            String index = indexField.getIndex();
            String analyzer = indexField.getAnalyzer();
            if (!"false".equals(index) && "text".equals(indexField.getType())) {
                String fieldName = indexField.getFieldName();
                indexAndAnalyzer.append(fieldName).append(",");
            }

            if (!"false".equals(index) && "default".equals(analyzer) && "keyword".equals(indexField.getType())) {
                indexNotAnalyzer.append(indexField.getFieldName()).append(",");
            }
        }
    }

    /**
     * 更新文档
     *
     * @param indexName
     * @param json
     * @param gridId
     * @return
     */
    @Override
    public Ajax updateDocument(String json, String indexName, String gridId) {
        UpdateResponse updateResponse = elasticsearchTemplate.getClient().prepareUpdate(indexName, indexName, gridId).setDoc(JSON.parseObject(json)).setId(gridId).get();

        return new Ajax("干的漂亮", true);
    }


    /**
     * 获取映射字段, 并用来查询
     *
     * @param indexName
     * @return
     */
    @Override
    public List getTitle(String indexName) {
//        //封装页面需要的表头数据
//        Set columns = new HashSet();
        //获取索引字段{id, name, birthday}

        List<String> indexField = getIndexField(indexName);
        //开始封装页面需要的表头数据
        List columnList = new ArrayList();

        if (indexField == null) {
            return new ArrayList();
        }
        for (String s : indexField) {


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
     * 获取索引库列表
     *
     * @return
     */
    @Override
    public List<T> getIndexList() {
        Client client = elasticsearchTemplate.getClient();
        GetIndexResponse response = client.admin().indices().prepareGetIndex().execute().actionGet();

        String[] indices = response.getIndices();
        List<T> list = new ArrayList<>();
        if (indices != null) {
            for (String index : indices) {
                list.add(new T(index, false));
            }
        }
        return list;
    }


    /**
     * 获取该索引库的详细信息
     */
    @Override
    public PageData getIndexDetail(String indexName) {

        IndicesAdminClient adminClient = elasticsearchTemplate.getClient().admin().indices();
        GetSettingsRequestBuilder dev = adminClient.prepareGetSettings(indexName);
        GetSettingsResponse getSettingsResponse = dev.get();
        //获取索引库的创建详情
        ImmutableOpenMap<String, Settings> indexToSettings = getSettingsResponse.getIndexToSettings();
        //settings是一个map
        Settings settings = indexToSettings.get(indexName);
        //     * 数据格式-->getIndexToSettings
        //     *  [dev => {
        //     * 	"index.creation_date": "1571292260973",
        //     * 	"index.number_of_replicas": "0",
        //     * 	"index.number_of_shards": "1",
        //     * 	"index.provided_name": "dev",
        //     * 	"index.uuid": "gW56WccQQruu9891eKqXxQ",
        //     * 	"index.version.created": "6020299"
        //     * }]
//        System.out.println(getSettingsResponse.getIndexToSettings());

        //创建index, 填充index对象
        Index index = new Index();
        //添加创建日期, 并格式化为字符串
        Long s = Long.valueOf(settings.get("index.creation_date"));
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateFormat = simpleDateFormat.format(new Date(s));

        index.setCreateTime(dateFormat);
        //添加副本数和分片数
        index.setReplicas(settings.get("index.number_of_replicas"));
        index.setShards(settings.get("index.number_of_shards"));

        //获取索引库的字段映射信息， 重开了一个接口
        /*GetMappingsResponse dev1 = adminClient.prepareGetMappings(indexName).get();
        ImmutableOpenMap<String, ImmutableOpenMap<String, MappingMetaData>> mappings = dev1.getMappings();
        ImmutableOpenMap<String, MappingMetaData> dev2 = mappings.get(indexName);
        MappingMetaData dev3 = dev2.get(indexName);
        if (dev3 == null) {
            return null;
        }
        Map<String, Object> sourceAsMap = dev3.getSourceAsMap();
        Map<String, Object> properties = (Map<String, Object>) sourceAsMap.get("properties");

        //字段名称列表, 纯字段名称
        List indexFieldList = getIndexField(indexName);*/

        //获取到的数据类型为:
        //{
        //	properties = {
        //		description = {
        //			type = text,
        //			analyzer = ik_max_word,
        //			search_analyzer = ik_smart
        //		},
        //		name = {
        //			type = text,
        //			analyzer = ik_max_word,
        //			search_analyzer = ik_smart
        //		},
        //		pic = {
        //			type = text,
        //			index = false
        //		},
        //		price = {
        //			type = float
        //		},
        //		studymodel = {
        //			type = keyword
        //		},
        //		timestamp = {
        //			type = date,
        //			format = yyyy - MM - dd HH: mm: ss || yyyy - MM - dd || epoch_millis
        //		}
        //	}
        //}

        //封装mapping信息 ,
        //用不着mapping信息了， 重开一个接口获取

//        index.setFieldList(properties.toString());
        index.setIndexName(indexName);

        PageData pageData = new PageData();
        pageData.setTotal(1);
        List list = new ArrayList();
        list.add(index);
        pageData.setRows(list);
        return pageData;
    }


    /**
     * 获取该索引库所有的字段
     *
     * @param indexName
     * @return
     */
    @Override
    public List getIndexField(String indexName) {
        //获取mapping详情
        JSONObject properties = getMappingInfo(indexName);
        //提取所有的key
        if (properties == null) {
            return null;
        }
        Set<String> keys = properties.keySet();
        //转为list
        List<String> list = new ArrayList<>(keys);
        return list;
        //获取到的数据类型为:
        //{
        //	properties = {
        //		description = {
        //			type = text,
        //			analyzer = ik_max_word,
        //			search_analyzer = ik_smart
        //		},
        //		name = {
        //			type = text,
        //			analyzer = ik_max_word,
        //			search_analyzer = ik_smart
        //		},
        //		pic = {
        //			type = text,
        //			index = false
        //		},
        //		price = {
        //			type = float
        //		},
        //		studymodel = {
        //			type = keyword
        //		},
        //		timestamp = {
        //			type = date,
        //			format = yyyy - MM - dd HH: mm: ss || yyyy - MM - dd || epoch_millis
        //		}
        //	}
        //}


    }

    /**
     * 获取该索引库所有的字段对象
     *
     * @param indexName
     * @return
     */
    @Override
    public JSONObject getFieldType(String indexName) {
        //获取mapping详情
        JSONObject properties = getMappingInfo(indexName);
        //提取所有的key
        if (properties == null) {
            return null;
        }
        return properties;
    }

    /**
     * 查询index的mapping详情 封装字段信息数据, 至pageData中, 填充datagrid表格
     *
     * @param indexName
     * @return
     */
    @Override
    public PageData getFieldAndMapping(String indexName) {
        JSONObject mappingInfo = getMappingInfo(indexName);
        if (mappingInfo == null) {
            return new PageData(new ArrayList());
        }
        //封装mapping信息至IndexField
        List<IndexField> fieldList = new ArrayList<>();
        for (String s : mappingInfo.keySet()) {

            IndexField indexField = new IndexField();
            //字段名称
            indexField.setFieldName(s);
            //是否建立索引
            String index;
            Map fieldInfo = (Map) mappingInfo.get(s);
            //boolean不能强制转换为string
            Object flag = fieldInfo.get("index");

            if (flag == null) {
                index = "true";
            } else {
                index = flag.toString();
            }

            indexField.setIndex(index);
            //字段类型
            indexField.setType(fieldInfo.get("type").toString());

            //存储分词 NullPointerException
            Object analyzer = fieldInfo.get("analyzer");
            if (analyzer != null) {
                indexField.setAnalyzer(analyzer.toString());
            } else {
                indexField.setAnalyzer("default");
            }

            //检索分词
            Object search_analyzer = fieldInfo.get("search_analyzer");
            if (search_analyzer != null) {
                indexField.setSearchAnalyzer(search_analyzer.toString());
            } else {
                indexField.setSearchAnalyzer("default");
            }

            //将indexField加入fieldList
            fieldList.add(indexField);
        }

        //填充pageData
        PageData pageData = new PageData();
        //设置字段数量为键值对的数量
        pageData.setTotal(mappingInfo.keySet().size());
        pageData.setRows(fieldList);
        return pageData;
    }

    /**
     * 删除索引库
     *
     * @param indexName
     * @return
     */
    @Override
    public Ajax deleteIndex(String indexName) {
        boolean flag = elasticsearchTemplate.deleteIndex(indexName);
        if (flag) {
            return new Ajax("删除成功", true);
        }
        return new Ajax("操作失败", false);

    }

    /**
     * 添加一条数据
     *
     * @param json
     * @param indexName
     * @return
     */
    @Override
    public Ajax addDocument(String json, String indexName) {
        JSONObject o = JSON.parseObject(json);
        try {
//            for (int i = 0; i < 300000; i++) {
            elasticsearchTemplate.getClient().prepareIndex(indexName, indexName).setSource(o.toString(), XContentType.JSON).get();
//            }
            elasticsearchTemplate.getClient().prepareIndex(indexName, indexName).setSource(o.toString(), XContentType.JSON).get();
        } catch (Exception e) {
            e.printStackTrace();
            return new Ajax("添加失败", false);
        }

        return new Ajax("添加成功", true);
    }

    /**
     * 删除一条数据
     *
     * @param indexName
     * @param type
     * @param gridId
     * @return
     */
    @Override
    public Ajax deleteDocument(String indexName, String type, String gridId) {
        String delete = elasticsearchTemplate.delete(indexName, type, gridId);
        return new Ajax("删除成功", true);
    }


    /**
     * 获取mapping详情
     *
     * @param indexName
     * @return
     */
    @Override
    public JSONObject getMappingInfo(String indexName) {
        IndicesAdminClient adminClient = elasticsearchTemplate.getClient().admin().indices();
        GetMappingsResponse dev1 = adminClient.prepareGetMappings(indexName).get();
        ImmutableOpenMap<String, ImmutableOpenMap<String, MappingMetaData>> mappings = dev1.getMappings();
        ImmutableOpenMap<String, MappingMetaData> dev2 = mappings.get(indexName);
        MappingMetaData dev3 = dev2.get(indexName);
        //加上非空判断
        if (dev3 == null) {
            return null;
        }
        Map<String, Object> sourceAsMap = dev3.getSourceAsMap();
//        System.out.println(sourceAsMap);

        //将sourceAsMap转为Map
        Map properties = (Map) sourceAsMap.get("properties");
//        System.out.println(properties);
        JSONObject paramsObj = null;
        if (properties != null) {
            paramsObj = new JSONObject(properties);
        }
//        JSONObject jsonObject = JSON.parseObject(properties.toString());
        return paramsObj;
    }
}
