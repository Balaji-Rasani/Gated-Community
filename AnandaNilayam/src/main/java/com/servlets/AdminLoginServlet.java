package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.util.Constants;
import com.util.DBConnection;
import com.User;  // Make sure this import matches your User class package

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM " + Constants.ADMIN_TABLE + " WHERE username=? AND password=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Login success
                        HttpSession session = request.getSession();

                        // Create User object and set attributes
                        User user = new User();
                        user.setUsername(username);
                        user.setFullName(rs.getString("name"));
                        user.setRole("admin");

                        // Store user object in session
                        session.setAttribute("user", user);

                        // Redirect to admin dashboard
                        response.sendRedirect(request.getContextPath() + "/admindashboard.jsp");
                        return;
                    }
                }
            }

            // Login failed
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp?error=invalid");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp?error=server");
        }
    }
}
