package com.servlets;

import com.Complaint;
import com.User;
import com.dao.ComplaintDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/UpdateCancelComplaintServlet")
public class UpdateCancelComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !"resident".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }

        String action = request.getParameter("action");
        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            response.sendRedirect("ViewComplaintStatusServlet");
            return;
        }

        try {
            Complaint complaint = complaintDAO.getComplaintById(id);

            if (complaint == null || !complaint.getResidentName().equals(user.getUsername())) {
                response.sendRedirect("ViewComplaintStatusServlet");
                return;
            }

            if ("update".equals(action)) {
                String complaintText = request.getParameter("complaintText");
                if (complaintText == null || complaintText.trim().isEmpty()) {
                    request.setAttribute("error", "Complaint text cannot be empty.");
                    request.getRequestDispatcher("update_cancel_complaint.jsp?id=" + id).forward(request, response);
                    return;
                }

                complaint.setComplaintText(complaintText);
                complaintDAO.updateComplaint(complaint);

            } else if ("cancel".equals(action)) {
                complaintDAO.cancelComplaint(id);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred.");
            request.getRequestDispatcher("update_cancel_complaint.jsp?id=" + id).forward(request, response);
            return;
        }

        response.sendRedirect("ViewComplaintStatusServlet");
    }
}
