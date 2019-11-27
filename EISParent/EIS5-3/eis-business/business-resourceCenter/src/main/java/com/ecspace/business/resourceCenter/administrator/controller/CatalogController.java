package com.ecspace.business.resourceCenter.administrator.controller;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogResourceLink;
import com.ecspace.business.resourceCenter.administrator.entity.Resource;
import com.ecspace.business.resourceCenter.administrator.service.*;
import com.ecspace.business.resourceCenter.administrator.util.SvnConfig;
import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalog;
import com.ecspace.business.resourceCenter.util.*;
import com.ecspace.svnkit.SvnImpl;
import com.ecspace.svnkit.client.SvnClientManage;
import com.ecspace.svnkit.util.SvnMessages;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 目录表操作
 * 代表的是svn的目录
 */
@Controller
@RequestMapping("/catalog")
public class CatalogController {

    @Autowired
    private ResourceCatalogService resourceCatalogService;

    @Autowired
    private CatalogUserLinkService catalogUserLinkService;

    @Autowired
    private CatalogUserCheckOutLinkService catalogUserCheckOutLinkService;

    @Autowired
    private CatalogResourceLinkService catalogResourceLinkService;

    @Autowired
    private ResourceService resourceService;

    /**
     * 查询目录
     * 返回树结构
     */
    @RequestMapping("/listTree")
    public void listTree(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        JSONArray resultArray;

        Map<String, Object> map = new HashMap<>();
        if(id == null || "".equals(id)){
            //第一次加载
            //根据用户查询
            map.put("catalogNO","0");//这是根节点的编号
        }else{
            map.put("parentNO",id);
        }

        //是超级管理员，直接查询目录表
        List<ResourceCatalog> list = resourceCatalogService.list(map);
        resultArray = assembleTree(list, true);

        ResponseUtil.write(response,resultArray);
    }


    /**
     * 组装eastyu-tree需要的数据
     * 管理员
     * @param list
     * @param firstLoad 普通用户初次加载标志位，true 普通用户第一次加载，false 普通用户非第一次加载(如 flag等于true ,则此参数无效)
     * @return
     */
    private JSONArray assembleTree(List<ResourceCatalog> list, boolean firstLoad){
        JSONArray jsonArray = new JSONArray();
        if(list != null){
            for(int i = 0 ;i<list.size();i++){
                JSONObject jsonObject = new JSONObject();

                ResourceCatalog resCatalog = list.get(i);
                jsonObject.put("id",resCatalog.getCatalogNO());
                jsonObject.put("text",resCatalog.getCatalogName());
                JSONArray attributesArray = new JSONArray();
                JSONObject attributeObject = new JSONObject();
                attributeObject.put("catalogPath",resCatalog.getCatalogPath());
                attributeObject.put("svnURL",resCatalog.getSvnURL());


                //管理员
                attributeObject.put(SvnConfigUtil.RW, SvnConfigUtil.RW);//默认

                attributesArray.add(attributeObject);
                jsonObject.put("attributes",attributesArray);
                if("2".equals(resCatalog.getStatus())){
                    //代表有子节点
                    jsonObject.put("state","closed");
                }
                jsonArray.add(jsonObject);
            }
        }
        return jsonArray;
    }


    /**
     * 创建目录（版本库节点）
     */
    @RequestMapping("/create")
    public void create(HttpServletRequest request, HttpServletResponse response){

        Map<String, Object> map = new HashMap<>();
        JSONObject resultObject = new JSONObject();
        String catalogName = StringUtil.goOutSpace(request.getParameter("catalogName"));
        if(catalogName == null){
            //传入参数为空
            resultObject.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response, resultObject);
            return;
        }
        map.put("parentNO","0");
        map.put("catalogName",catalogName); //目录名称

        //1、通过名称和父级编号查询记录,并判断是否存在
        List<ResourceCatalog> resCatalogList = resourceCatalogService.list(map);
        if(resCatalogList != null) {
            resultObject.put("code", ResultMessage.dataRepetition);
            ResponseUtil.write(response, resultObject);
            return;
        }

        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.svnName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();

