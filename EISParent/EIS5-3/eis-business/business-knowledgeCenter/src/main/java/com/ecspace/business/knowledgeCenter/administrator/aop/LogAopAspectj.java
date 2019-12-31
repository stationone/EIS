package com.ecspace.business.knowledgeCenter.administrator.aop;

import com.ecspace.business.knowledgeCenter.administrator.pojo.SearchLog;
import com.ecspace.business.knowledgeCenter.administrator.service.SearchLogService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.lang3.ArrayUtils;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.sql.SQLException;
import java.util.Date;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

/**
 * AOP实现日志
 *
 * @author zhangch
 * @date 2019/12/31 0031 上午 11:25
 */
@Component
@Aspect
public class LogAopAspectj {
    @Autowired
    private SearchLogService searchLogService;//日志service

    @Autowired
    private HttpServletRequest httpServletRequest;

    @Around("@annotation(com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno)")
    public Object aroundAdvice(ProceedingJoinPoint proceedingJoinPoint) throws Exception {

        // 1.方法执行前的处理，相当于前置通知
        // 获取方法签名
        MethodSignature methodSignature = (MethodSignature) proceedingJoinPoint.getSignature();
        // 获取方法
        Method method = methodSignature.getMethod();
        Parameter[] parameters = method.getParameters();//参数名数组
        Object[] args = proceedingJoinPoint.getArgs();//参数值数组
        //获取参数名对应数组下标
        int paramIndex = ArrayUtils.indexOf(parameters,"search");
        if (paramIndex != -1) {
            //参数值与参数名下标一致
        }
        for (Parameter parameter : parameters) {
            String name = parameter.getName();
            System.out.println(name);//参数名
        }
        // 获取方法上面的注解
        LogAnno logAnno = method.getAnnotation(LogAnno.class);
        // 获取操作描述的属性值
//        String operateType = logAnno.operateType();//(全文检索)
        // 创建一个日志对象(准备记录日志)
        SearchLog searchLog = new SearchLog();
        searchLog.setId(TNOGenerator.generateId());//日志id
        searchLog.setLevel(1);//日志级别
        searchLog.setMethod(method.getName());//设置方法名

        searchLog.setParam("");//方法参数名
        searchLog.setRemoteHost(getIpAddress(httpServletRequest));//获取ip地址
        searchLog.setRequestUrl(httpServletRequest.getRequestURL().toString());//请求路径
        searchLog.setSpent(null);
        searchLog.setUserId("系统管理员");//用户名和用户真实姓名
        searchLog.setUserName("蜡笔小新");


        Object result = null;
        try {
            //让代理方法执行
            result = proceedingJoinPoint.proceed();
            // 2.相当于后置通知(方法成功执行之后走这里)
            searchLog.setResult("执行成功");
        } catch (Exception e) {
            // 3.相当于异常通知部分
            searchLog.setResult("执行失败");// 设置操作结果

        } catch (Throwable throwable) {
            throwable.printStackTrace();
            searchLog.setResult(throwable.getMessage());
        } finally {
            // 4.相当于最终通知
            searchLog.setCreationTime(new Date());//创建时间

            searchLogService.insert(searchLog);//入库
        }
        return result;
    }

    /**
     * 获取IP地址的方法
     * @param request   传一个request对象下来
     * @return
     */
    public static String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
