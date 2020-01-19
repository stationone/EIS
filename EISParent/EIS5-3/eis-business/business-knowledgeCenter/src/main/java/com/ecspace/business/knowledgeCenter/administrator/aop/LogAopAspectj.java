package com.ecspace.business.knowledgeCenter.administrator.aop;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Log;
import com.ecspace.business.knowledgeCenter.administrator.service.LogService;
import com.ecspace.business.knowledgeCenter.administrator.util.IPUtil;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.aspectj.lang.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;

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
    private LogService logService;//日志service

    @Autowired
    private HttpServletRequest httpServletRequest;


    @Around("controllerAspect()")
    public Object aroundAdvice(ProceedingJoinPoint proceedingJoinPoint) throws Exception {

        // 1.方法执行前的处理，相当于前置通知
        // 获取方法签名
        MethodSignature methodSignature = (MethodSignature) proceedingJoinPoint.getSignature();
        // 获取方法
        Method method = methodSignature.getMethod();
        Parameter[] parameters = method.getParameters();//参数名数组
        Object[] args = proceedingJoinPoint.getArgs();//参数值数组

        //获取参数名对应数组下标
//        int paramIndex = -1;
//        if (parameters != null) {
//            for (Parameter parameter : parameters) {
//                RequestParam annotation = parameter.getAnnotation(RequestParam.class);
//                if (annotation != null) {
//                    System.out.println(annotation.name());
//                    System.out.println(annotation.value());
//
//                    System.out.println(parameter.getName());
//                }
//            }
//            paramIndex = ArrayUtils.indexOf(parameters, "arg0");
//        }
        String arg = null;//参数值
//        if (paramIndex != -1) {
//            //参数值与参数名下标一致
//            arg = (String) args[paramIndex];//获取参数值
//        }
        for (Parameter parameter : parameters) {
            String name = parameter.getName();
            System.out.println(name);//参数名
        }
        for (Object o : args) {
            System.out.println(o);//参数值
        }
        if ("fileList".equals(method.getName()))
            //执行的是全文检索 , 获取检索词
            arg = args[0].toString();

        // 获取方法上面的注解
        LogAnno logAnno = method.getAnnotation(LogAnno.class);
        // 获取操作描述的属性值
        String operateType = logAnno.operateType();//(全文检索)
        // 创建一个日志对象(准备记录日志)

        Log log = new Log();
        log.setId(TNOGenerator.generateId());
        log.setIp(IPUtil.getIpAddress(httpServletRequest));
        Date date = new Date();
        log.setOperationDate(date);
        log.setOperationType(operateType);
        log.setOperator("普通用户");
        log.setSearch(arg);
        log.setDateStr(new SimpleDateFormat("yyyy-MM-dd").format(date));


        Object result = null;
        try {
            //让代理方法执行
            result = proceedingJoinPoint.proceed();
            // 2.相当于后置通知(方法成功执行之后走这里)
            log.setOperationResult("执行成功");
        } catch (Exception e) {
            // 3.相当于异常通知部分
            log.setOperationResult("执行失败");// 设置操作结果

        } catch (Throwable throwable) {
            throwable.printStackTrace();
            log.setOperationResult(throwable.getMessage());

        } finally {
            // 4.相当于最终通知
            logService.save(log);//入库
            return result;
        }
    }


    //Controller层切点
    //第一个*代表所有的返回值类型
    //第二个*代表所有的类
    //第三个*代表类所有方法
    //最后一个..代表所有的参数。
    @Pointcut("execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.save*(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.delete*(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.*load(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.fileForm(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.fileTemp(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.create*(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.insert*(..))||" +
            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.*.update*(..))||" +

            "execution (* com.ecspace.business.knowledgeCenter.administrator.controller.FileSearchController.fileList(..))")
    public void controllerAspect() {
    }
}
