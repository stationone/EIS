package com.ecspace.business.knowledgeCenter.administrator.service.impl;
//
//
//
//import com.ecspace.business.knowledgeCenter.administrator.dao.FileMapper;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.File;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.FileSystemCode;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
//import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

import com.ecspace.business.knowledgeCenter.administrator.FileAnalysis.*;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.MenuDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.PageDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileDirectoryNode;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Page;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
//import org.springframework.beans.factory.annotation.Autowired;
import com.ecspace.business.knowledgeCenter.administrator.util.FileHashCode;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

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
     * @param menuId
     * @param keyword
     * @return
     */
    @Override
    public GlobalResult saveFile(MultipartFile file, String menuId, String keyword) throws Exception {
        //文件名
        String filename = file.getOriginalFilename();
        //组装文件路径
        Menu menu = menuDao.findById(menuId).orElse(new Menu());
        String menuUrl = menu.getUrl();
        String path = menuUrl + "/" + filename;
        //将文件存至其路径
        File fileObj = new File(path);
        FileUtils.copyInputStreamToFile(file.getInputStream(), fileObj);//复制文件至服务器本地

        //封装fileInfo对象
        FileInfo fileInfo = new FileInfo();

        fileInfo.setHashCode(FileHashCode.generate(path));
        fileInfo.setId(TNOGenerator.generateId());
        fileInfo.setFileName(filename);
        fileInfo.setFilePath(path);
        fileInfo.setFileSize(file.getSize());
        assert filename != null;
        fileInfo.setFileNameSuffix(filename.substring(filename.lastIndexOf(".") + 1));
        fileInfo.setFileNamePrefix(filename.substring(0, filename.lastIndexOf(".")));
        fileInfo.setCreationTime(new Date());
        fileInfo.setKeyword(keyword);
        fileInfo.setMenuId(menuId);

        return new GlobalResult(false, 2001, "干的漂亮", fileInfo);
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
        return new GlobalResult(false, 2001, "离散失败");
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
        }else {
            page = page -1;
        }
        if (rows == null) {
            rows = 10;
        }
        Pageable pageable = new PageRequest(page,rows);
        org.springframework.data.domain.Page<FileInfo> infoPage =  fileInfoDao.findByMenuId(menuId, pageable);
        List<FileInfo> fileInfoList = infoPage.getContent();
        for (FileInfo fileInfo : fileInfoList) {
            System.out.println(fileInfo.getFileNamePrefix());
        }


        return new PageData((int) infoPage.getNumberOfElements(),fileInfoList);
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

            //离散前的PDF和离散后的PDF保存在另一个目录（PDFFile）的统一的目录下（目录名称就是文件的
            //哈希）；
            String pdfFileDirectory = "E:/knowledgeCenterPdfFile/" + fileInfo.getHashCode();
            //创建出来
            if (!new File(pdfFileDirectory).exists()) {
                new File(pdfFileDirectory).mkdir();
            }
            String pdfFilePath = pdfFileDirectory + "/" + fileInfo.getHashCode() + ".pdf";
            fileInfo.setPdfFilePath(pdfFilePath);

            //切割pdf, 每页转成一个pdf
//            String splitPdfPath = menuUrl + "/split";//存储在当前目录下的split目录下
            String splitPdfPath = "E:/knowledgeCenterPdfFile/" + fileInfo.getHashCode();

            if (!new java.io.File(splitPdfPath).exists()) {
                new java.io.File(splitPdfPath).mkdir();
            }
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
                String content = PDFReader.readPdfText(pdfFilePath, 1, 1).substring(250,500);
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
                    String splitPdfFilePath = splitPdfPath + "/" + fileInfo.getHashCode() + "_" + String.valueOf(i + 1) + ".pdf";
                    //page地址
                    page.setPath(splitPdfFilePath);
                    //将PDF文件的页生成新的PDF文件
                    if (PDFReader.splitPdfFile(pdfFilePath, splitPdfFilePath, i + 1, i + 1)) {
                        page.setPdfPage(new java.io.File(splitPdfFilePath));     //转换成文件封装进对象
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
//        for (int i = 0; i < fileInfo.getPageList().size(); i++) {
//            System.out.println("第" + fileInfo.getPageList().get(i).getPageNO() + "页");
//            System.out.println("content：" + fileInfo.getPageList().get(i).getContent());
//            List<FileDirectoryNode> nodeList = fileInfo.getPageList().get(i).getNodeList();
//            if (nodeList == null || nodeList.size() == 0) {
//                System.out.println("    node：无");
//            } else {
//                for (FileDirectoryNode node : nodeList) {
//                    System.out.println("    nodeName：" + node.getNodeName());
//                    System.out.println("        level：" + node.getLevel());
//                    if (node.getParentNode() != null) {
//                        System.out.println("        parentNode：" + node.getParentNode().getNodeName());
//                    } else {
//                        System.out.println("        parentNode：无");
//                    }
//                    List<FileDirectoryNode> subNodeList = node.getSubNodeList();
//                    if (subNodeList == null || subNodeList.size() == 0) {
//                        System.out.println("        subNode：无");
//                    } else {
//                        for (FileDirectoryNode subNode : subNodeList) {
//                            System.out.println("        subNode：" + subNode.getNodeName());
//                        }
//                    }
//                    if (node.getPreviousNode() != null) {
//                        System.out.println("        previoousNode：" + node.getPreviousNode().getNodeName());
//                    } else {
//                        System.out.println("        previoousNode：无");
//                    }
//                    if (node.getNextNode() != null) {
//                        System.out.println("        nextNode：" + node.getNextNode().getNodeName());
//                    } else {
//                        System.out.println("        nextNode：无");
//                    }
//                }
//            }
//        }
    }


