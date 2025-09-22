package com.dao;

import com.Complaint;
import com.util.Constants;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    public ComplaintDAO() {
        try {
            // Load JDBC driver once in constructor
            Class.forName(Constants.DB_DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(Constants.DB_URL, Constants.DB_USER, Constants.DB_PASSWORD);
    }

    /**
     * Fetch complaints filed by a particular resident.
     */
    public List<Complaint> getComplaintsByResidentName(String residentName) throws SQLException {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT complaint_id, resident_name, complaint_text, status, date_submitted " +
                     "FROM " + Constants.COMPLAINTS_TABLE + " WHERE resident_name = ? ORDER BY date_submitted DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, residentName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint c = new Complaint();
                    c.setId(rs.getInt("complaint_id"));
                    c.setResidentName(rs.getString("resident_name"));
                    c.setComplaintText(rs.getString("complaint_text"));
                    c.setStatus(rs.getString("status"));
                    c.setDateSubmitted(rs.getTimestamp("date_submitted"));
                    list.add(c);
                }
            }
        }
        return list;
    }

    /**
     * Get a specific complaint by its ID.
     */
    public Complaint getComplaintById(int id) throws SQLException {
        Complaint c = null;
        String sql = "SELECT complaint_id, resident_name, complaint_text, status, date_submitted FROM " 
                      + Constants.COMPLAINTS_TABLE + " WHERE complaint_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = new Complaint();
                    c.setId(rs.getInt("complaint_id"));
                    c.setResidentName(rs.getString("resident_name"));
                    c.setComplaintText(rs.getString("complaint_text"));
                    c.setStatus(rs.getString("status"));
                    c.setDateSubmitted(rs.getTimestamp("date_submitted"));
                }
            }
        }
        return c;
    }

    /**
     * Update the complaint text only if the complaint status is Pending.
     */
    public void updateComplaint(Complaint complaint) throws SQLException {
        String sql = "UPDATE " + Constants.COMPLAINTS_TABLE + " SET complaint_text = ? WHERE complaint_id = ? AND status = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, complaint.getComplaintText());
            ps.setInt(2, complaint.getId());
            ps.setString(3, Constants.STATUS_PENDING);
            ps.executeUpdate();
        }
    }

    /**
     * Cancel the complaint only if the status is Pending.
     */
    public void cancelComplaint(int id) throws SQLException {
        String sql = "UPDATE " + Constants.COMPLAINTS_TABLE + " SET status = ? WHERE complaint_id = ? AND status = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, Constants.STATUS_CANCELLED);
            ps.setInt(2, id);
            ps.setString(3, Constants.STATUS_PENDING);
            ps.executeUpdate();
        }
    }

    /**
     * Fetch complaints by status (e.g., Pending)
     */
    public List<Complaint> getComplaintsByStatus(String status) throws SQLException {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT complaint_id, resident_name, complaint_text, status, date_submitted FROM "
                     + Constants.COMPLAINTS_TABLE + " WHERE status = ? ORDER BY date_submitted DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint c = new Complaint();
                    c.setId(rs.getInt("complaint_id"));
                    c.setResidentName(rs.getString("resident_name"));
                    c.setComplaintText(rs.getString("complaint_text"));
                    c.setStatus(rs.getString("status"));
                    c.setDateSubmitted(rs.getTimestamp("date_submitted"));
                    list.add(c);
                }
            }
        }
        return list;
    }

    /**
     * Assign complaint to a staff member, only if status is Pending.
     */
    public void assignComplaintToStaff(int complaintId, String staffName) throws SQLException {
        String sql = "UPDATE " + Constants.COMPLAINTS_TABLE + " SET status = ?, assigned_staff = ? WHERE complaint_id = ? AND status = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, Constants.STATUS_IN_PROGRESS);
            ps.setString(2, staffName);
            ps.setInt(3, complaintId);
            ps.setString(4, Constants.STATUS_PENDING);

            ps.executeUpdate();
        }
    }
}
