package com.ecspace.business.knowledgeCenter.administrator.util;

import org.elasticsearch.common.text.Text;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;

import java.util.Map;

/**
 * @author zhangch
 * @date 2020/1/9 0009 下午 19:16
 */
public class ESUtil {

    /**
     * 将源文档替换为高亮文档
     * @param sourceAsMap
     * @param highlightFields
     */
    public static void replaceSourceWithHighlight(Map<String, Object> sourceAsMap, Map<String, HighlightField> highlightFields) {
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
                    //替换原文档内容为高亮内容
                    String highLightDoc = stringBuffer.toString();
                    sourceAsMap.put(field, highLightDoc);
                }
            }
        }
    }

}
