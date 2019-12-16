package com.ecspace.test;

import org.junit.Test;

/**
 * @author zhangch
 * @date 2019/12/13 0013 下午 12:03
 */
public class FileTempTest {

    @Test
    public void stringTest(){
        String s = "20191213测试文件.doc";
        String[] split = s.split("\\.");
        System.out.println(split);
    }
}
