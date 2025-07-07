Payment Dashboard System
Overview
The Payment Dashboard System is a web-based application developed as part of a 3-day internship assignment. It features a user-friendly interface to manage payments and display statistical data, built using Flutter for the frontend and NestJS for the backend. The system allows users to log in, view payment details, and access transaction statistics.
Features

User Authentication: Login functionality with hardcoded credentials (admin/admin123).
Payment Management: Display a list of payments with details (e.g., amount, receiver, status).
Statistics Dashboard: Real-time stats including total transactions (today/week), revenue, and failed transactions.
Logout Functionality: Secure logout to return to the login screen.

Technologies Used

Frontend: Flutter (with web support), Dart
Backend: NestJS, TypeScript, TypeORM
Database: In-memory (mock data for this assignment)
Version Control: Git, hosted on GitHub (git@github.com:GayatriBodhe/payment_dashboard.git)
Dependencies: HTTP client, SharedPreferences (Flutter), CORS, JWT (NestJS)

Installation
Prerequisites

Node.js and npm
Flutter SDK
Git

Setup Instructions

Clone the Repository:
git clone git@github.com:GayatriBodhe/payment_dashboard.git
cd payment_dashboard


Backend Setup:

Navigate to payment-dashboard-backend:cd payment-dashboard-backend


Install dependencies:npm install


Run the backend:npm run start:dev




Frontend Setup:

Navigate to payment_dashboard_frontend:cd ../payment_dashboard_frontend


Install dependencies:flutter pub get


Run the app:flutter run


Select Chrome as the device.



Usage

Log in with admin/admin123 to access the dashboard.
View payments and statistics on the main screen.
Log out using the logout button.

Challenges and Solutions

Issue: Initial Git push failures due to branch mismatches.
Solution: Renamed master to main and committed changes.


Issue: Backend connectivity errors (ClientException: Failed to fetch).
Solution: Adjusted API URL to localhost:3000 and added CORS configuration.


Issue: 401 Unauthorized errors on /payments.
Solution: Temporarily bypassed authentication guards for testing.


Issue: Type errors (e.g., JsonMap vs. Payment).
Solution: Updated api_service.dart to map JSON to Payment models.



Screenshots

Included in the screenshots directory:
Login page
Dashboard with payments and stats
Post-logout screen



Submission Notes

Submitted post-deadline (after 11:59 PM IST, July 07, 2025) due to persistent errors (e.g., 404 on /payments/stats, TypeError resolution).
The project is functional with mock data; further refinements (e.g., real database, JWT validation) are planned for Day 3.

Author

Name: Gayatri Bodhe
GitHub: GayatriBodhe

License
This project is for educational purposes only and is not licensed for commercial use.
