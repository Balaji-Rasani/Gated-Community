<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*,com.util.DBConnection,com.util.Constants" %>

<%
    // Check if admin is logged in
    com.User user = (com.User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
        return;
    }

    // Get complaint ID from request parameter
    String complaintIdStr = request.getParameter("id");
    if (complaintIdStr == null) {
        response.sendRedirect("viewComplaints.jsp");
        return;
    }
    int complaintId = Integer.parseInt(complaintIdStr);

    String complaintText = "";
    String status = "";

    // Load complaint details from DB
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT complaint_text, status FROM " + Constants.COMPLAINTS_TABLE + " WHERE complaint_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    complaintText = rs.getString("complaint_text");
                    status = rs.getString("status");
                } else {
                    response.sendRedirect("viewComplaints.jsp");
                    return;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Edit Complaint - Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f8fb; padding: 30px; }
        form { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); max-width: 600px; margin: auto;}
        label { display: block; margin: 15px 0 5px; font-weight: bold; }
        textarea, select { width: 100%; padding: 10px; font-size: 16px; border-radius: 6px; border: 1px solid #ccc; }
        button { margin-top: 20px; background-color: #0072ff; color: white; padding: 12px 20px; border: none; border-radius: 8px; cursor: pointer; }
        button:hover { background-color: #005bb5; }
    </style>
</head>
<body>
    <h2>Edit Complaint #<%= complaintId %></h2>
    <form action="<%= request.getContextPath() %>/updateComplaint" method="post">
        <input type="hidden" name="complaint_id" value="<%= complaintId %>" />
        <label for="complaintText">Complaint Text:</label>
        <textarea id="complaintText" name="complaint_text" rows="5" readonly><%= complaintText %></textarea>

        <label for="status">Status:</label>
        <select id="status" name="status" required>
            <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
            <option value="In Progress" <%= "In Progress".equals(status) ? "selected" : "" %>>In Progress</option>
            <option value="Resolved" <%= "Resolved".equals(status) ? "selected" : "" %>>Resolved</option>
            <option value="Closed" <%= "Closed".equals(status) ? "selected" : "" %>>Closed</option>
        </select>

        <button type="submit">Update Complaint</button>
    </form>
</body>
</html>
