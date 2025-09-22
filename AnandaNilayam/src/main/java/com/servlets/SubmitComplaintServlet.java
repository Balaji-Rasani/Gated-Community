package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.User;
import com.util.Constants;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SubmitComplaintServlet")
public class SubmitComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String complaintText = request.getParameter("complaint_text");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO complaints (resident_name, complaint_text, status) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, user.getUsername()); // resident_name
                pstmt.setString(2, complaintText);      // complaint_text
                pstmt.setString(3, "Pending");           // status default to Pending

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect(request.getContextPath() + "/complaintSuccess.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/submitComplaint.jsp?error=fail");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/submitComplaint.jsp?error=Exception");
        }
    }
}
