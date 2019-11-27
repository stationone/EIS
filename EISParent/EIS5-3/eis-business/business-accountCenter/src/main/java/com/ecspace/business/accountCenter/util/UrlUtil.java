package com.ecspace.business.accountCenter.util;

/**
 * url工具类
 */
public class UrlUtil {
    /**
     * 地址分隔符转换
     * @param path E:\\Repositories\\KnowledgeRepository
     * @return E:/Repositories/KnowledgeRepository
     */
    public static String pathConvert(String path){
        if(path != null){
            path = path.replaceAll("\\\\", "/");
            path = path.replaceAll("//", "/");
        }
        return path;
    }

    /**
     * 删除地址分隔符
     * @param path E:\\Repositories\\KnowledgeRepository\\
     * @return E:\\Repositories\\KnowledgeRepository
     */
    public static String removeEndSeparator(String path){

        //判断最后一位是否有分隔符
        if(path != null && !"".equals(path) && (path.endsWith("/") || path.endsWith("\\"))){
            return path.substring(0,path.length()-1);
        }
        return path;
    }

    /**
     * 修整地址
     * 将\修改为/
     * 去除最开始和结尾的/
     * @param path E:\pdm\socket\
     * @return E:/pdm/socket 如传入为空则返回null
     */
    public static String trimPath(String path){
        path = StringUtil.goOutSpace(path);
        if(path == null){
            return null;
        }
        path = pathConvert(path);
        if(path.startsWith("/")){
            path = path.substring(path.indexOf("/")+1,path.length());
        }
        if(path.endsWith("/")){
            path = path.substring(0,path.lastIndexOf("/"));
        }
        return path;
    }


    public static void main(String[] args) throws Exception {
        String fileNameT="login.png";
        String fileName = fileNameT;
        String fileType = "";
        //判断文件名是否有后缀
        if(fileNameT.contains(".")){
            fileName = fileNameT.substring(0,fileNameT.lastIndexOf("."));
            System.out.println(fileName);
            fileType = fileNameT.substring(fileNameT.lastIndexOf(".")+1, fileNameT.length());
            System.out.println(fileType);
        }









    }



}
