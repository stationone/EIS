package com.ecspace.business.es.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;

/**
 * Elasticsearch操作类
 *
 * @author zhangch
 * @date 2019/11/4 0004 下午 16:51
 */
public class ESUtils {

    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;


}
