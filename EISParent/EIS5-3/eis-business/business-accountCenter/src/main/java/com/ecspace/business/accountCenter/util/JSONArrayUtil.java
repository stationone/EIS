package com.ecspace.business.accountCenter.util;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;

import java.util.Date;
import java.util.List;

public class JSONArrayUtil {

    /**
     * list集合转json对象
     *
     * @param list
     * @return
     */
    public static JSONArray listToJsonArray(List list){
        JsonConfig config = new JsonConfig();
        config.setIgnoreDefaultExcludes(false);
        config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
        JSONArray jsonArray = JSONArray.fromObject(list,config);
        return jsonArray;
    }
}
