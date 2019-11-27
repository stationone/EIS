package com.ecspace.business.es.dao;

import com.ecspace.business.es.pojo.IndexField;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Auther: menb
 * @Date: 2019/8/12
 * @Description: com.ecspace.business.es.dao
 * @version:
 */
public interface IndexFieldDao {

    public void save(@Param("indexName") String indexName, @Param("fieldName") String filedName, @Param("isIndex") String isIndex);

    public List<IndexField> getFieldByIndex(@Param("indexName") String indexName);

    public IndexField get(@Param("indexName") String indexName, @Param("fieldName") String filedName);

    public void deleteIndexField(@Param("indexName") String indexName);
}
