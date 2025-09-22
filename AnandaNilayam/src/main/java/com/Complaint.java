package com;

import java.util.Date;

public class Complaint {
    private int id;                // complaint_id in DB
    private String residentName;
    private String complaintText;
    private String status;
    private Date dateSubmitted;    // date_submitted or created_at

    // Getters & setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getResidentName() {
        return residentName;
    }
    public void setResidentName(String residentName) {
        this.residentName = residentName;
    }

    public String getComplaintText() {
        return complaintText;
    }
    public void setComplaintText(String complaintText) {
        this.complaintText = complaintText;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDateSubmitted() {
        return dateSubmitted;
    }
    public void setDateSubmitted(Date dateSubmitted) {
        this.dateSubmitted = dateSubmitted;
    }
}
