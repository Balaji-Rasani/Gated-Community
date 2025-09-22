package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.util.Constants;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM " + Constants.RESIDENTS_TABLE + " WHERE username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("resident", rs);
                        request.getRequestDispatcher("/profile.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/residentDashboard.jsp?error=notfound");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/residentDashboard.jsp?error=exception");
        }
    }
}
