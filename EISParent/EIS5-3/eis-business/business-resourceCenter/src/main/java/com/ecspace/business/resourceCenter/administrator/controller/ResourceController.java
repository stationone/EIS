package com.ecspace.business.resourceCenter.administrator.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

import com.ecspace.business.accountCenter.administrator.entity.Users;
import com.ecspace.business.accountCenter.administrator.service.UsersService;
import com.ecspace.business.resourceCenter.administrator.service.CatalogResourceLinkService;
import com.ecspace.business.resourceCenter.administrator.service.ResourceService;
import com.ecspace.business.resourceCenter.administrator.entity.AuditLog;
import com.ecspace.business.resourceCenter.administrator.entity.CatalogResourceLink;
import com.ecspace.business.resourceCenter.administrator.entity.Resource;
import com.ecspace.business.resourceCenter.administrator.util.SvnConfig;
import com.ecspace.business.resourceCenter.util.*;
import com.ecspace.svnkit.SvnImpl;
import com.ecspace.svnkit.client.SvnClientManage;
import com.ecspace.svnkit.entity.FileInfo;
import com.ecspace.svnkit.util.SvnMessages;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 资源表操作
 */
@Controller
@RequestMapping("/resource")
public class ResourceController {

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private CatalogResourceLinkService catalogResourceLinkService;

    @Autowired
    private UsersService usersService;

    /**
     * 查询方法，查询所有资源
     * 条件查询
     */
    @RequestMapping("/list")
    public void list(HttpServletRequest request, HttpServletResponse response){
        String page = StringUtil.goOutSpace(request.getParameter("page"));
        String rows = StringUtil.goOutSpace(request.getParameter("rows"));
        String catalog = StringUtil.goOutSpace(request.getParameter("catalogNO"));
        String resId = StringUtil.goOutSpace(request.getParameter("resId"));
        String resName = StringUtil.goOutSpace(request.getParameter("resName"));
        String resType = StringUtil.goOutSpace(request.getParameter("resType"));
        String inputUser = StringUtil.goOutSpace(request.getParameter("inputUser"));
        JSONObject resultObject = new JSONObject();
        if(page == null || rows == null || catalog == null){
            resultObject.put("rows", "[]");
            resultObject.put("total", 0);
            ResponseUtil.write(response, resultObject);
            return;
        }
        PageBean pageBean = new PageBean(Integer.parseInt(page),Integer.parseInt(rows));

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("startTemp", pageBean.getStartTemp());
        map.put("pageSize", pageBean.getPageSize());
        map.put("catalogNO", catalog);
        map.put("resId",resId);
        map.put("resName",resName);
        map.put("resType",resType);
        map.put("inputUser",inputUser);

        List<Resource> list = resourceService.listByCatalogResLink(map);
        JSONArray jsonArray = new JSONArray();
        if(list != null){
            try {
                JsonConfig config = new JsonConfig();
                config.setIgnoreDefaultExcludes(false);
                config.registerJsonValueProcessor(Date.class,	new JsonDateValueProcessor());
                jsonArray = JSONArray.fromObject(list, config);
                System.out.println(jsonArray);
//                jsonArray = extractAttributes(jsonArray);
            }catch (Exception e){
                e.printStackTrace();
            }

        }
        Long total = resourceService.listByCatalogResLinkTotal(map);

        resultObject.put("rows", jsonArray);
        resultObject.put("total",total);
        ResponseUtil.write(response,resultObject);
    }


