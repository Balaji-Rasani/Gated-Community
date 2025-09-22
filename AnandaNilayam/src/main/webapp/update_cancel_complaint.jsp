<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.Complaint" %>
<%@ page import="com.User" %>
<%@ page import="com.dao.ComplaintDAO" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"resident".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("ViewComplaintStatusServlet");
        return;
    }

    ComplaintDAO complaintDAO = new ComplaintDAO();
    Complaint complaint = null;
    try {
        complaint = complaintDAO.getComplaintById(id);
        if (complaint == null || !complaint.getResidentName().equals(user.getUsername())) {
            response.sendRedirect("ViewComplaintStatusServlet");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ViewComplaintStatusServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Complaint</title>
</head>
<body>
<h2>Update Complaint</h2>
<form method="post" action="UpdateCancelComplaintServlet">
    <input type="hidden" name="id" value="<%= complaint.getId() %>">
    <p>
        <label>Complaint Text:</label><br>
        <textarea name="complaintText" rows="5" cols="50"><%= complaint.getComplaintText() %></textarea>
    </p>
    <p>
        <button type="submit" name="action" value="update">Update</button>
        <button type="submit" name="action" value="cancel" onclick="return confirm('Are you sure to cancel?');">Cancel Complaint</button>
    </p>
</form>
<p><a href="ViewComplaintStatusServlet">Back to My Complaints</a></p>
</body>
</html>
