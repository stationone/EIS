package com.ecspace.business.knowledgeCenter.administrator.pojo.entity;

/**
 * 全局返回对象
 *
 * @author zhangch
 * @date 2019/11/11 0011 下午 17:55
 */
public class GlobalResult {
    private boolean success;//操作状态
    private int code;//操作代码
    private String message;//提示信息
    private Object data;

    public GlobalResult() {
    }

    public GlobalResult(boolean success, int code, String message) {
        this.success = success;
        this.code = code;
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public GlobalResult(boolean success, int code, String message, Object data) {
        this.success = success;
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
