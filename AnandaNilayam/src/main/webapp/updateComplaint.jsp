<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.util.DBConnection,com.util.Constants" %>
<%@ page session="true" %>

<%
    // Check admin session and role
    com.User user = (com.User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
        return;
    }

    String complaintIdStr = request.getParameter("complaint_id");
    String newStatus = request.getParameter("status");

    if (complaintIdStr == null || newStatus == null || newStatus.trim().isEmpty()) {
        response.sendRedirect("viewComplaints.jsp?error=missing_data");
        return;
    }

    int complaintId = Integer.parseInt(complaintIdStr);

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "UPDATE " + Constants.COMPLAINTS_TABLE + " SET status = ? WHERE complaint_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, complaintId);
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("viewComplaints.jsp?success=Complaint+updated");
            } else {
                response.sendRedirect("viewComplaints.jsp?error=Complaint+not+found");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("viewComplaints.jsp?error=Error+updating+complaint");
    }
%>
