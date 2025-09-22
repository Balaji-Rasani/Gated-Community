<%@ page import="com.User" %>
<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"resident".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
        return;
    }

    Boolean showLoginSuccess = (Boolean) session.getAttribute("showLoginSuccess");
    if (showLoginSuccess == null) {
        showLoginSuccess = false;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Resident Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);
            margin: 0; padding: 0; min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .dashboard-container {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            border: 6px solid red; /* Thick red border */
            box-shadow: 0 12px 35px rgba(0,0,0,0.25);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }

        h2 {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .gradient-text {
            background: linear-gradient(90deg, #ff5722, #ff9800, #4caf50, #2196f3, #9c27b0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        ul li {
            margin: 10px 0;
        }
        ul li a {
            text-decoration: none;
            color: #fff;
            padding: 12px;
            border-radius: 8px;
            display: block;
            width: 100%;
            font-weight: 600;
            font-size: 15px;
            transition: transform 0.2s ease, opacity 0.3s ease;
        }
        ul li a:hover {
            transform: scale(1.05);
            opacity: 0.9;
        }

        /* Colorful button styles */
        .btn-submit { background: #007bff; }      /* Blue */
        .btn-track { background: #28a745; }       /* Green */
        .btn-update { background: #ff9800; }      /* Orange */
        .btn-history { background: #9c27b0; }     /* Purple */
        .btn-profile { background: #17a2b8; }     /* Teal */
        .btn-chat { background: #673ab7; }        /* Indigo */
        .logout-link { background: #ff4b5c; }     /* Red */
        .logout-link:hover { background: #d43546 !important; }
    </style>

    <script>
        <% if (showLoginSuccess) { %>
            alert("Login Successful! 🎉");
        <% } %>
    </script>
</head>
<body>
    <div class="dashboard-container">
        <h2>
            <span class="gradient-text">Welcome, <%= user.getUsername() %>!</span> 👋
        </h2>

        <ul>
            <li><a href="submitComplaint.jsp" class="btn-submit">📝 Submit Complaint</a></li>
            <li><a href="trackComplaint.jsp" class="btn-track">📍 Track Complaint</a></li>
            <li><a href="update_cancel_complaint.jsp" class="btn-update">✏️ View / Update / Cancel Complaint</a></li>
            <li><a href="complaintHistory.jsp" class="btn-history">📜 Complaint History</a></li>
            <li><a href="profile.jsp" class="btn-profile">👤 View Profile</a></li>
            <li><a href="chatWithAdmin.jsp" class="btn-chat">💬 Chat with Admin</a></li>
            <li><a class="logout-link" href="<%= request.getContextPath() + "/logout.jsp" %>">🚪 Logout</a></li>
        </ul>
    </div>
</body>
</html>
<%
    if (showLoginSuccess) {
        session.setAttribute("showLoginSuccess", false);  // reset flag so alert shows only once
    }
%>
