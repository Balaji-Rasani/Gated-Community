package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.User;
import com.util.Constants;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ResidentLoginServlet")
public class ResidentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM " + Constants.RESIDENTS_TABLE + " WHERE username = ? AND password = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, password);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        // Create User object and set its properties
                        User user = new User();
                        user.setUsername(username);
                        user.setFullName(rs.getString("full_name"));  // get full_name from DB
                        user.setRole("resident");  // set role manually

                        // Store User object in session
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);

                        // Redirect to resident dashboard
                        response.sendRedirect(request.getContextPath() + "/residentdashboard.jsp");
                    } else {
                        // Invalid credentials
                        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp?error=invalid");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp?error=Exception");
        }
    }
}
