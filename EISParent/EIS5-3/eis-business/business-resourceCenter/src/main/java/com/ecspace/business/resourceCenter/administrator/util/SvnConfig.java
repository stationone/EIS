package com.ecspace.business.resourceCenter.administrator.util;

import com.ecspace.business.resourceCenter.util.SvnConfigUtil;

public class SvnConfig {
    //当前管理员tNO
    public static String systemName = "2017103109420969753";

    public static String svnURL="https://lvkailiang/svn";

    public static String svnName = "root";

    public static String svnPassword = "root";

    //版本仓库地址
    public static String repositoriesPath = "E:/Repositories";

    //文件下载地址
    public static String fileSavePath = "E:/pdm/download";

    public static String workCopy = "E:/pdm/workCopy";

    public static String userGroup = "userGroup";

    //工作副本
    public static String svnWorkCopy = workCopy+ SvnConfigUtil.fileSeparate+userGroup;



}
