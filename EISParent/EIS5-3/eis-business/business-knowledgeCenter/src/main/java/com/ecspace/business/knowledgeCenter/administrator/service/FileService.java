package com.ecspace.business.knowledgeCenter.administrator.service;

import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

//
//
//
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
//
//import java.io.File;
//
public interface FileService {

    /**
     * 保存上传的文件
     * @param file
     * @return
     */
    GlobalResult saveFile(MultipartFile file) throws Exception;

    /**
     * 静默离散文件
     * @param fileInfo
     * @return
     */
    GlobalResult fileAnalyzer(FileInfo fileInfo);

    /**
     * 查询文件列表
     *
     * @param menuId
     * @param page
     * @param rows
     * @return
     */
    PageData getFileList(String menuId, Integer page, Integer rows);

    /**
     * 查询文件列表
     * @param menuId
     * @param json
     * @param page
     * @param rows
     * @return
     */
    PageData getFileList(String menuId, String json, Integer page, Integer rows);

    /**
     * 获取文件详情
     * @param fileId
     * @return
     */
    FileInfo getFileDetail(String fileId);

    /**
     * 获取上传表单列
     * @param indexName
     * @return
     */
    List<FileBase> getFormField(String indexName);

    /**
     * 存储文件信息
     * @param jsonObject
     * @return
     */
    FileInfo saveFileInfo(JSONObject jsonObject) throws Exception;

    /**
     * office转html
     * @param fileInfo
     * @return
     */
    GlobalResult file2Html(FileInfo fileInfo);
//
//
//    /**
//     * 保存文件到数据库
//     * @param name
//     * @param desFile
//     * @return
//     */
//    int insertFile(String name, String desFile);
//
//    /**
//     * 文件列表
//     * @param page
//     * @param rows
//     * @return
//     */
//    PageData getFileList(Integer page, Integer rows);
//
//    /**
//     * 删除文件信息
//     * @param fileId
//     * @return
//     */
//    GlobalResult removeFile(Integer fileId);
//
//    /**
//     * 查找文件
//     * @param fileId
//     * @return
//     */
//    GlobalResult getFile(Integer fileId);
//
//    /**
//     * 查找文件
//     * @param fileId
//     * @return
//     */
//    File getFileById(Integer fileId);
//
//    /**
//     * 查询文件详情
//     * @param fileId
//     * @return
//     */
//    File getFileAndRoleById(Integer fileId);
//
//    /**
//     * 查询文件可以添加的角色
//     * @param fileId
//     * @return
//     */
//    PageData getFileOtherRole(Integer fileId);
//
//    /**
//     * 移除文件角色
//     * @param fileId
//     * @param uuid
//     * @return
//     */
//    GlobalResult removeFileRole(Integer fileId, Integer uuid);
//
//    /**
//     * 文件角色关联
//     * @param fileId
//     * @param uuid
//     * @return
//     */
//    GlobalResult addFileRole(Integer fileId, Integer uuid);
//
////    /**
////     * 过去登录人的文件权限
////     * @param userInfo
////     * @return
////     */
////    PageData getUserFile(UserInfo userInfo);
////
////    /**
////     * @return
////     */
////    GlobalResult getRole(UserInfo userInfo);
}
