package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.util.Constants;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateComplaint")
public class UpdateComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        com.User user = (session != null) ? (com.User) session.getAttribute("user") : null;

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        String complaintIdStr = request.getParameter("complaint_id");
        String status = request.getParameter("status");

        if (complaintIdStr == null || status == null || status.trim().isEmpty()) {
            response.sendRedirect("viewComplaints.jsp?error=Missing+parameters");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE " + Constants.COMPLAINTS_TABLE + " SET status = ? WHERE complaint_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, status);
                    ps.setInt(2, complaintId);

                    int updated = ps.executeUpdate();
                    if (updated > 0) {
                        response.sendRedirect("viewComplaints.jsp?success=Complaint+updated+successfully");
                    } else {
                        response.sendRedirect("viewComplaints.jsp?error=Complaint+not+found");
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("viewComplaints.jsp?error=Invalid+complaint+ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewComplaints.jsp?error=Error+updating+complaint");
        }
    }
}
