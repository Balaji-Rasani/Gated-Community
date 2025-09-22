<%@ page session="true" %>
<%
    if (request.getAttribute("complaintId") == null) {
        response.sendRedirect("trackComplaint.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Complaint Status</title>
    <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: 20px auto;
            font-family: Arial, sans-serif;
        }
        th, td {
            border: 1px solid #333;
            padding: 8px 12px;
            text-align: left;
        }
        th.field-header {
            background-color: #4da3ff; /* Light blue */
            color: white;
        }
        th.value-header {
            background-color: #4caf50; /* Light green */
            color: white;
        }
        td.field-name {
            font-weight: bold; /* Make field names bold */
        }
        tr:nth-child(even) td {
            background-color: #f9f9f9; /* Alternating row color */
        }
        h2 {
            text-align: center;
            font-family: Arial, sans-serif;
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h2>Complaint Details</h2>
    <table>
        <tr>
            <th class="field-header">Field</th>
            <th class="value-header">Value</th>
        </tr>
        <tr>
            <td class="field-name">ID</td>
            <td><%= request.getAttribute("complaintId") %></td>
        </tr>
        <tr>
            <td class="field-name">Complaint</td>
            <td><%= request.getAttribute("complaintText") %></td>
        </tr>
        <tr>
            <td class="field-name">Status</td>
            <td><%= request.getAttribute("status") %></td>
        </tr>
        <tr>
            <td class="field-name">Created At</td>
            <td><%= request.getAttribute("createdAt") %></td>
        </tr>
    </table>

    <div class="links">
        <a href="trackComplaint.jsp">Back to Track Complaint</a> |
        <a href="residentdashboard.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
