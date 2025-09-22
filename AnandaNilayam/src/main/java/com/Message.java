package com;

import java.sql.Timestamp;

public class Message {
    private int id;
    private String senderUsername;
    private String senderRole;  // "resident" or "admin"
    private String content;
    private Timestamp sentAt;

    // No-argument constructor
    public Message() {}

    // All-argument constructor
    public Message(int id, String senderUsername, String senderRole, String content, Timestamp sentAt) {
        this.id = id;
        this.senderUsername = senderUsername;
        this.senderRole = senderRole;
        this.content = content;
        this.sentAt = sentAt;
    }

    // Getters and setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getSenderUsername() {
        return senderUsername;
    }
    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public String getSenderRole() {
        return senderRole;
    }
    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }
    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }
}
