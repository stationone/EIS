package com.ecspace.business.resourceCenter.administrator.controller;

import com.ecspace.business.resourceCenter.administrator.service.CatalogUserLinkService;
import com.ecspace.business.resourceCenter.administrator.service.ResourceCatalogService;
import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserLink;
import com.ecspace.business.resourceCenter.util.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 权限表
 */
public class JurisdictionController {

    @Autowired
    private CatalogUserLinkService catalogUserLinkService;
    @Autowired
    private ResourceCatalogService resourceCatalogService;
    /**
     * 查询权限用户
     * datagrid
     */
    public void listJurisdictionUser(HttpServletRequest request, HttpServletResponse response){
        String catalogNO = request.getParameter("catalogNO");
        JSONObject resultObject = new JSONObject();
        //判断传入参数是否为空
        if(catalogNO == null){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        PageBean pageBean = new PageBean(Integer.parseInt(request.getParameter("page")),
                Integer.parseInt(request.getParameter("rows")));

        Map<String, Object> map = new HashMap<>();
        map.put("startTemp", pageBean.getStartTemp());
        map.put("pageSize", pageBean.getPageSize());
        map.put("catalogNO", catalogNO);
        List<CatalogUserLink> links = catalogUserLinkService.listOwnJurisdictionUserByCatalogNO(map);
        JSONArray jsonArray = new JSONArray();
        if(links != null){
            JsonConfig config = new JsonConfig();
            config.setIgnoreDefaultExcludes(false);
            config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
            jsonArray = JSONArray.fromObject(links,config);
        }


        resultObject.put("rows", jsonArray);
        resultObject.put("total",catalogUserLinkService.listTotalOwnJurisdictionUserByCatalogNO(map));
        ResponseUtil.write(response,resultObject);

    }

    /**
     * 查询拥有目录权限的用户
     * @param request
     * @param response
     */
    public void listOwnJurisdictionUser(HttpServletRequest request, HttpServletResponse response){
        String catalogNO = request.getParameter("catalogNO");
        JSONObject resultObject = new JSONObject();
        //判断传入参数是否为空
        if(catalogNO == null){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("catalogNO", catalogNO);
        List<CatalogUserLink> links = catalogUserLinkService.listOwnJurisdictionUserByCatalogNO(map);
        JSONArray jsonArray = new JSONArray();
        if(links != null){
            JsonConfig config = new JsonConfig();
            config.setIgnoreDefaultExcludes(false);
            config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
            jsonArray = JSONArray.fromObject(links,config);
        }


        resultObject.put("rows", jsonArray);
        ResponseUtil.write(response,resultObject);
    }

    /**
     * 查询未拥有目录权限的用户
     */
    public void listNotOwnJurisdictionUser(HttpServletRequest request, HttpServletResponse response){
        String catalogNO = request.getParameter("catalogNO");
        JSONObject resultObject = new JSONObject();
        //判断传入参数是否为空
        if(catalogNO == null){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("catalogNO", catalogNO);
        List<CatalogUserLink> links = catalogUserLinkService.listNotOwnJurisdictionUserByCatalogNO(map);
        JsonConfig config = new JsonConfig();
        config.setIgnoreDefaultExcludes(false);
        config.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
        JSONArray jsonArray = JSONArray.fromObject(links,config);

        resultObject.put("rows", jsonArray);
        ResponseUtil.write(response,resultObject);
    }


    /**
     * 添加用户对目录的权限
     * 默认只读
     * repositoryName: pdm_3 版本库
     * catalogNO: 01
     * users: ["2019030422461328011", "1903111914107590313", "1903111914107011097"]
     */
    public void saveJurisdictionUser(HttpServletRequest request, HttpServletResponse response){
        String svnURL = StringUtil.goOutSpace(request.getParameter("svnURL"));
        String catalogNO = StringUtil.goOutSpace(request.getParameter("catalogNO"));
        String users = StringUtil.goOutSpace(request.getParameter("users"));
        JSONObject resultObject = new JSONObject();
        resultObject.put("code", ResultMessage.success);
        if(catalogNO == null || users == null || svnURL == null){
            resultObject.put("code", ResultMessage.dataNotExist);
            ResponseUtil.write(response,resultObject);
            return;
        }

        JSONArray userArray = JSONArray.fromObject(users);

        Map<String, Object> map = new HashMap<>();
        map.put("catalogNO",catalogNO);

        List<String> addUserTNO = new ArrayList<>();//添加,里面存储的是用户的流水号
        List<CatalogUserLink> deleteCatalog = new ArrayList<>();//删除,

        List<CatalogUserLink> add = new ArrayList<>(); //添加
        List<CatalogUserLink> delete = new ArrayList<>();//删除

        for(int i =0;i<userArray.size();i++){
            addUserTNO.add(userArray.get(i).toString());
        }

        //条件查询已有目录权限的用户
        List<CatalogUserLink> linkList = catalogUserLinkService.listOwnJurisdictionUserByCatalogNO(map);

        if(linkList != null){
            deleteCatalog.addAll(linkList);
            //已有数据不为空,需进行判断
            //需要删除的
            for(int i = 0;i<userArray.size();i++){
                for(int u = deleteCatalog.size()-1;u >= 0; u--){
                    //需要删除的
                    if(userArray.get(i).toString().equals(deleteCatalog.get(u).getUserId())){
                        deleteCatalog.remove(u);
                    }
                }
            }
            //需要添加的
            for(int i = 0;i<linkList.size();i++){
                for(int u = addUserTNO.size()-1;u >= 0; u--){
                    //需要添加的
                    if(linkList.get(i).getUserId().equals(addUserTNO.get(u))){
                        addUserTNO.remove(u);
                    }
                }
            }

        }

//        //根据当前传入的catalogNO查询全部子目录
//        List<ResourceCatalog> list = resourceCatalogService.listByCatalogNO(map);
//        if(list != null){
//            //说明有子目录
//            //执行需要添加的
//            if(addUserTNO.size() > 0) {
//                //循环将查询出来的数据赋值给add集合
//                for (String userTNO : addUserTNO) {
//                    for (ResCatalog link : list) {
//                        CatalogUserLink cataUserLink = new CatalogUserLink();
//                        cataUserLink.settNO(IdGenerator.generate());
//                        cataUserLink.setUserId(userTNO);
//                        cataUserLink.setCatalogNO(link.getCatalogNO());
//                        cataUserLink.setRw(SvnConfigUtil.R);
//                        cataUserLink.setInputUser(user.getUserName());
//                        try {
//                            cataUserLink.setInputDate(DateUtil.getDate());
//                        } catch (ParseException e) {
//                            e.printStackTrace();
//                        }
//                        add.add(cataUserLink);
//                    }
//                }
//
//            }
//            if(deleteCatalog.size() > 0){
//                //循环将查询出来的数据赋值给add集合
//                for (CatalogUserLink deletes : deleteCatalog) {
//                    for (ResCatalog link : list) {
//                        CatalogUserLink cataUserLink = new CatalogUserLink();
//                        cataUserLink.setUserId(deletes.getUserId());
//                        cataUserLink.setCatalogNO(link.getCatalogNO());
//                        delete.add(cataUserLink);
//                    }
//                }
//            }
//        }else{
//            //没有子目录
//            //循环将数据赋值给add集合
//            for (String userTNO : addUserTNO) {
//                CatalogUserLink cataUserLink = new CatalogUserLink();
//                cataUserLink.settNO(IdGenerator.generate());
//                cataUserLink.setUserId(userTNO);
//                cataUserLink.setCatalogNO(catalogNO);
//                cataUserLink.setRw(SvnConfigUtil.R);
//                cataUserLink.setInputUser(user.getUserName());
//                try {
//                    cataUserLink.setInputDate(DateUtil.getDate());
//                } catch (ParseException e) {
//                    e.printStackTrace();
//                }
//                add.add(cataUserLink);
//            }
//        }
//
//        //svn版本仓库
//        String repositoriesPath= ReadData.repositories;
//
//
//        //执行批量保存操作
//        if(add.size()>0){
//
//            /**
//             * 检测用户是否拥有当前目录的上级目录权限，如没有权限则设置为P
//             */
//            //查询全部目录
//            List<ResCatalog> catalogLists = resCatalogService.queryResCatalogByCond(new HashMap<String, Object>());
//
//            //分离出全部上级目录
//            List<ResCatalog> parentList = queryParentList(catalogNO, catalogLists);
//            if(parentList != null && parentList.size() > 0){
//                //删除当前目录数据
//                for(int i = parentList.size()-1;i >=0 ;i--){
//                    ResCatalog resCatalog = parentList.get(i);
//                    if(resCatalog.getCatalogNO().equals(catalogNO)){
//                        parentList.remove(i);
//                        break;
//                    }
//                }
//
//                System.out.println("目录的全部上级：");
//                System.out.println(parentList);
//
//                //查询全部用户目录权限
//                List<CatalogUserLink> cataUserList = catalogUserLinkService.list(new HashMap<String, Object>());
//
//                System.out.println("需要添加的数据："+add);
//                if(cataUserList != null && parentList.size() > 0){
//
//                    /**
//                     * 将父级目录和用户拥有权限的目录进行比较，如没有，则增加权限为P;
//                     */
//                    //判断出用户未拥有的上级目录权限
//                    for(int u = 0;u < addUserTNO.size();u++){
//                        String userTNO = addUserTNO.get(u);
//                        //临时上级目录
//                        List<ResCatalog> temporaryP = new ArrayList<ResCatalog>(parentList);
//                        for(int p = temporaryP.size()-1;p >= 0; p--){
//                            ResCatalog resCatalog = temporaryP.get(p);
//                            //比较上级目录和用户已经拥有的目录是否有重复，如有则删除
//                            for(int i = 0;i<cataUserList.size();i++){
//                                CatalogUserLink cataUserLink = cataUserList.get(i);
//                                if(resCatalog.getCatalogNO().equals(cataUserLink.getCatalogNO()) && userTNO.equals(cataUserLink.getUserId())){
//                                    //用户已经拥有此目录权限，删除需要增加表的数据
//                                    temporaryP.remove(p);
//                                    break;
//                                }
//                            }
//                        }
//                        if(temporaryP.size() > 0){
//                            //还有数据则意味着需要添加到数据库，权限为P
//                            for(int i =0;i<temporaryP.size();i++){
//                                ResCatalog resCatalog = temporaryP.get(i);
//                                CatalogUserLink cataUserLinkp = new CatalogUserLink();
//                                cataUserLinkp.settNO(IdGenerator.generate());
//                                cataUserLinkp.setUserId(userTNO);
//                                cataUserLinkp.setCatalogNO(resCatalog.getCatalogNO());
//                                cataUserLinkp.setRw(SvnConfigUtil.P);
//                                cataUserLinkp.setInputUser(user.getUserName());
//                                try {
//                                    cataUserLinkp.setInputDate(DateUtil.getDate());
//                                } catch (ParseException e) {
//                                    e.printStackTrace();
//                                }
//                                add.add(cataUserLinkp);
//                            }
//                        }
//
//                    }
//                }else{
//                    //判断上级目录列表不为空
//                    if(parentList.size() > 0){
//
//                        for(int u = 0;u < addUserTNO.size();u++) {
//                            for (int i = 0; i < parentList.size(); i++) {
//                                ResCatalog resCatalog = parentList.get(i);
//                                CatalogUserLink cataUserLinkp = new CatalogUserLink();
//                                cataUserLinkp.settNO(IdGenerator.generate());
//                                cataUserLinkp.setUserId(addUserTNO.get(u));
//                                cataUserLinkp.setCatalogNO(resCatalog.getCatalogNO());
//                                cataUserLinkp.setRw(SvnConfigUtil.P);
//                                cataUserLinkp.setInputUser(user.getUserName());
//                                try {
//                                    cataUserLinkp.setInputDate(DateUtil.getDate());
//                                } catch (ParseException e) {
//                                    e.printStackTrace();
//                                }
//                                add.add(cataUserLinkp);
//                            }
//                        }
//                    }
//                }
//            }
//
//            /**
//             * 批量设置用户的权限
//             */
//            //批量保存用户的权限
//            if(catalogUserLinkService.createBatch(add)){
//                resultObject.put("code", ResultMessage.success);
//
//                if(list.size() > 0){
//                    //说明有子目录
//                    //[{name=1903121443285768940, power=rw}, {name=root, power=rw}]
//
//                    //组装用户权限
//                    List<Map<String, Object>> list1 = new ArrayList<>();
//                    //去除重复
//                    for(int i =0;i<add.size()-1;i++){
//                        for(int u= add.size()-1;u>i;u--){
//                            if(add.get(i).getUserId().equals(add.get(u).getUserId())){
//                                add.remove(u);
//                            }
//                        }
//                    }
//                    //组装需要提交的用户
//                    for(CatalogUserLink cataUserLink: add){
//                        Map<String, Object> map1 = new HashMap<>();
//                        map1.put("name",cataUserLink.getUserId());
//                        map1.put("power", SvnConfigUtil.changePower(cataUserLink.getRw()));
//                        list1.add(map1);
//                    }
//
//                    System.out.println("要保存的用户"+list1);
//                    String repositoryName = svnURL;
//                    if(svnURL.contains("/")){
//                        repositoryName = repositoryName.substring(0,repositoryName.indexOf("/"));
//                    }
//
//                    for(ResCatalog resCatalog:list){
//                        //将目录循环保存至svn配置中,此方法后续更新为批量
//                        SvnConfigUtil.saveSVNPower(repositoriesPath, repositoryName, resCatalog.getCatalogPath(), list1);
//                    }
//                }
//
//
//            }
//        }
//
//        //执行需要删除的
//        if(delete.size()>0){
//            if(catalogUserLinkService.deleteBatchByUserIdAndCatalogNO(delete)){
//                resultObject.put("code", ResultMessage.success);
//            }
//        }
//
//        ResponseUtil.write(response,resultObject);

    }

}
