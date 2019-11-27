package com.ecspace.business.resourceCenter.user.controller;

import com.ecspace.business.resourceCenter.user.service.*;
import com.ecspace.business.resourceCenter.user.service.entity.*;
import com.ecspace.business.resourceCenter.user.util.SvnConfig;
import com.ecspace.business.resourceCenter.util.*;
import com.ecspace.svnkit.SvnImpl;
import com.ecspace.svnkit.client.SvnClientManage;
import com.ecspace.svnkit.util.SvnMessage;
import com.ecspace.svnkit.util.SvnMessages;
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
import java.io.IOException;
import java.text.ParseException;
import java.util.*;

/**
 * 目录表操作
 * 代表的是svn的目录
 */
@Controller
@RequestMapping("/catalogUser")
public class UserCatalogController {

    @Autowired
    private ResourceCatalogService userResourceCatalogService;

    @Autowired
    private CatalogUserLinkService userCatalogUserLinkService;

    @Autowired
    private CatalogUserCheckOutLinkService userCatalogUserCheckOutLinkService;



    /**
     * 查询目录
     * 返回树结构
     */
    @RequestMapping("/listTree")
    public void listTree(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        JSONArray resultArray;

        Map<String, Object> map = new HashMap<>();
        boolean flag = false;
        if(id == null || "".equals(id)){
            //第一次加载
            //根据用户查询
            map.put("catalogNO","0");//这是根节点的编号
            flag = true;
        }else{
            map.put("parentNO",id);
        }
            //是普通用户，需要根据用户tNO，关联查询
            map.put("userTNO", SvnConfig.systemName);
            List<ResourceCatalog> list;
            if(flag){
                //第一次加载
                list = userResourceCatalogService.listUserCheckOutByUserTNO(map);
            }else{
                list = userResourceCatalogService.listUserCatalogJurisdictionByUserTNOorParentNO(map);
            }
            resultArray = assembleTree(list, flag);

        ResponseUtil.write(response,resultArray);
    }