    /**
     * 提取扩展属性
     * @param jsonArray [{"resId":"编号","extend":"{"ceshi": "value", "zx":"asd"}"}]
     * @return	[{"resId":"编号","extend":"{"ceshi": "value", "zx":"asd"}","ceshi":"value","zx":"asd"}]
     */
    private JSONArray extractAttributes(JSONArray jsonArray){
        for(int i = 0;i<jsonArray.size();i++){
            try {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                String extendString = jsonObject.getString("extend");
                if(extendString == null || "".equals(extendString)){
                    break;
                }
                JSONObject jsonExtends = JSONObject.fromObject(extendString);
                Iterator iterator = jsonExtends.keys();
                while (iterator.hasNext()){
                    String key = iterator.next().toString();
                    String value = jsonExtends.getString(key);
                    jsonObject.put(key, value);
                }
                jsonArray.set(i, jsonObject);
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        return jsonArray;
    }


    /**
     * 删除方法
     * resList: [{"tNO":"1903241453622898648","svnURL":"TEXT/text.txt"}]
     * 单个和批量
     */
    @RequestMapping("/delete")
    public void delete(HttpServletRequest request, HttpServletResponse response){
        String resList = StringUtil.goOutSpace(request.getParameter("resList"));
        JSONObject result = new JSONObject();

        if(resList == null){
            result.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response, result);
            return;
        }

        JSONArray jsonArray = JSONArray.fromObject(resList);

        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.svnName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();

        //获取需要删除的数据
        List<Resource> delete = new ArrayList<>();

        for(int i = 0;i<jsonArray.size();i++){
            JSONObject jsonObject = JSONObject.fromObject(jsonArray.get(i));
            String catalogPath = jsonObject.get("svnURL").toString();
            //删除svn数据操作
            String svnMessageCode = svn.deleteDirectory(catalogPath,"");
            if(SvnMessages.defeated.equals(svnMessageCode)){
                continue;
            }
            Resource res = new Resource();
            res.settNO(jsonObject.get("tNO").toString());
            delete.add(res);

        }

        //需要删除的资源和目录关联关系
        List<CatalogResourceLink> links = new LinkedList<>();

        if(delete.size() > 0){
            //查询全部资源，找出需要删除的文件编号
            List<Resource> resAllList = resourceService.list(new HashMap<>());
            if(resAllList != null){
                for(Resource res:delete){
                    for(Resource resOld:resAllList){
                        if(res.gettNO().equals(resOld.gettNO())){
                            //需要删除的资源
                            CatalogResourceLink catalogResourceLink = new CatalogResourceLink();
                            catalogResourceLink.setResId(resOld.getResId());
                            links.add(catalogResourceLink);
                            break;
                        }
                    }
                }

            }

        }

        result.put("code",ResultMessage.defeated);
        if(delete.size() > 0){
            //删除文件
            if(resourceService.deleteBatch(delete)){
                //删除文件和目录的关联关系
                catalogResourceLinkService.deleteBatch(links);

                result.put("code",ResultMessage.success);

            }
        }


        ResponseUtil.write(response, result);

    }

    /**
     * 下载方法，
     * 单个和批量
     */
    @RequestMapping("/download")
    public void download(HttpServletRequest request,HttpServletResponse response){
        String svnVersion = StringUtil.goOutSpace(request.getParameter("svnVersion"));
        String svnURL = StringUtil.goOutSpace(request.getParameter("svnURL"));
        if(svnURL == null || svnURL.equals("")){
            return;
        }

        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.svnName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();
        StringBuilder fileSavePath = new StringBuilder(SvnConfig.fileSavePath);
        fileSavePath.append(SvnConfigUtil.fileSeparate);
        fileSavePath.append(SvnConfig.systemName);

        String svnMessage = svn.export(svnURL,fileSavePath.toString(),svnVersion);
        //判断文件是否下载成功
        if(SvnMessages.defeated.equals(svnMessage)){
            //下载失败
            JSONObject resultObject = new JSONObject();
            resultObject.put("code",ResultMessage.defeated);
            try {
                ResponseUtil.write(response, resultObject.toString());
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        String fileName = svnURL.substring(svnURL.lastIndexOf("/"),svnURL.length());
        fileSavePath.append(SvnConfigUtil.fileSeparate);
        fileSavePath.append(fileName);
        if (DownloadUtil.downloadFiles(request, response, fileSavePath.toString())) {
            //将文件删除
        }
    }

    /**
     * 查询资源历史列表
     *  svnURL: pdm-1/pdm3/text7k_1976.txt
     * 单个文件的历史记录
     */
    @RequestMapping("/listHistory")
    public void listHistory(HttpServletRequest request,HttpServletResponse response){
        String catalogPath = StringUtil.goOutSpace(request.getParameter("svnURL"));
        JSONObject resultObject = new JSONObject();
        if(catalogPath == null){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        String newCatalogPath = "";

        if(SvnConfig.svnURL == null){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.svnName, SvnConfig.svnPassword, SvnConfig.svnURL);
        SvnImpl svn = svnClientManage.getMethod();

        int separator = catalogPath.lastIndexOf("/");
        if(separator == -1){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        //文件名称 login.css
        String fileName = catalogPath.substring(separator+1, catalogPath.length());

        //文件路径 https://127.0.0.1/svn/TEXT
        newCatalogPath = SvnConfig.svnURL+SvnConfigUtil.fileSeparate+catalogPath.substring(0,separator);
        List<FileInfo> fileInfos = svn.getFileHistoryInfos(newCatalogPath, fileName);
        List<AuditLog> logs = new ArrayList<>();
        if(fileInfos.size() > 0){
            //查询用户
            List<Users> listUser = usersService.list(new HashMap<>());

            for(int i = 0;i<fileInfos.size();i++){
                FileInfo fileInfo = fileInfos.get(i);
                AuditLog auditLog = new AuditLog();
                for(Users users:listUser){
                    if(users.gettNO().equals(fileInfo.getAuthor())){
                        auditLog.setUserId(users.getUserName());
                        break;
                    }
                }
                auditLog.setHistResName(fileName);
                auditLog.setHistResURL(catalogPath);
                auditLog.setHistVersion(fileInfo.getVersion());
                auditLog.setHistTime(DateUtil.stringDateToTimestamp(fileInfo.getSubmitDate()));
                logs.add(auditLog);
            }
        }


        JSONArray jsonArray = JSONArray.fromObject(logs);
        resultObject.put("rows", jsonArray);
        resultObject.put("total", jsonArray.size());
        ResponseUtil.write(response,resultObject);
    }



}
