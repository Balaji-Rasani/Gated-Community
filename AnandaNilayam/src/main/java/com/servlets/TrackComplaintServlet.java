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

@WebServlet("/TrackComplaintServlet")
public class TrackComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session & user
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        // Validate complaint ID
        String complaintIdStr = request.getParameter("complaintId");
        if (complaintIdStr == null || complaintIdStr.isBlank()) {
            request.setAttribute("errorMessage", "Complaint ID is required.");
            request.getRequestDispatcher("/trackComplaint.jsp").forward(request, response);
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(complaintIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid complaint ID format.");
            request.getRequestDispatcher("/trackComplaint.jsp").forward(request, response);
            return;
        }

        // Fetch from DB
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT complaint_id, complaint_text, status, created_at " +
                         "FROM " + Constants.COMPLAINTS_TABLE + 
                         " WHERE complaint_id = ? AND resident_name = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, complaintId);
                pstmt.setString(2, user.getUsername());

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        // Pass data to JSP
                        request.setAttribute("complaintId", rs.getInt("complaint_id"));
                        request.setAttribute("complaintText", rs.getString("complaint_text"));
                        request.setAttribute("status", rs.getString("status"));
                        request.setAttribute("createdAt", rs.getString("created_at"));

                        request.getRequestDispatcher("/trackComplaintResult.jsp").forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "Complaint not found.");
                        request.getRequestDispatcher("/trackComplaint.jsp").forward(request, response);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log full details in server logs
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/trackComplaint.jsp").forward(request, response);
        }
    }
}
