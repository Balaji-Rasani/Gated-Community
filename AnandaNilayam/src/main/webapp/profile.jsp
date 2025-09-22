<%@ page import="com.User" %>
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
    <title>Your Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff; /* Light blue background */
            margin: 0;
            padding: 0;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-top: 20px;
        }
        table {
            border-collapse: collapse;
            width: 50%;
            margin: 20px auto;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th {
            background-color: #4da3ff; /* Blue header */
            color: white;
            padding: 10px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        td.field-name {
            font-weight: bold;
            background-color: #f2f2f2;
        }
        tr:hover td {
            background-color: #f9f9f9;
        }
        .links {
            text-align: center;
            margin: 20px;
        }
        .links a {
            text-decoration: none;
            color: #4da3ff;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>Your Profile</h2>
    <table>
        <tr>
            <th>Field</th>
            <th>Value</th>
        </tr>
        <tr>
            <td class="field-name">Username</td>
            <td><%= user.getUsername() %></td>
        </tr>
        <tr>
            <td class="field-name">Full Name</td>
            <td><%= user.getFullName() %></td>
        </tr>
        <tr>
            <td class="field-name">Role</td>
            <td><%= user.getRole() %></td>
        </tr>
    </table>

    <div class="links">
        <a href="residentdashboard.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
