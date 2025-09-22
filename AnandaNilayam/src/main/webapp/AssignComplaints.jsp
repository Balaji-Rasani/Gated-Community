<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page import="com.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("adminlogin.jsp");
        return;
    }

    List<Map<String, String>> complaints = new ArrayList<>();
    List<Map<String, String>> staffList = new ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {
        // Get pending complaints
        String sql1 = "SELECT complaint_id, resident_name, complaint_text, flat_no, mobile_no " +
                      "FROM complaints WHERE status = 'Pending'";
        try (PreparedStatement ps = conn.prepareStatement(sql1);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> c = new HashMap<>();
                c.put("complaint_id", rs.getString("complaint_id"));
                c.put("resident_name", rs.getString("resident_name"));
                c.put("complaint_text", rs.getString("complaint_text"));
                c.put("flat_no", rs.getString("flat_no"));
                c.put("mobile_no", rs.getString("mobile_no"));
                complaints.add(c);
            }
        }

        // Get available staff
        String sql2 = "SELECT staff_id, name, role FROM staff WHERE availability = 'Available'";
        try (PreparedStatement ps = conn.prepareStatement(sql2);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> s = new HashMap<>();
                s.put("staff_id", rs.getString("staff_id"));
                s.put("name", rs.getString("name"));
                s.put("role", rs.getString("role"));
                staffList.add(s);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Assign Complaints</title>
    <style>
        body { font-family: Arial; background: #f4f7f6; padding: 20px; }
        table { border-collapse: collapse; width: 100%; background: white; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #00695c; color: white; }
        button { padding: 6px 12px; background: #ff9800; color: white; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: #e68900; }
        a { text-decoration: none; color: #00695c; font-weight: bold; }
    </style>
</head>
<body>
    <h2>Assign Complaints to Staff</h2>

    <table>
        <tr>
            <th>Complaint ID</th>
            <th>Resident</th>
            <th>Flat No</th>
            <th>Mobile</th>
            <th>Complaint</th>
            <th>Assign To</th>
            <th>Action</th>
        </tr>
        <% for (Map<String, String> c : complaints) { %>
            <tr>
                <td><%= c.get("complaint_id") %></td>
                <td><%= c.get("resident_name") %></td>
                <td><%= c.get("flat_no") %></td>
                <td><%= c.get("mobile_no") %></td>
                <td><%= c.get("complaint_text") %></td>
                <td>
                    <form action="<%= request.getContextPath() %>/AssignComplaintServlet" method="post">
                        <select name="staffId" required>
                            <% for (Map<String, String> s : staffList) { %>
                                <option value="<%= s.get("staff_id") %>">
                                    <%= s.get("name") %> (<%= s.get("role") %>)
                                </option>
                            <% } %>
                        </select>
                </td>
                <td>
                        <input type="hidden" name="complaintId" value="<%= c.get("complaint_id") %>" />
                        <button type="submit">Assign</button>
                    </form>
                </td>
            </tr>
        <% } %>
    </table>

    <br>
    <a href="admindashboard.jsp">Back to Dashboard</a>

    <!-- Success/Error Alerts -->
    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if ("1".equals(success)) {
    %>
        <script>alert("Complaint assigned successfully!");</script>
    <%
        } else if ("1".equals(error)) {
    %>
        <script>alert("Error while assigning complaint. Try again!");</script>
    <%
        }
    %>
</body>
</html>
