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

    String complaintIdStr = request.getParameter("id");
    if (complaintIdStr == null) {
        response.sendRedirect("viewComplaints.jsp?error=Missing+complaint+ID");
        return;
    }

    int complaintId = 0;
    try {
        complaintId = Integer.parseInt(complaintIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("viewComplaints.jsp?error=Invalid+complaint+ID");
        return;
    }

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "DELETE FROM " + Constants.COMPLAINTS_TABLE + " WHERE complaint_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                response.sendRedirect("viewComplaints.jsp?success=Complaint+deleted+successfully");
            } else {
                response.sendRedirect("viewComplaints.jsp?error=Complaint+not+found");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("viewComplaints.jsp?error=Error+deleting+complaint");
    }
%>
