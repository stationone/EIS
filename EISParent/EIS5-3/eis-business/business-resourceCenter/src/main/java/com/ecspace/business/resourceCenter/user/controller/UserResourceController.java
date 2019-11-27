package com.ecspace.business.resourceCenter.user.controller;

import com.ecspace.business.accountCenter.administrator.entity.Users;
import com.ecspace.business.accountCenter.administrator.service.UsersService;
import com.ecspace.business.resourceCenter.user.service.CatalogResourceLinkService;
import com.ecspace.business.resourceCenter.user.service.entity.ResUpload;
import com.ecspace.business.resourceCenter.user.util.FileUtil;
import com.ecspace.business.resourceCenter.user.util.ResUtil;
import com.ecspace.business.resourceCenter.user.util.SvnConfig;
import com.ecspace.business.resourceCenter.user.service.ResourceService;
import com.ecspace.business.resourceCenter.user.service.ResourceUploadService;
import com.ecspace.business.resourceCenter.user.service.entity.AuditLog;
import com.ecspace.business.resourceCenter.user.service.entity.Resource;
import com.ecspace.business.resourceCenter.util.*;
import com.ecspace.svnkit.SvnImpl;
import com.ecspace.svnkit.client.SvnClientManage;
import com.ecspace.svnkit.entity.FileInfo;
import com.ecspace.svnkit.factory.SvnFactory;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.*;

/**
 * 资源表操作
 */
@Controller
@RequestMapping("/userResource")
public class UserResourceController {


    @Autowired
    private ResourceService resourceService;

    @Autowired
    private UsersService usersService;

    @Autowired
    private ResourceUploadService resourceUploadService;

    @Autowired
    private CatalogResourceLinkService catalogResourceLinkService;

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
     * 编辑资源
     * @param request
     * @param response
     */
    public void update(HttpServletRequest request,HttpServletResponse response){

    }

    /**
     * 上传资源
     * 将文件上传到服务器
     * @param request
     * @param response
     */
    public void upload(HttpServletRequest request, HttpServletResponse response){

    }

