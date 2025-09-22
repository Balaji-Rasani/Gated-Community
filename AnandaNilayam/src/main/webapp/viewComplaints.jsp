<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*,com.util.DBConnection,com.util.Constants,com.User" %>

<%
    // Check admin session and role
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Manage Complaints - Admin Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f8fb;
            margin: 0; padding: 30px;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border: 2px solid #000000;
        }
        th, td {
            padding: 14px 16px;
            border: 1px solid #000000;
            text-align: left;
        }
        th {
            background: linear-gradient(90deg, #0072ff, #00c6ff);
            color: white;
            text-transform: uppercase;
        }
        tr:nth-child(even) {
            background-color: #f9fbfd;
        }
        tr:hover {
            background-color: #e0f0ff;
            cursor: pointer;
        }
        a {
            color: #0072ff;
            text-decoration: none;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
        .message {
            margin-bottom: 20px;
            color: green;
        }
        .error {
            color: red;
        }
        /* Status styling */
        .status {
            padding: 6px 10px;
            border-radius: 12px;
            font-weight: bold;
            display: inline-block;
            border: 2px solid transparent;
            text-transform: capitalize;
        }
        .status-pending {
            color: #d32f2f;
            border-color: #d32f2f;
            background-color: #fdecea;
        }
        .status-resolved {
            color: #388e3c;
            border-color: #388e3c;
            background-color: #e8f5e9;
        }
        .status-inprogress {
            color: #f9a825;
            border-color: #f9a825;
            background-color: #fff8e1;
        }
        .status-assigned {
            color: #1976d2;
            border-color: #1976d2;
            background-color: #e3f2fd;
        }
        .status-cancelled {
            color: #6d4c41;
            border-color: #6d4c41;
            background-color: #efebe9;
        }
    </style>
</head>
<body>
    <h1>Manage Complaints</h1>

    <%
        String successMsg = request.getParameter("success");
        String errorMsg = request.getParameter("error");

        if (successMsg != null) {
    %>
        <div class="message"><%= successMsg %></div>
    <% 
        }
        if (errorMsg != null) {
    %>
        <div class="message error"><%= errorMsg %></div>
    <%
        }
    %>

    <table>
        <tr>
            <th>ID</th>
            <th>Resident Name</th>
            <th>Complaint</th>
            <th>Date Submitted</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <%
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT complaint_id, resident_name, complaint_text, date_submitted, status FROM " 
                             + Constants.COMPLAINTS_TABLE + " ORDER BY date_submitted DESC";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {

                    boolean hasComplaints = false;
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy");

                    while (rs.next()) {
                        hasComplaints = true;
                        String status = rs.getString("status");
                        String statusClass = "";

                        if ("pending".equalsIgnoreCase(status)) {
                            statusClass = "status-pending";
                        } else if ("resolved".equalsIgnoreCase(status)) {
                            statusClass = "status-resolved";
                        } else if ("inprogress".equalsIgnoreCase(status) || "in progress".equalsIgnoreCase(status)) {
                            statusClass = "status-inprogress";
                            status = "In Progress"; // Normalize display text
                        } else if ("assigned".equalsIgnoreCase(status)) {
                            statusClass = "status-assigned";
                            status = "Assigned";
                        } else if ("cancelled".equalsIgnoreCase(status)) {
                            statusClass = "status-cancelled";
                            status = "Cancelled";
                        } else {
                            status = status.substring(0,1).toUpperCase() + status.substring(1).toLowerCase();
                        }
        %>
                        <tr>
                            <td><%= rs.getInt("complaint_id") %></td>
                            <td><%= rs.getString("resident_name") %></td>
                            <td><%= rs.getString("complaint_text") %></td>
                            <td><%= sdf.format(rs.getDate("date_submitted")) %></td>
                            <td>
                                <span class="status <%= statusClass %>"><%= status %></span>
                            </td>
                            <td>
                                <a href="editComplaint.jsp?id=<%= rs.getInt("complaint_id") %>">Update</a> | 
                                <a href="deleteComplaint?id=<%= rs.getInt("complaint_id") %>" onclick="return confirm('Delete this complaint?')">Delete</a>
                            </td>
                        </tr>
        <%
                    }
                    if (!hasComplaints) {
        %>
                        <tr>
                            <td colspan="6" style="text-align:center; font-style:italic;">No complaints found.</td>
                        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='6' style='color:red;'>Error loading complaints.</td></tr>");
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