    /**
     * 组装eastyu-tree需要的数据
     * 普通用户
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


                //普通用户
                attributeObject.put(SvnConfigUtil.RW, resCatalog.getRw());//默认

                if(firstLoad){
                    //第一次加载
                    attributeObject.put("tNO",resCatalog.getParentNO());
                    attributeObject.put("status",resCatalog.getPrototcol());
                }

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
     * 创建目录（目录）
     * parentNO: 0102
     * catalogName: zxc-1-2-1
     * repositoryName: pdm_1 版本库名称
     * userRepository:
     * catalogPath: text/text1
     */
    @RequestMapping("/create")
    public void create(ResourceCatalog resourceCatalog ,HttpServletRequest request, HttpServletResponse response){

        Map<String, Object> map = new HashMap<>();
        JSONObject resultObject = new JSONObject();
        map.put("catalogName", resourceCatalog.getCatalogName()); //目录名称
        map.put("parentNO", resourceCatalog.getParentNO()); //父级编号

        //版本库名称
        String repositoryName = StringUtil.goOutSpace(request.getParameter("repositoryName"));
        //用户版本库
        String userRepository = StringUtil.goOutSpace(request.getParameter("userRepository"));

        //1、通过名称和父级编号查询记录,并判断是否存在
        List<ResourceCatalog> resCatalogList = userResourceCatalogService.list(map);
        if(resCatalogList != null) {
            resultObject.put("code", ResultMessage.dataRepetition);
            ResponseUtil.write(response, resultObject);
            return;
        }

        String catalogPath = StringUtil.goOutSpace(resourceCatalog.getCatalogPath());
        StringBuilder catalogURL = new StringBuilder(repositoryName);
        StringBuilder catalogPathBuff = new StringBuilder();

        if(catalogPath != null) {
            //版本库+目录地址
            catalogURL.append(SvnConfigUtil.fileSeparate);
            catalogURL.append(catalogPath);

            catalogPathBuff.append(catalogPath);
            catalogPathBuff.append(SvnConfigUtil.fileSeparate);
        }
        //目录地址+目录名称
        catalogPathBuff.append(resourceCatalog.getCatalogName());

        catalogPath = UrlUtil.pathConvert(catalogPathBuff.toString());

        //2、执行添加SVN目录操作
        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.systemName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();
        System.out.println(catalogURL.toString()+"   "+resourceCatalog.getCatalogName());
        String createMessage = svn.createDirectory(catalogURL.toString(),resourceCatalog.getCatalogName(),"");
        System.out.println("svn执行结果："+createMessage);
        StringBuilder fileFlodPath = new StringBuilder(SvnConfig.svnWorkCopy);
        fileFlodPath.append(SvnConfigUtil.fileSeparate);
        fileFlodPath.append(SvnConfig.systemName);
        fileFlodPath.append(SvnConfigUtil.fileSeparate);
        fileFlodPath.append(userRepository);
        fileFlodPath.append(SvnConfigUtil.fileSeparate);
        fileFlodPath.append(catalogPath);


        if(SvnMessages.success.equals(createMessage)) {
            //新增成功
            //更新工作副本
            svn.updateFileFolderUpdateFile(fileFlodPath.toString());

            resourceCatalog.setCatalogNO(IdGenerator.getResourceNO(resourceCatalog.getParentNO(),
                    userResourceCatalogService.listMaxNO(resourceCatalog.getParentNO())));
            resourceCatalog.setCatalogPath(catalogPath);
            resourceCatalog.setSvnURL(catalogURL.toString());
            resourceCatalog.setInputUser(SvnConfig.systemName);
            try {
                resourceCatalog.setInputDate(DateUtil.getDate());
            } catch (ParseException e) {
                e.printStackTrace();
            }
            //保存目录信息至数据库

            if(userResourceCatalogService.create(resourceCatalog)) {

                String pTNO = resourceCatalog.getParentNO();
                if(pTNO != null && !"".equals(pTNO)){
                    Map<String, Object> map1 = new HashMap<>();
                    map1.put("parentNO",pTNO);


                    //通过上级目录tNO查询是否有子节点
                    List<ResourceCatalog> resCatalogs = userResourceCatalogService.list(map1);
                    if (resCatalogs == null || resCatalogs.size() == 1) {
                        //证明是第一次新建子节点，修改节点状态
                        ResourceCatalog resCatalog1 = new ResourceCatalog();
                        resCatalog1.setCatalogNO(pTNO);
                        resCatalog1.setStatus("2");
                        try {
                            resCatalog1.setEditDate(DateUtil.getDate());
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                        resCatalog1.setEditUser(SvnConfig.systemName);
                        //将上级目录节点状态修改
                        userResourceCatalogService.update(resCatalog1);
                    }
                }

                //给目录权限赋值
                Map<String, Object> map1 = new HashMap<>();
                map1.put("catalogNO",resourceCatalog.getParentNO());

                //获取用户拥有的目录权限，通过传入的上级目录tNO
                List<CatalogUserLink> addList = userCatalogUserLinkService.list(map1);
                if(addList != null){
                    //需执行保存
                    List<Map<String, Object>> svnList = new ArrayList<>();
                    for(int i = 0;i<addList.size();i++){
                        Map<String, Object> svnMap = new HashMap<>();
                        CatalogUserLink cataUserLink = addList.get(i);
                        cataUserLink.settNO(IdGenerator.generate());
                        cataUserLink.setCatalogNO(resourceCatalog.getCatalogNO());
                        cataUserLink.setInputUser(SvnConfig.systemName);
                        try {
                            cataUserLink.setInputDate(DateUtil.getDate());
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                        svnMap.put("name",cataUserLink.getUserId());
                        svnMap.put("power",cataUserLink.getRw().toLowerCase());
                        svnList.add(svnMap);
                    }
                    //执行保存，将用户对目录的权限保存至数据库
                    if(userCatalogUserLinkService.createBatch(addList)){
                        //将用户权限增加至svn配置文件中
                        SvnConfigUtil.saveSVNPower(SvnConfig.repositoriesPath, repositoryName, catalogPath, svnList);
                    }

                }
                resultObject.put("code", ResultMessage.success);
                resultObject.put("catalogNO",resourceCatalog.getCatalogNO());
                ResponseUtil.write(response, resultObject);
                return;
            }


        }

        resultObject.put("code", ResultMessage.defeated);
        ResponseUtil.write(response, resultObject);
    }

    /**
     * 检出工作副本
     * @param request
     * @param response
     */
    @RequestMapping("/checkoutWorkCopy")
    public void checkoutWorkCopy(HttpServletRequest request, HttpServletResponse response){
        String catalogNO = StringUtil.goOutSpace(request.getParameter("catalogNO"));
        //用户检出版本库名称
        String userRepositoryName = StringUtil.goOutSpace(request.getParameter("userRepositoryName"));
        JSONObject resultObject = new JSONObject();
        //判断传入参数是否为空
        if(catalogNO == null || userRepositoryName == null ){
            resultObject.put("code",ResultMessage.parameterNotValid);
            ResponseUtil.write(response,resultObject);
            return;
        }

        System.out.println(catalogNO+"          "+userRepositoryName);

        Map<String, Object> mapc = new HashMap<>();
        mapc.put("userCheckoutName",userRepositoryName);
        mapc.put("userTNO",SvnConfig.systemName);
        //查询用户自定义的名称是否已存在
        List<CatalogUserCheckOutLink> linkList = userCatalogUserCheckOutLinkService.list(mapc);
        if(linkList != null){
            //名称已存在
            resultObject.put("code",ResultMessage.dataRepetition);
            ResponseUtil.write(response,resultObject);
            return;
        }

        /**
         * 执行检出操作
         * 1、获取svn检出类
         * 2、查询用户所能检出的目录路径
         * 3、根据用户检出目录集合，循环检出目录
         * 4、返回检出结果
         */
//        SvnCheckOut svnCheckOut = new SvnCheckOut(null, users.gettNO());
        Map<String, Object> map = new HashMap<>();
        map.put("catalogNO",catalogNO);
        map.put("userId",SvnConfig.systemName);
        List<ResourceCatalog> list = userResourceCatalogService.listUserCatalogJurisdictionByUserTNOorParentNO(map);
        if(list == null){
            resultObject.put("code",ResultMessage.defeated);
            ResponseUtil.write(response,resultObject);
            return;
        }
        ResourceCatalog resCatalog = list.get(0);

        //拼接检出地址
        StringBuilder fileSavePath = new StringBuilder(userRepositoryName);
        if(resCatalog.getCatalogPath() != null && !"".equals(resCatalog.getCatalogPath())){
            fileSavePath.append("/");
            fileSavePath.append(resCatalog.getCatalogPath());
        }

//        long va = svnCheckOut.doCheckOut(resCatalog.getSvnURL(),fileSavePath.toString());

        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.systemName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();
        String checkOutMessager = svn.checkOutFile(SvnConfig.svnURL + SvnConfigUtil.fileSeparate + resCatalog.getSvnURL(),SvnConfig.svnWorkCopy+SvnConfigUtil.fileSeparate+SvnConfig.systemName+SvnConfigUtil.fileSeparate+fileSavePath.toString(),true);

        if(checkOutMessager.equals(SvnMessages.defeated)){
            //检出失败
            resultObject.put("code",ResultMessage.defeated);
        }else{
            //检出成功
            //将数据保存至pdm_cataUserCheckOutLink中,只保存顶级节点的
            CatalogUserCheckOutLink cataUserCheckOutLink = new CatalogUserCheckOutLink();
            cataUserCheckOutLink.settNO(IdGenerator.generate());
            cataUserCheckOutLink.setCatalogNO(catalogNO);
            cataUserCheckOutLink.setCatalogName(resCatalog.getCatalogName());
            cataUserCheckOutLink.setUserCheckoutName(userRepositoryName);
            cataUserCheckOutLink.setParentNO("0");
            cataUserCheckOutLink.setInputUser(SvnConfig.systemName);
            cataUserCheckOutLink.setUserTNO(SvnConfig.systemName);
            try {
                cataUserCheckOutLink.setInputDate(DateUtil.getDate());
            } catch (ParseException e) {
                e.printStackTrace();
            }
            if(userCatalogUserCheckOutLinkService.create(cataUserCheckOutLink)){
                resultObject.put("code",ResultMessage.success);
                resultObject.put("catalogNO",catalogNO);
            }

        }


        ResponseUtil.write(response, resultObject);
    }

    /**
     * 删除工作副本
     * @param request
     * @param response
     */
    @RequestMapping("/deleteCheckoutWorkCopy")
    public void deleteCheckoutWorkCopy(HttpServletRequest request,HttpServletResponse response){
        String tNO = StringUtil.goOutSpace(request.getParameter("tNO"));
        JSONObject resultObject = new JSONObject();
        if(tNO == null){
            resultObject.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response, resultObject);
            return;
        }
        //根据tNO查询是否存在
        Map<String, Object> map = new HashMap<>();
        map.put("tNO",tNO);
        List<CatalogUserCheckOutLink> links = userCatalogUserCheckOutLinkService.list(map);
        if(links == null){
            resultObject.put("code", ResultMessage.dataNotExist);
            ResponseUtil.write(response, resultObject);
            return;
        }


        //拼接用户版本库地址
        CatalogUserCheckOutLink cataUserCheckOutLink = links.get(0);

        StringBuilder filePath = new StringBuilder(SvnConfig.svnWorkCopy);
        filePath.append(SvnConfig.systemName);
        filePath.append(SvnConfigUtil.fileSeparate);
        filePath.append(cataUserCheckOutLink.getUserCheckoutName());
        File file = new File(filePath.toString());

        boolean flag = true;
        try {
            //删除目录
            FileUtils.deleteDirectory(file);
        }catch (IOException e){
            //删除失败,再次删除一次
            try{
                FileUtils.deleteDirectory(file);
            }catch (IOException i){
                flag = false;
                resultObject.put("code", ResultMessage.defeated);
            }
        }

        if(flag){
            //执行删除数据库信息
            List<CatalogUserCheckOutLink> links1 = new ArrayList<>();
            CatalogUserCheckOutLink catalogUserCheckOutLink = new CatalogUserCheckOutLink();
            catalogUserCheckOutLink.settNO(tNO);
            links1.add(catalogUserCheckOutLink);
            userCatalogUserCheckOutLinkService.deleteBatch(links1);
            resultObject.put("code", ResultMessage.success);
        }
        ResponseUtil.write(response, resultObject);
    }

    /**
     * 查询版本库
     * @param request
     * @param response
     */
    public void listRepository(HttpServletRequest request,HttpServletResponse response){

        Map<String, Object> map = new HashMap<>();
        map.put("userTNO",SvnConfig.systemName);
        map.put("parentNO","0");
        System.out.println(map);
        List<ResourceCatalog> resCatalogs = userResourceCatalogService.listUserCatalogJurisdictionByUserTNOorParentNO(map);

        JSONArray jsonArray = new JSONArray();

        if(resCatalogs != null){
            JsonConfig config = new JsonConfig();
            config.setIgnoreDefaultExcludes(false);
            config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
            jsonArray = JSONArray.fromObject(resCatalogs,config);
        }
        ResponseUtil.write(response,jsonArray);
    }

    /**
     * 查询树目录
     * (树列表结构)
     * 用户通过版本号查询自己权限下可加载的目录
     * @param request
     * @param response
     */
    @RequestMapping("/listCatalogTree")
    public void listCatalogTree(HttpServletRequest request, HttpServletResponse response){
        JSONArray resultArray = new JSONArray();
        String id = StringUtil.goOutSpace(request.getParameter("id"));
        String catalogNO = StringUtil.goOutSpace(request.getParameter("catalogNO"));
        String parentNO = StringUtil.goOutSpace(request.getParameter("parentNO"));

        if(catalogNO == null){
            ResponseUtil.write(response, resultArray);
            return;
        }
        Map<String, Object> map = new HashMap<>();
        if(id != null){
            //查询子节点
            map.put("parentNO",id);
        }else{
            if(parentNO != null) {
                //查询出当前目录信息
                map.put("parentNO",parentNO);
                map.put("catalogNO",catalogNO);
            }else{
                //查询出当前目录的子目录
                map.put("parentNO",catalogNO);
            }
        }


        map.put("userTNO", SvnConfig.systemName);
        List<ResourceCatalog> list = userResourceCatalogService.listUserCatalogJurisdictionByUserTNOorParentNO(map);
        resultArray = assembleCatalogTree(list);
        ResponseUtil.write(response, resultArray);
    }

    /**
     * 组装treeGrid
     * @param list
     * @return
     */
    private JSONArray assembleCatalogTree(List<ResourceCatalog> list){
        if(list == null){
            return new JSONArray();
        }
        JSONArray jsonArray = new JSONArray();
        for(int i = 0;i<list.size();i++){
            ResourceCatalog resCatalog = list.get(i);
            if(resCatalog == null){
                continue;
            }
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("catalogNO",resCatalog.getCatalogNO());
            jsonObject.put("catalogName",resCatalog.getCatalogName());
            jsonObject.put("power",resCatalog.getRw());
            jsonObject.put("svnURL",resCatalog.getSvnURL());
            if("2".equals(resCatalog.getStatus())){
                //代表有子节点
                jsonObject.put("state","closed");
            }
            jsonArray.add(jsonObject);
        }
        return jsonArray;

    }



}
