package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTempService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;


/**
 * 文件管理接口
 *
 * @author zhangch
 * @date 2019/11/12 0012 下午 16:24
 */
@RestController
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;


    /**
     * 上传文件
     *
     * @param file
     * @return
     */
    @PostMapping(value = "fileUpload")
    public GlobalResult handleFileUpload(@RequestParam("file") MultipartFile file) throws Exception {
        //非空判断
        if (file.isEmpty()) {
            return new GlobalResult(false, 2001, "非法参数");
        }

        //调用文件服务
        return fileService.saveFile(file);
    }


    /**
     * 保存文件参数
     *
     * @param json
     * @return
     */
    @PostMapping(value = "fileForm")
    public GlobalResult fileForm(String json, String status) throws Exception {
        if (json == null) {
            return new GlobalResult(false, 4000, "非法参数");
        }
        //解析json
        JSONObject jsonObject = JSON.parseObject(json);
        if ("".equals(jsonObject.get("filePath"))) {
            return new GlobalResult(false, 4000, "没有文件");
        }

        FileInfo fileInfo = fileService.insertFile(jsonObject, status);
//        fileService.saveFileInfo(jsonObject);

        //调用文件服务
//        FileInfo fileInfo = fileService.saveFileInfo(jsonObject);
//        System.out.println(json);
        return new GlobalResult(true, 2000, "true", fileInfo);
    }

//
//    /**
//     * 文件离散
//     *
//     * @param fileInfo
//     * @return
//     * @throws Exception
//     */
//    @PostMapping(value = "fileAnalyzer")
//    public GlobalResult fileAnalyzer(@RequestBody FileInfo fileInfo) throws Exception {
//
//        //调用文件服务
//        return fileService.fileAnalyzer(fileInfo);
////        return fileService.file2Html(fileInfo);
//    }

    /**
     * 文件入库后解析
     *
     * @param fileId
     * @return
     * @throws Exception
     */
    @PostMapping(value = "fileAnalyzer")
    public GlobalResult fileAnalyzer(String fileId) throws Exception {

        //调用文件服务
        return fileService.fileAnalyzerSave(fileId);
    }

    /**
     * 获取目录文件
     *
     * @param menuId
     * @param json
     * @param page
     * @param rows
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "fileList")
    public PageData fileList(String menuId, String json, Integer page, Integer rows) throws Exception {

        if (StringUtils.isBlank(menuId)) {
            return new PageData();
        }
        //没有请求参数时, 数据全部搜索出来
        if (StringUtils.isBlank(json) || JSON.parseObject(json).isEmpty() || StringUtils.isBlank(JSON.parseObject(json).get("search").toString())) {
            //查询所有
            return fileService.getFileList(menuId, page, rows);
        }
        //条件查询
        return fileService.getFileList(menuId, json, page, rows);
    }

    /**
     * 根据状态列出文件列表
     *
     * @param menuId
     * @param status
     * @param page
     * @param rows
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "fileListByStatus")
    public PageData fileListByStatus(String menuId, String status, Integer page, Integer rows) throws Exception {
        if (StringUtils.isBlank(menuId) || StringUtils.isBlank(status)) {//没有参数传递
            return new PageData();
        }
        //根据状态查询所有()(已提交 - 未审核) status == 2
        return fileService.getFileListByStatus(menuId, status, page, rows);
    }

    /**
     * 根据状态列出文件列表
     *
     * @param menuId
     * @param page
     * @param rows
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "fileListByStatusSubmit")
    public PageData fileListByStatusSubmit(String menuId, Integer page, Integer rows) throws Exception {
        if (StringUtils.isBlank(menuId)) {//没有参数传递
            return new PageData();
        }
        //根据状态查询所有()(已提交 - 未审核) status == 2
        return fileService.getFileListByStatus(menuId, page, rows);
    }


    /**
     * 查看文件详情
     *
     * @param fileId
     * @return
     * @throws Exception
     */
    @GetMapping(value = "fileDetail")
    public FileInfo fileDetail(String fileId) throws Exception {

        return fileService.getFileDetail(fileId);
    }

    @GetMapping(value = "getFormField")
    public List<FileBase> getFormField(String indexName) throws Exception {

//        return fileService.getFormField(indexName);
        //表单列由之前的mapping优化为document
        return fileService.listTypeField(indexName);
    }

    @Autowired
    private FileTempService fileTempService;

    /**
     * 上传文件
     *
     * @param file
     * @return
     */
//    @RequestMapping(value = "/fileTempUpload", method = RequestMethod.POST)
//    public GlobalResult fileTempUpload(@RequestParam(value = "file")
//                                                    CommonsMultipartFile[]  files,
//                                       @RequestParam(value = "indexName")
//                                                    String indexName,
//                                       @RequestParam(value = "menuId")
//                                                    String menuId) throws Exception {
    @RequestMapping(value = "/fileTempUpload", method = RequestMethod.POST)
    public GlobalResult fileTempUpload(@RequestParam(value = "file")
                                               MultipartFile file,
                                       @RequestParam(value = "indexName")
                                               String indexName,
                                       @RequestParam(value = "menuId")
                                               String menuId) throws Exception {
        return fileTempService.fileTempUpload(file, indexName, menuId);
    }


    /**
     * 下载文件
     *
     * @param fileId
     * @param response
     * @return
     */
    @RequestMapping(value = "fileDownload", method = RequestMethod.POST)
    public GlobalResult handleFileDownload(@RequestParam("fileId") String fileId, HttpServletResponse response) {
        FileInfo fileInfo = fileService.getFileById(fileId);

        String filePath = fileInfo.getFilePath();
        String fileName = fileInfo.getFileName();

        BufferedInputStream bis = null;
        OutputStream os = null;
        try {
            String dfileName = new String(fileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
            String downloadFileName = URLEncoder.encode(fileName, "utf-8");
//            System.out.println(dfileName + "/" + downloadFileName);

//            File file = new File(filePath + fileName);
            File file = new File(filePath);//服务端文件
            response.reset();

            response.setContentType("application/octet-stream");
            response.setCharacterEncoding("utf-8");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

            byte[] buff = new byte[1024];
            os = response.getOutputStream();
            bis = new BufferedInputStream(new FileInputStream(file));
            int i = 0;
            while ((i = bis.read(buff)) != -1) {
                os.write(buff, 0, i);
                os.flush();
            }

        } catch (Exception e) {
            return new GlobalResult(false, 5000, e.getMessage());
        } finally {
            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
//                    e.printStackTrace();
                    System.out.println(
                            e.getMessage()
                    );

                }
            }
        }
        return null;
    }


}
