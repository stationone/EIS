package com.ecspace.business.resourceCenter.user.util;

public class ResUtil {

    /**
     *  生成编号
     * @param numberStart 编号开始值
     * @param prefix 编号前缀
     * @param postfixLength 编号后缀长度
     * @return
     */
    public static String generateId(String numberStart, String prefix, String postfixLength ){
        StringBuilder newId = new StringBuilder(numberStart);
        int postfixLengthI = Integer.parseInt(postfixLength);
        if (postfixLengthI < 0) {
            postfixLengthI = 4;
        }
        int newIdStart = postfixLengthI - newId.length();
        for (int newIdNumber = 0; newIdNumber < newIdStart; newIdNumber++) {
            newId.insert(0, "0");
        }
        //编号创建完成
        return newId.insert(0,prefix).toString();
    }

    public static void main(String[] args) {

    }
}
