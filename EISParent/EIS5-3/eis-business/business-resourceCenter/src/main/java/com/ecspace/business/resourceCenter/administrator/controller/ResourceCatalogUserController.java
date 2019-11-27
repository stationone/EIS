package com.ecspace.business.resourceCenter.administrator.controller;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserCheckOutLink;
import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserLink;
import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalogUser;
import com.ecspace.business.resourceCenter.administrator.service.CatalogUserCheckOutLinkService;
import com.ecspace.business.resourceCenter.administrator.service.CatalogUserLinkService;
import com.ecspace.business.resourceCenter.administrator.service.ResourceCatalogService;
import com.ecspace.business.resourceCenter.administrator.service.ResourceCatalogUserService;
import com.ecspace.business.resourceCenter.administrator.util.SvnConfig;
import com.ecspace.business.resourceCenter.util.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.*;

@Controller
@RequestMapping("/resourceCatalogUser")
public class ResourceCatalogUserController {

    @Autowired
    private ResourceCatalogUserService resourceCatalogUserService;

    @Autowired
    private CatalogUserCheckOutLinkService catalogUserCheckOutLinkService;

    @Autowired
    private CatalogUserLinkService catalogUserLinkService;


    @RequestMapping("/list")
    public void list(HttpServletRequest request, HttpServletResponse response)throws Exception{
        JSONObject resultObject = new JSONObject();
        PageBean pageBean = new PageBean(Integer.parseInt(request.getParameter("page")),
                Integer.parseInt(request.getParameter("rows")));
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("startTemp", pageBean.getStartTemp());
        map.put("pageSize", pageBean.getPageSize());

        List<ResourceCatalogUser> list = resourceCatalogUserService.list(map);
        JSONArray resultArray = new JSONArray();
        if(list != null){
            JsonConfig config = new JsonConfig();
            config.setIgnoreDefaultExcludes(false);
            config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
            resultArray = JSONArray.fromObject(list,config);
        }
        resultObject.put("rows", resultArray);
        resultObject.put("total", resourceCatalogUserService.listTotal(map));
        ResponseUtil.write(response,resultObject);
    }

