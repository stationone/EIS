package com.ecspace.business.knowledgeCenter.administrator.service;

import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import org.springframework.web.multipart.MultipartFile;

import java.text.ParseException;
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
     * 存储文件信息
     * @param fileInfo
     * @return
     */
    FileInfo saveFileInfo(FileInfo fileInfo) throws Exception;

    /**
     * 类型数据
     * @param indexName
     * @return
     */
    List<FileBase> listTypeField(String indexName);

    /**
     * 存储文件信息
     * @param jsonObject
     * @param status
     */
    FileInfo insertFile(JSONObject jsonObject, String status) throws ParseException, Exception;

    /**
     * 根据文件状态获取文件列表
     * @param menuId
     * @param status
     * @param page
     * @param rows
     * @return
     */
    PageData getFileListByStatus(String menuId, String status, Integer page, Integer rows);

    PageData getFileListByStatus(String menuId, Integer page, Integer rows);

    /**
     * 根据id查找file
     * @param fileId
     * @return
     */
    FileInfo getFileById(String fileId);

    /**
     * 文档解析入库
     * @param fileId
     * @return
     */
    GlobalResult fileAnalyzerSave(String fileId);
}
