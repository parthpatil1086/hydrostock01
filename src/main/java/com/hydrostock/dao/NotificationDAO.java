package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.Notification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public List<Notification> getNotificationsForRole(String roleName, Integer userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT notification_id, user_id, role_target, title, message, is_read, created_at " +
                     "FROM notifications WHERE (role_target = ? OR role_target = 'ALL' OR user_id = ?) " +
                     "ORDER BY notification_id DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName);
            if (userId != null) {
                ps.setInt(2, userId);
            } else {
                ps.setInt(2, -1);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));
                    int uid = rs.getInt("user_id");
                    if (!rs.wasNull()) n.setUserId(uid);
                    n.setRoleTarget(rs.getString("role_target"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addNotification(String roleTarget, Integer userId, String title, String message) {
        String sql = "INSERT INTO notifications (role_target, user_id, title, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleTarget != null ? roleTarget : "ALL");
            if (userId != null && userId > 0) {
                ps.setInt(2, userId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, title);
            ps.setString(4, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
