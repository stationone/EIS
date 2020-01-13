package com.ecspace.business.knowledgeCenter.administrator.aop;

import java.lang.annotation.*;

/**
 * 日志自定义注解
 * @author zhangch
 * @date 2020/1/2 0002 下午 14:40
 */
@Target({ElementType.PARAMETER, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface LogAnno {
    String operateType() default "";//要执行的操作类型 , 比如: 全文检索
}
