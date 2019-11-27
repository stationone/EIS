package com.ecspace.business.accountCenter.administrator.util;

import com.ecspace.business.accountCenter.util.ResponseUtil;
import com.ecspace.business.accountCenter.util.ResultMessage;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;

public class Demo {
    public static void main(String[] args) {
        String asd = "[\"AASDAS\"]";
        JSONArray jsonArray;
        try {
            if(asd == null){
                throw new JSONException();
            }
            jsonArray = JSONArray.fromObject(asd);
            if (jsonArray.size() == 0){
                throw  new JSONException();
            }

        }catch (JSONException e){
            e.printStackTrace();
            //参数不合法
            System.out.println("参数不合法");
            return;
        }
        System.out.println(jsonArray.getString(0));
    }
}
