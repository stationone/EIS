package com.ecspace.test;

import org.junit.Test;

import java.io.File;

/**
 * @author zhangch
 * @date 2019/12/10 0010 下午 14:02
 */
public class MusicRename {

    String path = "C:/Users/Administrator/Downloads/周杰伦无损合集/";
    @Test
    public void rename(){
        File fileDirectory = new File(path);
        System.out.println(fileDirectory.isDirectory());
        File[] files = fileDirectory.listFiles();

        for (File file : files) {

            String name = file.getName();

            if (name.contains("【") && name.contains("】")) {
                int i = name.indexOf("【");
                String substringPre = name.substring(0,i);
                String substringSux = name.substring(name.indexOf("】")+1 );
                System.out.print(substringPre);
                System.out.println(substringSux);

                String newFileName = substringPre + substringSux;

                file.renameTo(new File(path + newFileName));

//                file.renameTo(new File(""));
            }
        }
    }
}
