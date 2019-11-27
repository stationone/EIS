package com.ecspace.business.accountCenter.util;

import java.util.Map;

public class MapUtil {
    /**
     * 组装条件语句需要的map对象
     * @param map
     * @return
     */
    public static Map<String, Object> assembleMap(Map<String, Object> map){
        String catalogNO = StringUtil.goOutSpace(map.get("catalogNO").toString());
        if(catalogNO == null){
            return null;
        }
        catalogNO = catalogNO.trim();
        map.put("start",1);
        map.put("length",catalogNO.length());
        map.put("catalogNO",catalogNO);
        return map;
    }
}
