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

@WebServlet("/deleteComplaint")
public class DeleteComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        com.User user = (com.User) (session != null ? session.getAttribute("user") : null);
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        String complaintIdStr = request.getParameter("id");
        if (complaintIdStr == null) {
            response.sendRedirect("viewComplaints.jsp?error=Missing+complaint+ID");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM " + Constants.COMPLAINTS_TABLE + " WHERE complaint_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, complaintId);
                    int deleted = ps.executeUpdate();
                    if (deleted > 0) {
                        response.sendRedirect("viewComplaints.jsp?success=Complaint+deleted+successfully");
                    } else {
                        response.sendRedirect("viewComplaints.jsp?error=Complaint+not+found");
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("viewComplaints.jsp?error=Invalid+complaint+ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewComplaints.jsp?error=Error+deleting+complaint");
        }
    }
}
