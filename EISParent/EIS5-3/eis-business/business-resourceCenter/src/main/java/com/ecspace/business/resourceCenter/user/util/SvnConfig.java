package com.ecspace.business.resourceCenter.user.util;

import com.ecspace.business.resourceCenter.util.StringUtil;
import com.ecspace.business.resourceCenter.util.SvnConfigUtil;
import com.ecspace.business.resourceCenter.util.UrlUtil;

public class SvnConfig {
    //当前普通用户tNO
    public static String systemName = "1905221635649883314";

    public static String svnURL="https://lvkailiang/svn";

    public static String svnName = "asd";

    public static String svnPassword = "root";

    //版本仓库地址
    public static String repositoriesPath = "E:/Repositories";

    //文件下载地址
    public static String fileSavePath = "E:/pdm/download";

    public static String workCopy = "E:/pdm/workCopy";

    public static String userGroup = "userGroup";

    //工作副本
    public static String svnWorkCopy = workCopy+SvnConfigUtil.fileSeparate+userGroup;

    public static void main(String[] args) {

        System.out.println("RW".toLowerCase());


    }
}
