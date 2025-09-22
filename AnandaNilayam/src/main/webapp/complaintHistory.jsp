<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.User, com.util.DBConnection, com.util.Constants" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"resident".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complaint History</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #eef4ff;
            padding: 20px 0;
        }
        h2 {
            text-align: center;
            color: #34495e;
            font-weight: 900;
            margin-bottom: 30px;
        }
        table {
            border-collapse: collapse;
            width: 90%;
            margin: 0 auto 40px auto;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px 15px;
            font-weight: bold; /* Bold text */
            color: #2c3e50;
        }
        th {
            background-color: #2980b9;
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            font-size: 0.95rem;
        }
        tr:nth-child(even) {
            background-color: #f6f9ff;
        }
        tr:hover {
            background-color: #d6e4ff;
        }
        /* Status colors */
        .status-pending {
            color: #d35400;
            font-weight: 700;
            background-color: #fcefcf;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }
        .status-resolved {
            color: #27ae60;
            font-weight: 700;
            background-color: #d4f0dc;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }
        .status-rejected {
            color: #c0392b;
            font-weight: 700;
            background-color: #f9d6d5;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }
        .status-other {
            color: #7f8c8d;
            font-weight: 700;
            background-color: #e1e6e8;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }
        a {
            display: inline-block;
            margin-left: 20px;
            font-weight: 700;
            color: #2980b9;
            text-decoration: none;
            font-size: 1rem;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #1c5980;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h2>Your Complaints History</h2>
    <table>
        <tr>
            <th>ID</th><th>Resident Name</th><th>Complaint Text</th><th>Status</th><th>Date Submitted</th>
        </tr>
        <%
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                    "SELECT * FROM " + Constants.COMPLAINTS_TABLE + " WHERE resident_name = ? ORDER BY complaint_id DESC")) {
                
                ps.setString(1, user.getUsername()); // resident_name = username
                
                try (ResultSet rs = ps.executeQuery()) {
                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        String status = rs.getString("status");
                        String statusClass = "status-other";
                        if ("pending".equalsIgnoreCase(status)) {
                            statusClass = "status-pending";
                        } else if ("resolved".equalsIgnoreCase(status)) {
                            statusClass = "status-resolved";
                        } else if ("rejected".equalsIgnoreCase(status)) {
                            statusClass = "status-rejected";
                        }
        %>
            <tr>
                <td><%= rs.getInt("complaint_id") %></td>
                <td><%= rs.getString("resident_name") %></td>
                <td><%= rs.getString("complaint_text") %></td>
                <td><span class="<%= statusClass %>"><%= status.substring(0,1).toUpperCase() + status.substring(1).toLowerCase() %></span></td>
                <td><%= rs.getTimestamp("date_submitted") %></td>
            </tr>
        <%
                    }
                    if (!hasData) {
        %>
            <tr><td colspan="5" style="text-align:center; font-weight:bold; color:#7f8c8d;">No complaints found.</td></tr>
        <%
                    }
                }
            } catch(Exception e) {
        %>
            <tr><td colspan="5" style="color:red; text-align:center; font-weight:bold;">Error loading complaints: <%= e.getMessage() %></td></tr>
        <%
                e.printStackTrace();
            }
        %>
    </table>
    <a href="residentdashboard.jsp">← Back to Dashboard</a>
</body>
</html>
