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
<head><title>Track Complaint</title></head>
<body>
    <h2>Track Complaint</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>
    <% } %>

    <form action="TrackComplaintServlet" method="get">
        <label>Enter Complaint ID:</label><br>
        <input type="number" name="complaintId" required>
        <button type="submit">Track</button>
    </form>
    <a href="residentdashboard.jsp">Back to Dashboard</a>
</body>
</html>