    /**
     * 查询存ResCataUser表中的用户数据
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/existList")
    public void existList(HttpServletRequest request, HttpServletResponse response)throws Exception{
        List<ResourceCatalogUser> list = resourceCatalogUserService.list(new HashMap<String, Object>());
        JsonConfig config = new JsonConfig();
        config.setIgnoreDefaultExcludes(false);
        config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
        JSONArray jsonArray = JSONArray.fromObject(list,config);
        JSONObject resultObject = new JSONObject();
        resultObject.put("code", ResultMessage.success);
        resultObject.put("result",jsonArray);
        ResponseUtil.write(response,resultObject);
    }

    /**
     * 查询不存在ResCataUser表中的用户数据
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/notExistList")
    public void notExistList(HttpServletRequest request, HttpServletResponse response)throws Exception{
        List<ResourceCatalogUser> list = resourceCatalogUserService.listNotResourceUser(new HashMap<>());
        JsonConfig config = new JsonConfig();
        config.setIgnoreDefaultExcludes(false);
        config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
        JSONArray jsonArray = JSONArray.fromObject(list,config);
        JSONObject resultObject = new JSONObject();
        resultObject.put("code", ResultMessage.success);
        resultObject.put("result",jsonArray);
        ResponseUtil.write(response,resultObject);
    }

    /**
     * 添加用户至账户中心
     * 传入["2019011618581333690","2019011811534279356","2017103109420969753"]
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/save")
    public void save( HttpServletRequest request, HttpServletResponse response)throws Exception{
        String resUserList = request.getParameter("resUserList");

        JSONArray jsonArray = JSONArray.fromObject(resUserList);

        JSONObject resultObject = new JSONObject();

        List<ResourceCatalogUser> oldlist = new ArrayList<>();

        List<ResourceCatalogUser> add = new ArrayList<>(); //需要添加的
        List<ResourceCatalogUser> delete = new ArrayList<>(); //需要删除的

        //查询全部数据
        List<ResourceCatalogUser> listAll = resourceCatalogUserService.list(new HashMap<String, Object>());
        if(listAll != null){
            //数据库已有数据
            //需要删除的
            delete.addAll(listAll);
            if(jsonArray.size() > 0){
                for(int i = 0;i<jsonArray.size();i++){
                    for(int u = delete.size()-1;u >= 0;u--){
                        if(jsonArray.get(i).toString().equals(delete.get(u).getUserTNO())){
                            delete.remove(u);
                        }
                    }
                }

                //需要增加的
                for(int i = 0;i<listAll.size();i++){
                    for(int u = jsonArray.size()-1;u >= 0;u--){
                        if(listAll.get(i).getUserTNO().equals(jsonArray.get(u).toString())){
                            jsonArray.remove(u);
                        }
                    }
                }
            }

        }

        String result = ResultMessage.success;
        String repositoriesPath = SvnConfig.repositoriesPath;
        //判断需要删除的数据
        if(delete.size() > 0){
            List<String> deleteSVNUser = new LinkedList<>();
            List<CatalogUserLink> links = new LinkedList<>();
            List<CatalogUserCheckOutLink> linkList = new LinkedList<>();
            for(ResourceCatalogUser resCataUser : delete){
                deleteSVNUser.add(resCataUser.getUserTNO());
                CatalogUserLink cataUserLink = new CatalogUserLink();
                cataUserLink.setUserId(resCataUser.getUserTNO());
                links.add(cataUserLink);
                CatalogUserCheckOutLink cataUserCheckOutLink = new CatalogUserCheckOutLink();
                cataUserCheckOutLink.setUserTNO(resCataUser.getUserTNO());
                linkList.add(cataUserCheckOutLink);

                //删除用户的工作副本
                File file = new File(SvnConfig.svnWorkCopy+SvnConfigUtil.fileSeparate+resCataUser.getUserTNO());

                if(file.exists()){

                    try {
                        FileUtils.deleteDirectory(file);
                    }catch (Exception e){
                        //删除错误，在次删除一遍
                        try {
                            FileUtils.deleteDirectory(file);
                        }catch (Exception e1){
                            //二次删除失败
                            e1.printStackTrace();
                        }
                    }
                }

            }
            //svn配置文件删除用户
            SvnConfigUtil.deleteSVNUser(repositoriesPath, deleteSVNUser);

            //svn配置文件删除用户权限(未成功)
//            SvnConfigUtil.deleteSVNPower(repositoriesPath, "", "",deleteSVNUser);

            //数据库删除用户检出的副本
            catalogUserCheckOutLinkService.deleteBatchByUserTNO(linkList);

            //数据库删除用户
            resourceCatalogUserService.deleteBatch(delete);

            //数据库删除用户目录权限
            catalogUserLinkService.deleteBatchByUserTNO(links);



        }

        //判断需要增加的数据
        if(jsonArray.size() > 0){

            List<String> saveSVNUser = new ArrayList<>();
            for(int i =0;i<jsonArray.size();i++){
                ResourceCatalogUser resCataUser = new ResourceCatalogUser();
                String json = jsonArray.get(i).toString();
                resCataUser.settNO(IdGenerator.generate());
                resCataUser.setUserTNO(json);
                resCataUser.setInputUser(SvnConfig.systemName);
                resCataUser.setInputDate(DateUtil.getDate());
                add.add(resCataUser);
                saveSVNUser.add(json);
            }

            //svn配置文件增加用户
            SvnConfigUtil.saveSVNUser(repositoriesPath,saveSVNUser);

            //增加集合中的信息
            if(!resourceCatalogUserService.saveBatch(add)){
                result = ResultMessage.defeated;
            }

        }

        resultObject.put("code",result);
        ResponseUtil.write(response,resultObject);

    }

}
