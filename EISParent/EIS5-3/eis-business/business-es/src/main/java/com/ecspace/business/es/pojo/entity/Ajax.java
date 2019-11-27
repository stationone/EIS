package com.ecspace.business.es.pojo.entity;


/**
 * @Auther: menb
 * @Date: 2019/7/8
 * @Description: com.ecspace.pdm.pojo
 * @version:
 */
public class Ajax {
    private String message;
    private boolean success;

    public Ajax(String message, boolean success) {
        this.message = message;
        this.success = success;
    }

    public Ajax() {
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
