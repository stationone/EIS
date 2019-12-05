package com.ecspace.test;

import java.util.Date;
import java.util.Scanner;

/**
 * 求词频测试类
 *
 * @author zhangch
 * @date 2019/12/4 0004 下午 18:08
 */
public class WordCounts {
    static Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {

        String st = "附录:参考资料（把相关资料整理一下，写到附录中，有条件\n" +
                "的话可以把全文整理下来，避免链接失效）\n" +
                "ES 集群管理（集群规划、集群搭建、集群管理）\n";

        String M = "集群管理";
        long way1Start = System.nanoTime();
        way1(st, M);//速度快
        long way1End = System.nanoTime();
        way2(st, M);//速度慢
        long way2End = System.nanoTime();
        System.out.println(way1Start);
        System.out.println(way1End);
        System.out.println(way2End);
        Long l = way1End - way1Start;
        int i1 = l.intValue();
        Long l2 = way2End - way1End;
        int i2 = l2.intValue();
        int i = i2 - i1;
        System.out.println(i);
    }

    /**
     * 方法一：使用indexOf和subString方法，循环判断并截取
     */
    public static void way1(String st, String M) {
        int count = 0;
        while (st.contains(M)) {
            st = st.substring(st.indexOf(M) + M.length());
            count++;
        }
        System.out.println("指定字符串在原字符串中出现：" + count + "次");
    }

    /**
     * 方法二：使用replace方法将字符串替换为空，然后求长度
     */
    public static void way2(String st, String M) {
        int count = (st.length() - st.replace(M, "").length()) / M.length();
        System.out.println("指定字符串在原字符串中出现：" + count + "次");
    }

}