//
//    @Autowired
//    FileMapper fileMapper;
//
//    @Override
//    public int insertFile(String name, String filePath) {
//        File fileInfo = new File();
//        fileInfo.setName(name);
//        fileInfo.setFilePath(filePath);
//
//
//        int i = fileMapper.insert(fileInfo);
//        Integer fileId = fileInfo.getFileId();
//        //所有文件上传完毕授予admin的角色
//        int i1 = fileMapper.insertFileRole(fileId, 1);
//        return i == i1 ? 1 : 0;
//    }
//
//    /**
//     * 件列表
//     * @param page
//     * @param rows
//     * @return
//     */
//    @Override
//    public PageData getFileList(Integer page, Integer rows) {
//        PageHelper.startPage(page, rows);
//        List<File> fileList = fileMapper.selectFileList();
//        //封装pageData
//        PageInfo<File> pageInfo = new PageInfo<>(fileList);
//        PageData pageData = new PageData();
//        pageData.setTotal((int) pageInfo.getTotal());
//        pageData.setRows(pageInfo.getList());
//        return pageData;
//    }
//
//    @Override
//    public GlobalResult removeFile(Integer fileId) {
//        if (fileId == null) {
//            return new GlobalResult(400, "文件不存在", null);
//        }
//
//        try {
//            //删除本次存储目录中的文件
//            //根据id查到文件信息
//            File fileInfo = fileMapper.selectFileById(fileId);
//            String filePath = fileInfo.getFilePath();
//            boolean b = DeleteFileUtil.deleteFile(filePath);
//            System.out.println(b);
//            //删除数据库中数据
//            if (b) {
//                int i = fileMapper.remove(fileId);
//            }
//
//            return new GlobalResult(200, "删除成功", null);
//
//        } catch (Exception e) {
//            return new GlobalResult(500, "删除失败", null);
//        }
//    }
//
//
//
//
//
//
//
//
//    @Override
//    public GlobalResult getFile(Integer fileId) {
//        if (fileId == null) {
//            return new GlobalResult(400, "文件不存在", null);
//        }
//
//
//        return null;
//    }
//
//    /**
//     * 查询文件
//     * @param fileId
//     * @return
//     */
//    @Override
//    public File getFileById(Integer fileId) {
//        if (fileId == null) {
//            return null;
//        }
//
//        File fileInfo = fileMapper.selectFileAndRoleById(fileId);
//
//        if (fileInfo == null) {
//            return null;
//        }
//
//        return fileInfo;
//    }
//
//    /**
//     * 查询文件详情, 包括与文件关联的角色
//     * @param fileId
//     * @return
//     */
//    @Override
//    public File getFileAndRoleById(Integer fileId) {
//        if (fileId == null) {
//            return null;
//        }
//
//        File fileInfo = fileMapper.selectFileAndRoleById(fileId);
//
//        if (fileInfo == null) {
//            return null;
//        }
//
//        return fileInfo;
//    }
//
//    @Override
//    public PageData getFileOtherRole(Integer fileId) {
//
//        List<Role> roleList = fileMapper.selectOtherRole(fileId);
//        PageData pageData = new PageData();
//        pageData.setRows(roleList);
//        pageData.setTotal(roleList.size());
//        return pageData;
//
//    }
//
//    @Override
//    public GlobalResult removeFileRole(Integer fileId, Integer uuid) {
//        try {
//            int i=fileMapper.deleteFileRole(fileId, uuid);
//        } catch (Exception e) {
//            return new GlobalResult(400, "ERROR", null);
//        }
//        return new GlobalResult(200, "SUCCESS", null);
//    }
//
//    @Override
//    public GlobalResult addFileRole(Integer fileId, Integer uuid) {
//        try {
//            int i = fileMapper.insertFileRole(fileId, uuid);
//            if (i != 1) {
//                return new GlobalResult(400, "ERROR", null);
//            }
//        } catch (Exception e) {
//            return new GlobalResult(400, "ERROR", null);
//        }
//
//        return new GlobalResult(200, "SUCCESS", null);
//    }
//
////    /**
////     * 注入权限mapper
////     */
////    @Autowired
////    private RoleMapper roleMapper;
//
////    @Override
////    public PageData getUserFile(UserInfo userInfo) {
////        PageData pageData = new PageData();
////
////        //遍历roleList, 获取fileList
////        Map<Integer,File> fileList = new HashMap<Integer,File>();
////        if (userInfo != null && userInfo.getRoleList().size() > 0) {
////            for (Role role : userInfo.getRoleList()) {
////                Role roleAndFile = roleMapper.selectRoleAndFile(role.getUuid());
////                if (roleAndFile != null && roleAndFile.getFileList().size() > 0) {
////                    for (File file : roleAndFile.getFileList()) {
////                        //因为是对象, 所以每个file都不一样
////                        fileList.put(file.getFileId(), file);
////                    }
////                }
////
////            }
////        }
////
////        List<File> arrayList = new ArrayList<File>(fileList.values());
////        arrayList.sort(Comparator.comparing(File::getFileId));
////        pageData.setRows(arrayList);
////        pageData.setTotal(arrayList.size());
////        return pageData;
////    }
////
////    @Override
////    public GlobalResult getRole(UserInfo userInfo) {
////        if (userInfo != null && userInfo.getRoleList().size() > 0) {
////            for (Role role : userInfo.getRoleList()) {
////                if (1 == (role.getUuid())) {
////                    return new GlobalResult(1, "是管理员", null);
////                }
////            }
////        }
////        return new GlobalResult(0, "不是管理员", null);
////    }
}
