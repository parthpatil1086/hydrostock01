package com.hydrostock.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;

    private int notificationId;
    private Integer userId;
    private String roleTarget;
    private String title;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {}

    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getRoleTarget() { return roleTarget; }
    public void setRoleTarget(String roleTarget) { this.roleTarget = roleTarget; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
