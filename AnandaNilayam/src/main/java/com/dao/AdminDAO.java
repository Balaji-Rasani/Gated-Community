package com.dao;

import com.util.Constants;
import com.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {

    // Register a new admin
    public boolean registerAdmin(String name, String email, String username, String password) throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            
            // Check if username already exists
            String checkSql = "SELECT id FROM " + Constants.ADMIN_TABLE + " WHERE username = ? OR email = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, username);
                checkPs.setString(2, email);

                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        return false; // Duplicate found
                    }
                }
            }

            // Insert new admin
            String sql = "INSERT INTO " + Constants.ADMIN_TABLE + " (name, email, username, password) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, username);
                ps.setString(4, password); // Hash before saving in production
                return ps.executeUpdate() > 0;
            }
        }
    }
}
