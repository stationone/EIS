package com.ecspace.business.knowledgeCenter.administrator.service.impl;
//
//
//
//import com.ecspace.business.knowledgeCenter.administrator.dao.FileMapper;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.File;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.FileSystemCode;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.FileAnalysis.*;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileBaseDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.MenuDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.PageDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.*;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
//import org.springframework.beans.factory.annotation.Autowired;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTypeService;
import com.ecspace.business.knowledgeCenter.administrator.util.FileHashCode;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.io.FileUtils;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.common.xcontent.XContentType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.InputStream;
import java.util.*;

//
//import java.util.*;
//
@Transactional
@Service
public class FileServiceImpl implements FileService {

    @Autowired
    private MenuDao menuDao;

    @Autowired
    private FileInfoDao fileInfoDao;

    @Autowired
    private PageDao pageDao;

    /**
     * 上传文件操作
     *
     * @param file
     * @return
     */
    @Override
    public GlobalResult saveFile(MultipartFile file) throws Exception {
        //文件名
        String filename = file.getOriginalFilename();
        //组装文件路径
        String path;
        //文件分类存储
        assert filename != null;
        switch (filename.substring(filename.lastIndexOf(".") + 1)) {
            case "doc":
            case "docx":
                //存储至服务器word中
                path = "E:/knowledgeCenterFileManger/word/" + filename;
                break;
            case "xls":
            case "xlsx":
                //存储至服务器excel中
                path = "E:/knowledgeCenterFileManger/excel/" + filename;
                break;
            case "ppt":
            case "pptx":
                //存储至服务器ppt中
                path = "E:/knowledgeCenterFileManger/ppt/" + filename;
                break;
            default:
                //存储至服务器other中
                path = "E:/knowledgeCenterFileManger/other/" + filename;
                break;
        }
        //将文件存至其路径
        File fileObj = new File(path);

        InputStream inputStream = file.getInputStream();
        FileUtils.copyInputStreamToFile(inputStream, fileObj);//复制文件至服务器本地
        inputStream.close();//释放资源

        //封装fileInfo对象
//        FileInfo fileInfo = new FileInfo();
//        fileInfo.setHashCode(FileHashCode.generate(path));
//        fileInfo.setId(TNOGenerator.generateId());
//        fileInfo.setFileName(filename);
//        fileInfo.setFilePath(path);
//        fileInfo.setFileSize(file.getSize());
//        assert filename != null;
//        fileInfo.setFileNameSuffix(filename.substring(filename.lastIndexOf(".") + 1));
//        fileInfo.setFileNamePrefix(filename.substring(0, filename.lastIndexOf(".")));
//        fileInfo.setCreationTime(new Date());
//        fileInfo.setKeyword(keyword);
//        fileInfo.setMenuId(menuId);

        return new GlobalResult(false, 2001, "干的漂亮, 稍后可以查看离散文件", path);
    }


    /**
     * 静默解析文件
     *
     * @return
     */
    @Override
    public GlobalResult fileAnalyzer(FileInfo fileInfo) {

        Menu menu = menuDao.findById(fileInfo.getMenuId()).orElse(new Menu());
        String menuUrl = menu.getUrl();
        String indexName = menu.getIndexName();
        fileInfo.setIndexName(indexName);
        //离散文件, 将内容存入page
        /*************************离散文件在用户上传文件成功后, 后台静默执行, **************************************************/

        setFileInfo(fileInfo, menuUrl);
        //将page信息保存至es
        List<Page> pageList = fileInfo.getPageList();
        //执行
//        Iterable<Page> pages = pageDao.saveAll(pageList);
        int i = (int) pageList.stream().map(page -> pageDao.save(page)).filter(Objects::nonNull).count();
        //i == pageList.size
        /*************************离散文件在用户上传文件成功后, 后台静默执行, **************************************************/


        //将fileInfo保存至es
        fileInfo.setPageList(null);
        fileInfo.setFile(null);
        StringBuilder sb = new StringBuilder();
        pageList.forEach(page -> {
            String pageId = page.gettNO().toString();
            sb.append(pageId).append(",");
        });
        String pageIds = sb.toString();
        fileInfo.setPageIds(pageIds);
        FileInfo save = fileInfoDao.save(fileInfo);

        if (i == pageList.size() && save != null) {
            return new GlobalResult(true, 2000, "自动离散完成");
        }
        return new GlobalResult(false, 2001, "文件可能为只读文件, 不可离散");
    }

