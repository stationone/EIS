package com.ecspace.business.resourceCenter.user.util;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

public class FileUtil {	/**
 * 解析文件名称和类型
 * @param filePath 传入文件名称或文件路径 text.txt
 * @return map {"fileName":"text","fileType":"txt"}
 */
public static Map<String,String> getFileNameAndFileType(String filePath){
    Map<String,String> map = new HashMap<>();
    File file = new File(filePath);

    int suffixBegan = file.getName().lastIndexOf(".");
    if(suffixBegan == -1){
        map.put("fileName",file.getName());
        map.put("fileType",null);
    }else{
        map.put("fileName",file.getName().substring(0,suffixBegan));
        map.put("fileType",file.getName().substring(suffixBegan + 1, file.getName().length()));
    }
    return map;
}
}
