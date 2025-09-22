<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="com.User" %>
<%
    // Get current user before invalidating session
    User user = (User) session.getAttribute("user");

    String redirectPage = "residentlogin.jsp"; // Default redirect

    if (user != null) {
        if ("admin".equalsIgnoreCase(user.getRole())) {
            redirectPage = "adminlogin.jsp";
        } else if ("resident".equalsIgnoreCase(user.getRole())) {
            redirectPage = "residentlogin.jsp";
        }
    }

    // Invalidate session
    session.invalidate();

    // Redirect to the appropriate login page
    response.sendRedirect(request.getContextPath() + "/" + redirectPage);
%>
