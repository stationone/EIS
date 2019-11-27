package com.ecspace.business.employeeCenter.entity;

public class User {
    private String tNO;

    private String userId;

    private String userName;

    private String userPassword;


    public User() {
    }

    public User(String tNO, String userId, String userName, String userPassword) {
        this.tNO = tNO;
        this.userId = userId;
        this.userName = userName;
        this.userPassword = userPassword;
    }

    public String gettNO() {
        return tNO;
    }

    public void settNO(String tNO) {
        this.tNO = tNO;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    @Override
    public String toString() {
        return "User{" +
                "tNO='" + tNO + '\'' +
                ", userId='" + userId + '\'' +
                ", userName='" + userName + '\'' +
                ", userPassword='" + userPassword + '\'' +
                '}';
    }
}