    /**
     * 获取目录文件
     *
     * @param menuId
     * @param page
     * @param rows
     * @return
     */
    @Override
    public PageData getFileList(String menuId, Integer page, Integer rows) {
        if (page == null) {
            page = 0;
        } else {
            page = (page - 1)*rows;
        }
        if (rows == null) {
            rows = 10;
        }
        Pageable pageable = new PageRequest(page, rows);
        org.springframework.data.domain.Page<FileInfo> infoPage = fileInfoDao.findByMenuId(menuId, pageable);
        List<FileInfo> fileInfoList = infoPage.getContent();
        return new PageData((int) infoPage.getNumberOfElements(), fileInfoList);
    }


    /**
     * 获取目录文件
     *
     * @param menuId
     * @param json
     * @param page
     * @param rows
     * @return
     */
    @Override
    public PageData getFileList(String menuId, String json, Integer page, Integer rows) {
        return null;
    }

    /**
     * 查看文件详情
     *
     * @param fileId
     * @return
     */
    @Override
    public FileInfo getFileDetail(String fileId) {
        FileInfo fileInfo = fileInfoDao.findById(fileId).orElse(new FileInfo());
        System.out.println(fileInfo);
        List<Page> pageList = pageDao.findByFileIdOrderByPageNOAsc(fileId);
        fileInfo.setPageList(pageList);
        return fileInfo;
    }

    /**
     * 获取上传form所需要的表单列
     * @param indexName
     * @return
     */
    @Autowired
    private FileTypeService fileTypeService;
    @Autowired
    private FileBaseDao fileBaseDao;
    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;
    @Override
    public List<FileBase> getFormField(String indexName) {
        //根据索引名称获取字段
        JSONObject mappingInfo = fileTypeService.getMappingInfo(indexName);
        if (mappingInfo == null) {
            return(new ArrayList());
        }
        //封装mapping信息至IndexField
        List<FileBase> fieldList = new ArrayList<>();
        for (String s : mappingInfo.keySet()) {

            FileBase fileBase = new FileBase();
            //字段名称
            fileBase.setFilename(s);
            //其他信息(找不到就只给个名字)
            FileBase base = fileBaseDao.findByFilename(s).orElse(fileBase);

            //将indexField加入fieldList
            fieldList.add(base);
        }

        return fieldList;
    }

    @Override
    public FileInfo saveFileInfo(JSONObject jsonObject) throws Exception {
        String path = (String) jsonObject.get("path");
        String menuId = (String) jsonObject.get("menuId");
//        jsonObject
        File file = new File(path);//new出来文件
        String filename = file.getName();//文件名
        long length = file.length();//文件大小
//        //封装fileInfo对象
        String id = TNOGenerator.generateId();
//        FileInfo fileInfo1 = new FileInfo();
//        fileInfo.setHashCode(FileHashCode.generate(path));
//        fileInfo1.setId(id);

//        fileInfo.setFileName(filename);
//        fileInfo.setFilePath(path);
//        fileInfo.setFileSize(length);
//        fileInfo.setFileNameSuffix(filename.substring(filename.lastIndexOf(".") + 1));
//        fileInfo.setFileNamePrefix(filename.substring(0, filename.lastIndexOf(".")));
//        fileInfo.setCreationTime(new Date());
////        fileInfo.setKeyword(keyword);
//        fileInfo.setMenuId(menuId);
        //封装一个map
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("id", id);
        map.put("fileName", filename);
        map.put("hashCode", FileHashCode.generate(path));
        map.put("filePath", path);
        map.put("fileSize", length);
        map.put("fileNameSuffix", filename.substring(filename.lastIndexOf(".") + 1));
        map.put("fileNamePrefix", filename.substring(0, filename.lastIndexOf(".")));
        map.put("creationTime", new Date().getTime());
        map.put("menuId", menuId);
        jsonObject.putAll(map);//拼接
        IndexResponse indexResponse = elasticsearchTemplate.getClient().prepareIndex("file", "file")
                .setSource(jsonObject, XContentType.JSON)
                .setId(id)
                .get();

        return fileInfoDao.findById(id).orElse(new FileInfo());
    }

