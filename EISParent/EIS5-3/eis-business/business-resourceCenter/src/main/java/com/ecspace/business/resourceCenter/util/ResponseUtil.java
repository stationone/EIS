package com.ecspace.business.resourceCenter.util;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 响应
 * @author tongy
 *
 */
public class ResponseUtil {
	public static void write(HttpServletResponse response, Object o) {
        //1、设置文件类型
        response.setContentType("text/html;charset=utf-8");
        //2、设置请求头
          response.setHeader("Access-Control-Allow-Origin","*");
//        response.addHeader("Access-Control-Allow-Origin", "*");
        //3、获取输出流
//            response.addHeader("Access-Control-Allow-Origin","http://127.0.0.1:8020");
        PrintWriter out = null;
        try {
            out = response.getWriter();
            //4、执行写入缓冲区
            out.println(o.toString());
            //5、刷新缓冲区
            out.flush();
            //6、关闭输出流
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
