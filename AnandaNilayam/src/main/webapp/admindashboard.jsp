<%@ page import="com.User"%>
<%@ page session="true"%>
<%
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
<title>Admin Dashboard - Ananda Nilayam</title>
<style>
body {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f0f4f3; /* soft muted greenish-gray */
    margin: 0;
    padding: 0;
}

.header {
    background: linear-gradient(90deg, #00695c, #00897b); /* deep teal gradient */
    color: white;
    padding: 20px;
    text-align: center;
}

.container {
    padding: 30px;
    display: flex;             /* enable flexbox for side-by-side */
    gap: 20px;                 /* spacing between cards */
    flex-wrap: wrap;           /* wrap cards on smaller screens */
    justify-content: flex-start;
}

.welcome {
    font-size: 20px;
    margin-bottom: 20px;
    color: #004d40; /* deep green */
    width: 100%;               /* full width to stay on its own line */
}

.card {
    background: white;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 12px;
    border-left: 6px solid #ff9800; /* warm orange accent */
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    flex: 1 1 300px;           /* flexible width with base 300px */
    max-width: 350px;
    box-sizing: border-box;
}

.card h3 {
    color: #00695c; /* teal headings */
}

.card p {
    color: #555;
}

.card a {
    display: inline-block;
    padding: 10px 15px;
    background-color: #ff9800; /* orange button */
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: bold;
    transition: background 0.3s ease;
}

.card a:hover {
    background-color: #ef6c00; /* darker orange on hover */
}

.logout {
    text-align: right;
    margin-top: 20px;
    width: 100%;               /* full width to appear below cards */
}

.logout a {
    color: #d32f2f; /* rich red */
    text-decoration: none;
    font-weight: bold;
}

.logout a:hover {
    text-decoration: underline;
}
</style>
</head>
<body>
    <div class="header">
        <h1>Admin Dashboard</h1>
    </div>
    <div class="container">
        <div class="welcome">
            Welcome, <strong><%= user.getUsername() %></strong> (Role:
            <%= user.getRole() %>)
        </div>

        <div class="card">
            <h3>Manage Complaints</h3>
            <p>View, update, and resolve complaints submitted by residents.</p>
            <a href="viewComplaints.jsp">Go to Complaints</a>
        </div>

        <div class="card">
            <h3>Assign Complaints</h3>
            <p>Assign pending complaints to staff members for resolution.</p>
            <a href="AssignComplaints.jsp">Go to Assign Complaints</a>
        </div>

        <div class="card">
    <h3>Manage Chats</h3>
    <p>View and respond to chat messages from residents.</p>
    <!-- Instead of going directly to JSP, call the servlet -->
    <a href="AdminChatServlet?resident=john">Go to Chat</a>
</div>


        <div class="logout">
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
</body>
</html>
