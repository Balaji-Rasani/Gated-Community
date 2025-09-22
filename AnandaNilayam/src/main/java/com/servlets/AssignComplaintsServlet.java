package com.servlets;

import com.Complaint;
import com.dao.ComplaintDAO;
import com.User;
import com.util.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/AssignComplaintsServlet")
public class AssignComplaintsServlet extends HttpServlet {

    private ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !Constants.ROLE_ADMIN.equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        try {
            List<Complaint> pendingComplaints = complaintDAO.getComplaintsByStatus(Constants.STATUS_PENDING);
            request.setAttribute("pendingComplaints", pendingComplaints);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load pending complaints.");
        }

        request.getRequestDispatcher("/AssignComplaints.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !Constants.ROLE_ADMIN.equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        String staffName = request.getParameter("staffName");
        String complaintIdStr = request.getParameter("complaintId");

        if (staffName == null || staffName.trim().isEmpty() || complaintIdStr == null) {
            request.setAttribute("error", "Please select a staff member and try again.");
            doGet(request, response);
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            complaintDAO.assignComplaintToStaff(complaintId, staffName);
            request.setAttribute("message", "Complaint assigned successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to assign complaint.");
        }

        doGet(request, response);
    }
}
