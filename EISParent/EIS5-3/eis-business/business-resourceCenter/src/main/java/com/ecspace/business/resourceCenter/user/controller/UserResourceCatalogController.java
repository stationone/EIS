package com.ecspace.business.resourceCenter.user.controller;

import com.ecspace.business.resourceCenter.user.service.ResourceCatalogService;
import com.ecspace.business.resourceCenter.user.service.entity.Resource;
import com.ecspace.business.resourceCenter.user.service.entity.ResourceCatalog;
import com.ecspace.business.resourceCenter.user.util.SvnConfig;
import com.ecspace.business.resourceCenter.util.JsonDateValueProcessor;
import com.ecspace.business.resourceCenter.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/userResourceCatalog")
public class UserResourceCatalogController {

    @Autowired
    private ResourceCatalogService resourceCatalogService;

    /**
     * 根据用户查询拥有权限的版本库
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/queryRepository")
    public void queryRepository(HttpServletRequest request, HttpServletResponse response)throws Exception{


        Map<String, Object> map = new HashMap<>();
        map.put("userTNO", SvnConfig.systemName);
        map.put("parentNO","0");
        System.out.println(map);
        List<ResourceCatalog> resCatalogs = resourceCatalogService.listUserCatalogJurisdictionByUserTNOorParentNO(map);

        JSONArray jsonArray = new JSONArray();

        if(resCatalogs != null){
            JSONObject resultObject = new JSONObject();
            JsonConfig config = new JsonConfig();
            config.setIgnoreDefaultExcludes(false);
            config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
            jsonArray = JSONArray.fromObject(resCatalogs,config);
        }

        ResponseUtil.write(response,jsonArray);

    }


}
