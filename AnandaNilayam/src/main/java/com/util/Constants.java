package com.util;

public class Constants {

    // Database Configuration
    public static final String DB_URL = "jdbc:mysql://localhost:3306/complaint_system";
    public static final String DB_USER = "root";
    public static final String DB_PASSWORD = "root"; // change as needed
    public static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Table Names
    public static final String RESIDENTS_TABLE = "residents";
    public static final String ADMIN_TABLE = "admins";
    public static final String CHAT_TABLE = "chat_messages";
    public static final String COMPLAINTS_TABLE = "complaints"; // 

    // Complaint Status Constants
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_IN_PROGRESS = "In Progress";
    public static final String STATUS_RESOLVED = "Resolved";
    public static final String STATUS_CANCELLED = "Cancelled";

    // Roles
    public static final String ROLE_ADMIN = "admin";
    public static final String ROLE_RESIDENT = "resident";
}
