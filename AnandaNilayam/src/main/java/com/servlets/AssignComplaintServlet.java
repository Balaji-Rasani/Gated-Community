package com.servlets;

import com.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AssignComplaintServlet")
public class AssignComplaintServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String complaintId = request.getParameter("complaintId");
        String staffId = request.getParameter("staffId");
        boolean success = false;

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Insert assignment
            String sql1 = "INSERT INTO complaint_assignments (complaint_id, staff_id) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setInt(1, Integer.parseInt(complaintId));
                ps.setInt(2, Integer.parseInt(staffId));
                ps.executeUpdate();
            }

            // 2. Update complaint status
            String sql2 = "UPDATE complaints SET status = 'Assigned' WHERE complaint_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setInt(1, Integer.parseInt(complaintId));
                ps.executeUpdate();
            }

            // 3. Update staff availability
            String sql3 = "UPDATE staff SET availability = 'Busy' WHERE staff_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql3)) {
                ps.setInt(1, Integer.parseInt(staffId));
                ps.executeUpdate();
            }

            success = true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/AssignComplaints.jsp?success=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/AssignComplaints.jsp?error=1");
        }
    }
}
