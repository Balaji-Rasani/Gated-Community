# Gated-Community
Ananda Nilayam _Gated Community

🏢 Gated Community - Complaint Tracker Application 🛠️

Welcome to the Complaint Tracker Application, a web-based system developed using Java Servlets, JSP, MySQL, and Apache Tomcat. This project is designed to streamline the complaint management process in apartment complexes, ensuring that issues are logged, tracked, and resolved efficiently.

🎯 Objective

The goal is to:

📌 Simplify complaint logging for residents.

🔎 Provide real-time status tracking for complaints.

🛠️ Enable administrators to manage, assign, and resolve complaints effectively.

📊 Improve transparency and accountability within gated communities.

👨‍💻 Features
👨‍👩‍👧 Resident Functionalities

✅ Register & Login – Residents can sign up and log in securely.

✅ Submit Complaints – Raise issues like water supply, electricity, or maintenance.

✅ View Complaint Status – Track if complaints are pending, in progress, or resolved.

✅ Update/Cancel Complaints – Modify or withdraw complaints if needed.

✅ Complaint History – Access past complaints and resolutions.

🛠️ Admin Functionalities

✅ View All Complaints – Monitor complaints submitted by residents.

✅ Update Complaint Status – Change status: "Pending" → "In Progress" → "Resolved".

✅ Assign Complaints – Assign staff/maintenance workers for resolution.

✅ Generate Reports – Track complaint resolution times and trends.

🧠 Concepts Demonstrated

JDBC Connectivity – Handling database operations between Java and MySQL.

MVC Architecture – Separation of concerns using Servlets (Controller), JSP (View), and MySQL (Model).

Session Management – Secure login/logout and user tracking.

Exception Handling – Robust error handling for smooth user experience.

📂 Project Structure
ComplaintTracker/
├── src/
│   ├── com/resident/      # Resident-related classes
│   ├── com/admin/         # Admin-related classes
│   ├── com/utils/         # Utility classes (DB connection, helpers)
├── webapp/
│   ├── WEB-INF/           # web.xml configuration
│   ├── views/             # JSP files (UI for residents/admins)
│   ├── assets/            # CSS, JS, Images
├── database/
│   └── complaint_db.sql   # MySQL schema and tables
├── .classpath
├── .project
├── README.md

🏗️ Tech Stack

Backend: Java Servlets, JSP

Database: MySQL

Server: Apache Tomcat

Database Connectivity: JDBC

⚙️ How to Run

Clone the Repository

git clone https://github.com/yourusername/complaint-tracker.git
cd complaint-tracker


Setup Database

Create MySQL database:

CREATE DATABASE complaint_db;


Import the complaint_db.sql file.

Configure JDBC

Update your DB credentials in DBConnection.java:

String url = "jdbc:mysql://localhost:3306/complaint_db";
String username = "root";
String password = "yourpassword";


Deploy on Tomcat

Copy the project to Tomcat’s webapps folder.

Start Tomcat server.

Access the Application

Open in browser:

http://localhost:8080/complaint-tracker

🚀 Future Enhancements

🔔 Email / SMS notifications for updates.

📱 Mobile-friendly responsive design.

📊 Analytics dashboard for admins.

👥 Role-based access control (Residents, Admins, Staff).

🤝 Contributing

Found a bug or want to suggest a new feature?

Fork the repo

Create your feature branch

Submit a pull request 🚀

👤 Author

Your Name:Balaji-Rasani

GitHub: https://github.com/Balaji-Rasani

Email: rasanibalaji74@gmail.com
