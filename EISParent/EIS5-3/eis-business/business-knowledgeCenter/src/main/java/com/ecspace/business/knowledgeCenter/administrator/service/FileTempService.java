package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.IOException;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 20:30
 */
public interface FileTempService {
    /**
     * office转html
     * @param fileInfo
     * @return
     */
    GlobalResult file2Html(FileInfo fileInfo) throws IOException;

    /**
     * 文件临时预览
     * @param file
     * @return
     */
    GlobalResult fileTemp(MultipartFile file) throws Exception;

    /**
     * 批量上传文件
     * @param file
     * @param indexName
     * @param menuId
     * @return
     */
    GlobalResult fileTempUpload(MultipartFile file, String indexName, String menuId) throws Exception;

    /**
     * 删除临时上传的文件
     * @param id
     * @return
     */
    GlobalResult deleteFile(String id);
}
