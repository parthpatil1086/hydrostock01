package com.hydrostock.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * HydroStock Database Connection Manager
 * Pre-configured for XAMPP MySQL (Port 3306, user 'root', blank password)
 */
public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/hydrostock_db?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Default empty password for XAMPP

    static {
        try {
            // Modern MySQL Connector Driver class
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try {
                // Fallback for older connector versions
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                System.err.println("Critical: MySQL JDBC Driver not found in classpath!");
                ex.printStackTrace();
            }
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
