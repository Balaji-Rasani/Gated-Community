package com.dao;

import com.User;
import com.util.Constants;
import com.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    // Validate resident login
    public User validateUser(String username, String password) throws Exception {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM " + Constants.RESIDENTS_TABLE + " WHERE username=? AND password=?"
             )) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                        rs.getString("username"),
                        rs.getString("password")
                    );
                    user.setId(rs.getInt("id"));
                    return user;
                }
            }
        }
        return null;
    }

    // Register a new resident
    public boolean registerUser(String username, String password, String flatNo, String name) throws Exception {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO " + Constants.RESIDENTS_TABLE + " (name, username, password, flat_no) VALUES (?, ?, ?, ?)"
             )) {

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, password); // Consider hashing before saving
            ps.setString(4, flatNo);

            return ps.executeUpdate() > 0;
        }
    }
}
