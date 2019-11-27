package com.ecspace.business.resourceCenter.user.controller;

import com.ecspace.business.resourceCenter.user.service.ResourceUploadService;
import com.ecspace.business.resourceCenter.user.service.entity.ResUpload;
import com.ecspace.business.resourceCenter.user.util.SvnConfig;
import com.ecspace.business.resourceCenter.util.ResponseUtil;
import com.ecspace.business.resourceCenter.util.ResultMessage;
import com.ecspace.business.resourceCenter.util.StringUtil;
import com.ecspace.business.resourceCenter.util.SvnConfigUtil;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

@Controller
@RequestMapping("/userResourceUpload")
public class UserResourceUploadController {

    @Autowired
    private ResourceUploadService resourceUploadService;

    /**
     * 单个文件上传（最新）
     * tNO: f_012241883088093 上传记录表的流水号(用于在页面实时显示进度)
     * catalogNO: 0501 目录编号
     * repositoryName: pdm_1 版本库名称
     * userRepositoryName: pdm1 用户检出版本库名称
     * catalogPath: /text/text1
     * fileSize: 4373 文件大小
     * @param file
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/uploadFile")
    public void uploadFile(MultipartFile file, HttpServletRequest request, HttpServletResponse response){

        String tNO = StringUtil.goOutSpace(request.getParameter("tNO"));
        String catalogNO = StringUtil.goOutSpace(request.getParameter("catalogNO"));
        String repository = StringUtil.goOutSpace(request.getParameter("repositoryName"));
        String userRepository = StringUtil.goOutSpace(request.getParameter("userRepositoryName"));
        String catalogPath = StringUtil.goOutSpace(request.getParameter("catalogPath"));
        String fileSize = StringUtil.goOutSpace(request.getParameter("fileSize"));

        JSONObject jsonObject = new JSONObject();
        if(tNO == null && catalogNO == null && repository == null && userRepository == null && fileSize == null){
            jsonObject.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response, jsonObject);
            return;
        }



        //userGroup/1903121443285768940/pdm_1/text/text1
        StringBuilder fileSavePath = new StringBuilder(SvnConfig.userGroup);
                    fileSavePath.append(SvnConfigUtil.fileSeparate);
                    fileSavePath.append(SvnConfig.systemName);
                    fileSavePath.append(SvnConfigUtil.fileSeparate);
                    fileSavePath.append(userRepository);
                    if(catalogPath != null){
                        fileSavePath.append(SvnConfigUtil.fileSeparate);
                        fileSavePath.append(catalogPath);
                    }



        System.out.println("服务器文件保存地址:"+fileSavePath.toString());
        //保存文件至服务器用户目录
        String file_save_Path = copeFileServer(file,SvnConfig.workCopy+SvnConfigUtil.fileSeparate+fileSavePath.toString());

        if(file_save_Path == null){
            jsonObject.put("code",ResultMessage.defeated);
            ResponseUtil.write(response, jsonObject);
            return;
        }

        ResUpload resUpload = new ResUpload();
        resUpload.settNO(tNO);
        resUpload.setCatalogNO(catalogNO);
        resUpload.setCatalogName(repository);
        resUpload.setResName(file.getOriginalFilename());
        resUpload.setUserId(SvnConfig.systemName);
        resUpload.setStatus("1");
        resUpload.setFileWorkCopyPath(fileSavePath.toString());
        resUpload.setFileSize(fileSize);
        boolean result = resourceUploadService.add(resUpload);

        if(result){
            jsonObject.put("code",ResultMessage.success);
        }else{
            jsonObject.put("code",ResultMessage.defeated);
        }
        ResponseUtil.write(response, jsonObject);
    }

    /**
     * 下载文件至服务器
     * @param file
     * @param filePath
     */
    public static String copeFileServer(MultipartFile file,String filePath){
        File real = new File(filePath);
        if (!real.exists()) {
            real.mkdirs();
        }
        String fileSavePath = filePath + "/" + file.getOriginalFilename();
        FileOutputStream out = null;
        InputStream inputStream = null;
        try {
            out = new FileOutputStream(new File(fileSavePath));
            inputStream = file.getInputStream();

            byte[] bytes = new byte[1024 * 5];
            int len = -1;
            while ((len = inputStream.read(bytes)) != -1) {
                out.write(bytes, 0, len);
            }
            return fileSavePath;
        } catch (IOException e) {
            e.printStackTrace();

        }finally {
            if(out != null){
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(inputStream != null){
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }


}
