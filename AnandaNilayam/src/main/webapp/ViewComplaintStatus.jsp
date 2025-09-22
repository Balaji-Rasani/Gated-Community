<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.Complaint" %>
<%@ page import="com.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"resident".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Complaints</title>
<style>
    body { font-family: Arial, sans-serif; background: #f4f8fb; padding: 20px; }
    table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1);}
    th, td { padding: 12px; border: 1px solid #ccc; text-align: left; font-weight: bold; }
    th { background-color: #007bff; color: white; }
    a { color: #007bff; text-decoration: none; font-weight: normal; }
    a:hover { text-decoration: underline; }
    button {
        background: none;
        border: none;
        color: #007bff;
        cursor: pointer;
        padding: 0;
        font-size: 1em;
        font-family: inherit;
        font-weight: normal;
    }
    button:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
<h2>📝 My Complaints</h2>

<%
    if (request.getAttribute("error") != null) {
%>
<p style="color: red; font-weight: bold;"><%= request.getAttribute("error") %></p>
<%
    }
%>

<table>
    <tr>
        <th>ID</th>
        <th>Complaint</th>
        <th>Status</th>
        <th>Created At</th>
        <th>Actions</th>
    </tr>
    <%
        if (complaints != null && !complaints.isEmpty()) {
            for (Complaint c : complaints) {
                String rowColor = "";
                String statusColor = "";

                switch(c.getStatus().toLowerCase()) {
                    case "pending":
                        rowColor = "#fff8e1"; // light yellow
                        statusColor = "#ff9800"; // orange
                        break;
                    case "in progress":
                        rowColor = "#e3f2fd"; // light blue
                        statusColor = "#2196f3"; // blue
                        break;
                    case "resolved":
                        rowColor = "#e8f5e9"; // light green
                        statusColor = "#4caf50"; // green
                        break;
                    case "cancelled":
                        rowColor = "#ffebee"; // light red
                        statusColor = "#f44336"; // red
                        break;
                    default:
                        rowColor = "#ffffff"; // white default
                        statusColor = "#000000"; // black
                }
    %>
    <tr style="background-color: <%= rowColor %>;">
        <td><%= c.getId() %></td>
        <td><%= c.getComplaintText() %></td>
        <td style="color: <%= statusColor %>;"><%= c.getStatus() %></td>
        <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(c.getDateSubmitted()) %></td>
        <td>
            <% if ("Pending".equalsIgnoreCase(c.getStatus())) { %>
                <a href="update_cancel_complaint.jsp?id=<%= c.getId() %>">Update</a> |
                <form method="post" action="UpdateCancelComplaintServlet" style="display:inline;"
                      onsubmit="return confirm('Are you sure you want to cancel this complaint?');">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id" value="<%= c.getId() %>">
                    <button type="submit">Cancel</button>
                </form>
            <% } else { %>
                No Actions
            <% } %>
        </td>
    </tr>
    <%
            }
        } else {
    %>
    <tr><td colspan="5" style="text-align:center; font-weight: bold;">No complaints found.</td></tr>
    <% } %>
</table>
</body>
</html>
