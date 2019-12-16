package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileBaseDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileTypeDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileType;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileBaseService;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTypeService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsResponse;
import org.elasticsearch.action.admin.indices.mapping.get.GetMappingsResponse;
import org.elasticsearch.client.IndicesAdminClient;
import org.elasticsearch.cluster.metadata.MappingMetaData;
import org.elasticsearch.common.collect.ImmutableOpenMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author zhangch
 * @date 2019/12/5 0005 下午 20:56
 */
@Service
public class FileTypeServiceImpl implements FileTypeService {
    @Autowired
    private FileTypeDao fileTypeDao;
    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;
    @Autowired
    private FileBaseService fileBaseService;

    @Override
    public GlobalResult insert(FileType fileType) {

        fileType.setId(TNOGenerator.generateId());
        fileType.setTypeName(fileType.getText().toLowerCase());
        FileType type = fileTypeDao.save(fileType);
        //创建index
        boolean index = createIndex(fileType.getTypeName());
        if (!index) {
            fileTypeDao.deleteById(fileType.getId());
        }
        return new GlobalResult(index, 2000, String.valueOf(index), type);
    }

    @Override
    public List<FileType> listFileType() {
        Iterable<FileType> filetypes = fileTypeDao.findAll();
        ArrayList<FileType> fileTypes = new ArrayList<>();
        filetypes.forEach(fileTypes::add);

        return fileTypes;
    }

    @Override
    public GlobalResult update(FileType fileType) {
        if (fileType == null || "".equals(fileType.getText())) {
            return new GlobalResult(false, 4000, "fasle");
        }
        FileType type = fileTypeDao.save(fileType);
        return new GlobalResult(true, 2000, "干的漂亮", type);
    }

    @Override
    public GlobalResult delete(String id) {
        FileType fileType = fileTypeDao.findById(id).orElse(new FileType());
//        fileType.getTypeName()
        boolean index = elasticsearchTemplate.deleteIndex(fileType.getTypeName());

        fileTypeDao.deleteById(id);
        //删除document前先进行删除索引库
        return new GlobalResult(index, 2000, String.valueOf(index));
    }

    //    public PageData fileTypeDetail(String id) {
//        FileType fileType = fileTypeDao.findById(id).orElse(new FileType());
//        String typeName = fileType.getTypeName();
//        if (typeName == null || "".equals(typeName)) {
//            return null;
//        }
//        //获取mapping详情
//        JSONObject properties = getMappingInfo(typeName);
//        //提取所有的key
//        if (properties == null) {
//            return null;
//        }
//        Set<String> keys = properties.keySet();
//        //转为list
//        List<FileBase> list = new ArrayList<>();
//        List<Map<String, Object>> lists = new ArrayList<Map<String, Object>>();
//
//        Map<String, Object> stringObjectHashMap = new HashMap<>();
//        for (String key : keys) {
//            FileBase fileBase = new FileBase();
//            fileBase.setFilename(key);
//            list.add(fileBase);
//            stringObjectHashMap.put("typeName",key);
//        }
//        PageData pageData = new PageData();
//        lists.add(stringObjectHashMap);
//        pageData.setRows(list);
//        pageData.setTotal(list.size());
//        return pageData;
//    }
    @Autowired
    private FileBaseDao fileBaseDao;

    @Override
    public PageData fileTypeDetail(String id, Integer page, Integer size) {
        FileType fileType = fileTypeDao.findById(id).orElse(new FileType());
        String indexName = fileType.getTypeName();
        if (indexName == null || "".equals(indexName)) {
            return null;
        }
        JSONObject mappingInfo = getMappingInfo(indexName);
        if (mappingInfo == null) {
            return new PageData(new ArrayList());
        }
        //封装mapping信息至IndexField
        List<FileBase> fieldList = new ArrayList<>();
        for (String s : mappingInfo.keySet()) {

            FileBase fileBase = new FileBase();
            //字段名称
            fileBase.setFilename(s);
            FileBase base = fileBaseDao.findByFilename(s).orElse(fileBase);

            //将indexField加入fieldList
            fieldList.add(base);
        }

        //填充pageData
        PageData pageData = new PageData();
        //设置字段数量为键值对的数量
        pageData.setTotal(mappingInfo.keySet().size());
        pageData.setRows(fieldList);
        return pageData;
    }

    /**
     * 创建类型同时创建索引库
     */
    private boolean createIndex(String indexName) {
        //将索引库名称变为小写
        indexName = indexName.toLowerCase();

        //判断索引库是否存在
        IndicesAdminClient indices = elasticsearchTemplate.getClient().admin().indices();
        IndicesExistsResponse response = indices.prepareExists(indexName).get();
        if (response.isExists()) {
            return false;
        }
        //使用模板对象操作es
        Map<String, Object> settings = new HashMap<>();
        settings.put("number_of_shards", 1);

        settings.put("number_of_replicas", 0);
        boolean index = elasticsearchTemplate.createIndex(indexName, settings);

//        // 设置映射关系字符串 , 可以用json对象进行put , 初始化索引库
//        // 1. 提取初始化的基本字段
//        List<FileBase> rows = fileBaseService.listFileBase();
//
//        //2. 提取rows中有用的信信息, 拼接要put的json数据, 创建映射
//        for (FileBase fileBase : rows) {
//            StringBuilder map = new StringBuilder();
//            map.append("{\"properties\": {\"" + fileBase.getFilename() + "\":{\"type\":\"" + "text" + "\",\"index\":\"true\"");
//            map.append("}}}");
//            //创建该字段的映射
//            elasticsearchTemplate.putMapping(indexName, indexName, JSON.parse(map.toString()));
//        }

        return index;
    }

    /**
     * 获取字段信息
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
        if (dev3 == null) {
            return null;
        }
        Map<String, Object> sourceAsMap = dev3.getSourceAsMap();
        Map properties = (Map) sourceAsMap.get("properties");
        JSONObject paramsObj = null;
        if (properties != null) {
            paramsObj = new JSONObject(properties);
        }
        return paramsObj;
    }

    @Override
    public GlobalResult insertField(FileType fileType) {
        fileType.setId(TNOGenerator.generateId());
        FileType type = fileTypeDao.save(fileType);
        return new GlobalResult(true, 2000, "true",type);
    }
}