    @Override
    public GlobalResult file2Html(FileInfo fileInfo) {
        Menu menu = menuDao.findById(fileInfo.getMenuId()).orElse(new Menu());
        String menuUrl = menu.getUrl();
        String indexName = menu.getIndexName();
        fileInfo.setIndexName(indexName);


        return null;
    }

    /**
     * 解析office文件, 设置pegeList, nodeList, fileId
     *
     * @param fileInfo 必须有filePath fileNamePrefix
     * @return 装着pdf和pageList的fileInfo
     */
    public void setFileInfo(FileInfo fileInfo, String menuUrl) {
        if (fileInfo == null || fileInfo.getFilePath() == null) {
            return;
        }
        //被操作的文件路径(参数传入)
        String localPath = fileInfo.getFilePath();
        //创建一个文件信息对象, 作为被转换的pdf 444.50 516.00 960.50
        FileInfo knowledge = new FileInfo();

        //给被转换的pdf起名字, 源文件名
        knowledge.setFileName(fileInfo.getFileName());

        //定义一个集合, 存储file对象被离散后的page页
        List<Page> pageList = new ArrayList<>();

        //word或ppt文件(转成PDF)
        if (localPath.endsWith("doc") ||
                localPath.endsWith("docx") ||
                localPath.endsWith("ppt") ||
                localPath.endsWith("pptx") ||
                localPath.endsWith("pdf")) {

            //组装转换后的pdf文件路径
            //            String pdfFilePath = menuUrl + "/" + fileInfo.getFileNamePrefix() + ".pdf";//跟原始文件保存在一起

            //离散前的PDF和离散后的PDF保存在另一个目录（PDFFile）的统一的目录下（目录名称就是文件的哈希）；
//            String pdfFileDirectory = "E:/knowledgeCenterPdfFile/" + fileInfo.getHashCode();
            //保存至webDoc中
            String pdfFileDirectory = "E:/knowledgeCenterFileManger/webDoc/" + fileInfo.getHashCode();
            //创建出来
            if (!new File(pdfFileDirectory).exists()) {
                new File(pdfFileDirectory).mkdir();
            }
            String pdfFilePath = pdfFileDirectory + "/" + fileInfo.getHashCode() + ".pdf";
            fileInfo.setPdfFilePath(pdfFilePath);

            //web预览访问地址
            fileInfo.setFilePdf("../knowledgeCenterFileManger/webDoc/" + fileInfo.getHashCode() + "/" + fileInfo.getHashCode() + ".pdf");

            //切割pdf, 每页转成一个pdf
//            String splitPdfPath = menuUrl + "/split";//存储在当前目录下的split目录下
//            String splitPdfPath = "E:/knowledgeCenterPdfFile/" + fileInfo.getHashCode();
//
//            if (!new java.io.File(splitPdfPath).exists()) {
////                File file = new File(splitPdfPath);
//                new java.io.File(splitPdfPath).mkdir();
//            }
//            //自动创建出split文件夹
//            if (!new java.io.File(splitPdfPath).exists()) {//分类文件夹不存在
//                new java.io.File(splitPdfPath).mkdir();//创建文件夹
//            }

            boolean exchangeFlag = false;

            //word转换成PDF

            if (localPath.endsWith(".doc") || localPath.endsWith(".docx")) {
                exchangeFlag = Office2Pdf.word2pdf(localPath, pdfFilePath);
                //ppt转换成PDF
            } else if (localPath.endsWith(".ppt") || localPath.endsWith(".pptx")) {
                exchangeFlag = Office2Pdf.ppt2pdf(localPath, pdfFilePath);
            } else if (localPath.endsWith(".pdf")) {
                exchangeFlag = true;
                //将PDF文件原本的路径赋值给存储PDF文件的路径
                pdfFilePath = localPath;
            }
            if (exchangeFlag) {  //转换成功
                //总页数
                int pageCount = PDFReader.getPageCount(pdfFilePath);
                //文件总页数设置
                fileInfo.setPageTotal(pageCount);
                //文件预览简介(正文第一页30个字)
                String content = PDFReader.readPdfText(pdfFilePath, 1, 1);
                StringBuilder contentSB = new StringBuilder(content);
                contentSB.append("......");
                fileInfo.setContent(contentSB.toString());

                //循环遍历PDF文件的每一页，提取并封装信息
                for (int i = 0; i < pageCount; i++) {
                    //构建页面对象
                    Page page = new Page();
                    //每个页面设置id
                    page.settNO(Long.parseLong(TNOGenerator.generateId()));
                    //页面在源文件中的页码
                    page.setPageNO(i + 1);
                    //内容, 用于被检索 , 直接检索, 存储分词
                    page.setContent(PDFReader.readPdfText(pdfFilePath, i + 1, i + 1));
                    //截取的PDF文件路径("E:\pdf\splitPdf\1.pdf")
                    String splitPdfFilePath = pdfFileDirectory + "/" + fileInfo.getHashCode() + "_" + String.valueOf(i + 1) + ".pdf";
                    //page地址
                    page.setPath(splitPdfFilePath);
                    //将PDF文件的页生成新的PDF文件
                    if (PDFReader.splitPdfFile(pdfFilePath, splitPdfFilePath, i + 1, i + 1)) {
                        page.setPdfPage(new java.io.File(splitPdfFilePath));     //转换成文件封装进对象
                        page.setPageWebPath("../knowledgeCenterFileManger/webDoc/" + fileInfo.getHashCode() + "/" + fileInfo.getHashCode() + "_"+ String.valueOf(i+1) + ".pdf");
                    } //不存储
//                    page.setKnowledge(fileInfo);//page所在的file//不存储
                    //page所在的文件id
                    page.setFileId(fileInfo.getId());


                    //存在问题：文档未从第一页开始编码 则page解析与node解析的页码无法匹配
                    if (localPath.endsWith(".doc") || localPath.endsWith(".docx")) {
                        //正文开始位置（即第一个目录的实际页码而非目录对应页码）
//                        int startPageNum = 1;
//                        int D_value = startPageNum - 1;     //目录实际页码与目录对应页码的差值
                        //所有解析的目录, 遍历与page解析的页面进行对应
                        List<FileDirectoryNode> nodeList = WordUtil.getWordNodes(localPath);
                        List<FileDirectoryNode> pageNodeList = new ArrayList<>();
                        for (FileDirectoryNode node : nodeList) {
//                            node.getPage().setPageNO(node.getPage().getPageNO() + D_value);     //目录对应页码+差值即为目录实际的页码
                            if (node.getPage().getPageNO() == page.getPageNO()) {
                                pageNodeList.add(node);
                            }
                        }
//                        page.setNodeList(pageNodeList);
                        StringBuilder sb = new StringBuilder();
                        for (FileDirectoryNode fileDirectoryNode : pageNodeList) {
                            sb.append(fileDirectoryNode.getNodeNO()).append(",");
                        }
                        page.setDirectoryNodeIds(sb.toString());
//                        System.out.println(page.getDirectoryNodeIds());
                    }
                    pageList.add(page);
                }
            }
            //excel文件(转成HTML)
        } else if (localPath.endsWith(".xls") || localPath.endsWith(".xlsx")) {
            //转换后的HTML文件路径（"E:\html\aaa.html"）
            String htmlFilePath = menuUrl + "/" + fileInfo.getFileNamePrefix() + ".html";//跟原始文件保存在一起
            //相应的子HTML文件存放的位置（"E:\html\aaa.files"）
            String subHtmlPath = menuUrl + "/" + fileInfo.getFileNamePrefix() + ".files\\";
            //“E://htmlFile//日志及周报模板.html”报错    “E:\\htmlFile\\日志及周报模板.html”正常
            boolean exchangeFlag = Office2Html.excel2Html(localPath, htmlFilePath);
            if (exchangeFlag) {
                //获取当前Excel文档的所有sheet页
                int pageCount = ExcelUtil.getSheets(localPath);
                for (int i = 0; i < pageCount; i++) {
                    Page page = new Page();
                    page.settNO(Long.parseLong(TNOGenerator.generateId()));
                    page.setPageNO(i + 1);
                    //子HTML文件路径（"E:\html\aaa.files\sheet001.html"）
                    String num = HtmlUtil.formatSheetHtmlNum(i + 1);
                    String subHtmlFilePath = subHtmlPath + "sheet" + num + ".html";
                    page.setContent(HtmlUtil.getText(subHtmlFilePath));
//                    page.setPdfPage(new java.io.File(subHtmlFilePath));     //转换成文件封装进对象
//                    page.setKnowledge(fileInfo);
                    page.setFileId(fileInfo.getId());
                    pageList.add(page);
                }
            }
        }
        fileInfo.setPageList(pageList);
    }

}