        //创建版本库
        String svnResult = svn.createRepository(SvnConfig.repositoriesPath, catalogName);
        if(!SvnMessages.success.equals(svnResult)){
            resultObject.put("code", ResultMessage.defeated);
            ResponseUtil.write(response, resultObject);
            return;
        }
        ResourceCatalog resCatalog = new ResourceCatalog();
        resCatalog.setParentNO("0");
        resCatalog.setCatalogNO(IdGenerator.getResourceNO(resCatalog.getParentNO(),
                resourceCatalogService.listMaxNO(resCatalog.getParentNO())));
        resCatalog.setCatalogName(catalogName);
        resCatalog.setSvnURL(catalogName);
        resCatalog.setInputUser(SvnConfig.systemName);
        resCatalog.setParentNO("0");
        try {
            resCatalog.setInputDate(DateUtil.getDate());
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String result = ResultMessage.defeated;
        //保存目录信息至数据库
        if(resourceCatalogService.create(resCatalog)){
            //保存成功
            result = ResultMessage.success;
        }
        resultObject.put("code", result);
        resultObject.put("catalogNO",resCatalog.getCatalogNO());
        ResponseUtil.write(response, resultObject);
    }

    /**
     * 删除目录（版本库节点/子目录/文件）
     */
    @RequestMapping("/delete")
    public void delete(HttpServletRequest request, HttpServletResponse response){
        String repositoryName = StringUtil.goOutSpace(request.getParameter("repositoryName"));
        String catalogNO = StringUtil.goOutSpace(request.getParameter("catalogNO"));
        JSONObject resultObject = new JSONObject();
        //判断传入参数是否为空
        if(catalogNO == null && repositoryName == null){
            resultObject.put("code", ResultMessage.dataRepetition);
            ResponseUtil.write(response, resultObject);
            return;
        }
        //通过目录编号查询目录的信息
        Map<String, Object> map = new HashMap<>();
        map.put("catalogNO", catalogNO);
        List<ResourceCatalog> list = resourceCatalogService.list(map);
        //判断数据是否存在
        if(list == null){
            resultObject.put("code", ResultMessage.dataNotExist);
            ResponseUtil.write(response, resultObject);
            return;
        }

        ResourceCatalog resCatalog = list.get(0);//删除目录的信息

        //删除svn中数据，目录及子目录，目录下的所有文件
        String svnResult = "";

        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.svnName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();

        if(resCatalog.getParentNO().equals("0")){
            //删除版本库
            svnResult = svn.deleteRepository(SvnConfig.repositoriesPath, resCatalog.getCatalogName());
        }else{
            //删除目录
            System.out.println("目录："+repositoryName + SvnConfigUtil.fileSeparate + resCatalog.getCatalogPath());
            svnResult = svn.deleteDirectory(repositoryName + SvnConfigUtil.fileSeparate + resCatalog.getCatalogPath(),"");
        }
        System.out.println("目录删除结构:"+svnResult);
        if(SvnMessages.defeated.equals(svnResult)) {
            //删除失败
            resultObject.put("code", ResultMessage.defeated);
            ResponseUtil.write(response, resultObject);
            return;
        }

        //删除数据库中的数据
        catalogUserLinkService.deleteBatchByCatalogNO(map);
        //修改个人检出目录表的explain字段值为3
        Map<String ,Object> map1 = new HashMap<>();
        map1.put("catalogNO",catalogNO);
        map1.put("explain","3");
        catalogUserCheckOutLinkService.update(map1);


        //查询目录下的资源文件
        List<CatalogResourceLink> links = catalogResourceLinkService.listBatchByCatalogNO(map);
        if(links != null){
            List<Resource> reslist = new ArrayList<>();
            for(CatalogResourceLink cataResLink : links){
                Resource resource = new Resource();
                resource.setResId(cataResLink.getResId());
                reslist.add(resource);
            }
            //删除目录下的资源文件
            resourceService.deleteBatch(reslist);
        }

        //删除目录资源关联信息
        catalogResourceLinkService.deleteBatchByCatalogNO(map);

        //删除目录表
        if(resourceCatalogService.deleteBatchByCatalogNO(map)){
            //删除svn配置文件中此目录关联的用户权限
            resultObject.put("code", ResultMessage.success);
        }else{
            resultObject.put("code", ResultMessage.defeated);
        }
        ResponseUtil.write(response, resultObject);
    }

}