    /**
     * 下载方法，
     * 单个和批量
     */
    public void download(HttpServletRequest request,HttpServletResponse response){

        String svnVersion = StringUtil.goOutSpace(request.getParameter("svnVersion"));
        String svnURL = StringUtil.goOutSpace(request.getParameter("svnURL"));
        if(svnURL == null || svnURL.equals("")){
            return;
        }

        //版本库
        String repository = svnURL.substring(0, svnURL.indexOf("/"));
        //catalogPath
        String catalogPath = svnURL.substring(svnURL.indexOf("/") + 1,svnURL.length());

        //从svn上下载文件
        String url = SvnTool.newDownload(SvnConfig.systemName, repository, catalogPath, svnVersion);
        //判断文件是否下载成功
        if("-1".equals(url)){
            JSONObject resultObject = new JSONObject();
            resultObject.put("code",ResultMessage.defeated);
            try {
                ResponseUtil.write(response, resultObject.toString());
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (DownloadUtil.downloadFiles(request, response, url)) {
//            if (FileTool.del(url)) {
//                FileTool.del(url.replace(url.substring(url.lastIndexOf("/")), ""));
//            }
        }


    }

    /**
     * 查询资源历史列表
     *  svnURL: pdm-1/pdm3/text7k_1976.txt
     * 单个文件的历史记录
     */
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

        if(ReadData.svnURL == null){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        SvnClientManage svnClientManage = new SvnClientManage(SvnConfig.systemName,ReadData.password,ReadData.svnURL);
        SvnImpl svn = svnClientManage.getMethod();
        svn.setSvnClientManage(svnClientManage);

        int separator = catalogPath.lastIndexOf("/");
        if(separator == -1){
            resultObject.put("rows",new JSONArray());
            resultObject.put("total",0);
            ResponseUtil.write(response,resultObject);
            return;
        }
        String fileName = catalogPath.substring(separator+1,catalogPath.length());
        newCatalogPath = ReadData.svnURL+'/'+catalogPath.substring(0,separator);
        System.out.println(newCatalogPath);
        System.out.println(fileName);
        List<FileInfo> fileInfos = svn.getFileHistoryInfos(newCatalogPath, fileName);
        List<AuditLog> logs = new ArrayList<>();
        if(fileInfos.size() > 0){
            //查询用户
            List<Users> listUser = usersService.list(new HashMap<String, Object>());

            for(int i = 0;i<fileInfos.size();i++){
                FileInfo fileInfo = fileInfos.get(i);
                System.out.println(fileInfo);
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
                auditLog.setHistAction(SvnConfigUtil.getAddOrUpdate(fileInfo.getName()));
                auditLog.setHistTime(DateUtil.stringDateToTimestamp(fileInfo.getSubmitDate()));
                logs.add(auditLog);
            }
        }


        JSONArray jsonArray = JSONArray.fromObject(logs);
        resultObject.put("rows", jsonArray);
        resultObject.put("total", jsonArray.size());
        ResponseUtil.write(response,resultObject);
    }



    /**
     * 同步版本库
     * 根据传入的版本号字符串数组
     * 同步完成后删除数据库中resUpload记录
     * [{"index":0,"size":4373,"id":"f_873735026325551"},{"index":177,"size":19922944,"id":"f_873735026325550"}]
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/synchronizationSVN")
    public void synchronizationSVN(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String jsonLists = request.getParameter("jsonList");
        JSONArray jsonArray = JSONArray.fromObject(jsonLists);
        JSONObject resultObject = new JSONObject();
        JSONArray resultArray = new JSONArray();

        Map<String, Object> map = new HashMap<>();
        map.put("userId", SvnConfig.systemName);

        //2、判断传入参数是否为空
        if(jsonArray != null && jsonArray.size() == 0){
            //删除用户的提交文件记录
            resourceUploadService.delete(map);
            resultObject.put("code", ResultMessage.defeated);
            resultObject.put("result",resultArray);
            ResponseUtil.write(response,resultObject);
            return;
        }

        //3、查询需要同步的数据

        List<ResUpload> resUploadList = resourceUploadService.list(map);

        //3.1、判断需要同步的数据是否为空
        if(resUploadList.size() == 0){
            resultObject.put("code", ResultMessage.synchronization_not);
            ResponseUtil.write(response,resultObject);
            return;
        }
        //4、获取需要提交控制的文件
        List<ResUpload> resUploads = new ArrayList<>();
        for(int i = 0;i<jsonArray.size();i++){
            for(int h = 0;h<resUploadList.size();h++){
                JSONObject jsonObject1 = (JSONObject) jsonArray.get(i);
                if(jsonObject1.get("id").equals(resUploadList.get(h).gettNO())){
                    resUploads.add(resUploadList.get(h));
                    break;
                }
            }
        }


        //5.1、获取svn路径
        String svnURLPath = SvnConfig.svnURL;
        String svnName = SvnConfig.systemName;
        String svnPassword = SvnConfig.svnPassword;

        //7、循环组装需要提交的数据
        String[] fileName = new String[resUploads.size()];
        String workcopy = "";

        //需要删除的记录
        List<ResUpload> deleteResUpload = new ArrayList<>();
        String catalogNO = "";

        //获取版本库名称
        String repositoryName = "";

        deleteResUpload.addAll(resUploads);

        for(int i =0;i<resUploads.size();i++){
            ResUpload  resUpload = resUploads.get(i);
            fileName[i] = resUpload.getResName();
            repositoryName = resUpload.getCatalogName();
            workcopy = resUpload.getFileWorkCopyPath();
            Resource res = new Resource();
            res.settNO(resUpload.gettNO());
            catalogNO = resUpload.getCatalogNO();
            resultArray.add(resUpload.gettNO());
        }

        //8、获取svn提交客户端,并获取版本号
        List<FileInfo> fileInfos = new ArrayList<>();
        try {
            SvnClientManage svnClientManage = new SvnClientManage(svnName,svnPassword,svnURLPath+ SvnConfigUtil.fileSeparate+ repositoryName);

            SvnFactory svnFactory = new SvnFactory();
            //8.1、批量提交文件至svn
            fileInfos = svnFactory.commitFile(svnClientManage.getSvnClientManager(),SvnConfig.workCopy+SvnConfigUtil.fileSeparate+workcopy,"","",fileName);
        }catch (Exception e){
            //提交svn操作
            //删除用户的提交文件记录
            resourceUploadService.delete(map);
            e.printStackTrace();
            resultObject.put("code", ResultMessage.defeated);
            ResponseUtil.write(response,resultObject);
            return;
        }


        //当前时间
        Date presentTime = new Date();
        try {
            presentTime = DateUtil.getDate();
        } catch (ParseException e) {
            e.printStackTrace();
            //获取当前时间报错
        }


        int resultTotal = 1 ;

        //9、查询全部资源表的数据,保存文件信息至数据库
        List<Resource> resList = resourceService.listByCatalogResLink(new HashMap<String, Object>());

        //需要批量增加
        List<Resource> addRes = new ArrayList<>();
        //需要批量更新
        List<Resource> updateRes = new ArrayList<>();

        //需要批量增加的日志
        List<AuditLog> addAuditLog = new ArrayList<>();


        //用户操作日志
//        List<UsersLog> usersLogs = new ArrayList<>();

        List<FileInfo> fileInfoList = new ArrayList<>(fileInfos);
        //8.1、判断数据库资源是否为空
        if(resList != null && resList.size() > 0) {
            //不是空的，执行过滤，判断此次提交的文件是新增还是更新
            /**
             * 新版本判断语句
             */
            //1、数据库全部文件和提交文件比较
            //2、相同的保存在update中，并减去提交文件中的这个数据，剩下的则是新增文件
            for (int f = fileInfoList.size() - 1; f >= 0; f--) {
                FileInfo fileInfo = fileInfoList.get(f);
                if (fileInfo == null) {
                    continue;
                }
                // https://lvkailiang/svn/pdm-1/pdm5/text7k_1.txt
                //将文件的保存地址转为 pdm-1/pdm5/text7k_1.txt
                String fileSvnURL = fileInfo.getSvnUrl();
                fileInfo.setSvnUrl(fileSvnURL.substring(SvnConfig.svnURL.length() + 1));
                for (int i = 0; i < resList.size(); i++) {
                    Resource res = resList.get(i);
                    //比较出更新的文件
                    if (res.getSvnURL().equals(fileInfo.getSvnUrl())) {
                        //更新的
                        updateRes.add(res);
                        fileInfoList.remove(f);
                        break;
                    }
                }
            }
        }else{

            //数据库资源为空
            for (int f = 0; f<fileInfoList.size(); f++) {
                FileInfo fileInfo = fileInfoList.get(f);
                if (fileInfo == null) {
                    continue;
                }
                // https://lvkailiang/svn/pdm-1/pdm5/text7k_1.txt
                //将文件的保存地址转为 pdm-1/pdm5/text7k_1.txt
                String fileSvnURL = fileInfo.getSvnUrl();
                fileInfo.setSvnUrl(fileSvnURL.substring(ReadData.svnURL.length() + 1));
            }
        }


        if(fileInfoList.size() > 0){
            //5.2、读取项目的配置文件，文件编号规范
            Map<String,String> mapPre = new HashMap<>();
            mapPre.put("prefix","ECS_");
            mapPre.put("postfixLength","4");

            //6、查询当前数据库最大编号
            String maxId = resourceService.listMaxId(mapPre.get("prefix") + "%");
            //6.1、根据前台传入的当前数据库最大编号，根据读取到的编号前缀，并截取为字符串数组；
            if(maxId == null || "".equals(maxId)){
                //设置默认值
                maxId = mapPre.get("prefix")+"0000";
            }
            String[] resIds = maxId.split(mapPre.get("prefix"));

            //新增的文件
            for(int i = 0;i<fileInfoList.size();i++){
                FileInfo fileInfo = fileInfoList.get(i);
                Resource res = new Resource();
                res.setCatalogNO(catalogNO);
                Map<String, String> mapNameOrType = FileUtil.getFileNameAndFileType(fileInfo.getName());
                res.setResName(mapNameOrType.get("fileName"));
                res.setResType(mapNameOrType.get("fileType"));
                res.setSvnVersion(fileInfo.getVersion());
                res.setSvnURL(fileInfo.getSvnUrl());
                //创建编号
                int is = Integer.parseInt(resIds[1]) + i + 1;
                res.setResId(ResUtil.generateId(Integer.toString(is),mapPre.get("prefix"),mapPre.get("postfixLength")));
                res.setInputUser(SvnConfig.systemName);
                res.setInputDate(presentTime);
                res.setStatus("1");

                res.settNO(IdGenerator.generate());
                addRes.add(res);

//					//添加用户操作日志
//					UsersLog usersLog = new UsersLog();
//					usersLog.settNO(IdGenerator.generate());
//					usersLog.setUserId(user.getUserId());
//					usersLog.setModuleName("资源维护");
//					usersLog.setLogType("新增");
//					usersLog.setStatus("1");
//					usersLog.setLogTime(new Timestamp(res.getInputDate().getTime()));
//					usersLog.setDescription(user.getUserName()+"新增了"+resList.get(i).getResName());
//					usersLogs.add(usersLog);

                //资源日志赋值
                AuditLog auditLog = new AuditLog();
                auditLog.setHistEntityId(res.gettNO());
                auditLog.setHistVersion(res.getSvnVersion());
                auditLog.setUserId(SvnConfig.systemName);
                auditLog.setHistTime(new Timestamp(res.getInputDate().getTime()));
                auditLog.setHistAction("ADD");
                auditLog.setHistEntityType("RES");
                auditLog.setHistDescription("");
                auditLog.setHistResURL(res.getSvnURL());
                auditLog.setHistResName(res.getResName());
                auditLog.setActionId(1);
                addAuditLog.add(auditLog);
            }

        }
        if (updateRes.size() > 0) {
            //更新的文件
            //判断文件是否进行了更新（比较文件提交后的版本和数据库的版本是否一致）
            for(int i = updateRes.size()-1;i >= 0 ;i--){
                Resource res = updateRes.get(i);
                for(int f = 0;f < fileInfos.size();f++){
                    FileInfo fileInfo = fileInfos.get(f);
                    if(res.getSvnURL().equals(fileInfo.getSvnUrl())){
                        //比较文件提交的版本和数据库中的是否一致，如一致则说明文件未更新
                        if(res.getSvnVersion().equals(fileInfo.getVersion())){
                            updateRes.remove(i);
                        }else{
                            res.setSvnVersion(fileInfo.getVersion());
                            res.setEditUser(SvnConfig.systemName);
                            res.setEditDate(presentTime);
//							if(resExtended != null){
//								res.setExtend(resExtended.getExtend());//添加扩展属性
//							}

                        }
                        break;
                    }
                }
            }

        }
        //9、批量保存
        if(addRes.size()> 0) {
            //1、批量提交到RES表
            if (!resourceService.createBatch(addRes)) {
                resultTotal = -1;
            }
            //保存目录和文件的关联
            if (!catalogResourceLinkService.createBatch(addRes)) {
                resultTotal = -1;
            }
            //保存日志
//            if (!auditLogService.addAuditLogBatch(addAuditLog)) {
//                resultTotal = -1;
//            }

            //保存信息至用户日志

        }

        //判断是否更新
        System.out.println("这是需要更新的文件");
        if(updateRes.size() > 0){
            if(!resourceService.updateBatch(updateRes)){
                resultTotal = -1;
            }

        }
        resourceUploadService.deleteAll(deleteResUpload);



        if(resultTotal == 1){
            resultObject.put("code", ResultMessage.success);
        }else{
            resultObject.put("code", ResultMessage.defeated);
        }
        resultObject.put("result",resultArray);

        ResponseUtil.write(response,resultObject);

    }




}
