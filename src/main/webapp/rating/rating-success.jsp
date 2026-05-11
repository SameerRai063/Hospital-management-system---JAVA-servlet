<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    String message = request.getParameter("message");
    if (message == null || message.isBlank()) message = "Done";

    String displayName = "Guest";
    String displayRole = "UNKNOWN";
    char userInitial = 'G';

    if (AuthUtil.isLoggedIn(request)) {
        String username = AuthUtil.getUsername(request);
        if (username != null && !username.isBlank()) {
            displayName = username;
        }
        String role = AuthUtil.getUserRole(request);
        if (role != null && !role.isBlank()) {
            displayRole = role;
        }
    }
    userInitial = Character.toUpperCase(displayName.charAt(0));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Rating Status</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Rating status</div>
        <h1>Action Processed • <%= displayName %></h1>
        <p><%= message %></p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="<%=request.getContextPath()%>/patient-care.jsp">Back to Center</a>
            <a class="link-btn link-btn-soft" href="<%=request.getContextPath()%>/ViewRatingServlet">View Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Status</div>
            <div class="stat-value">Success</div>
            <div class="stat-note">Operation completed successfully. Session: <%= displayRole %> | Avatar: <%= userInitial %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Next step</div>
            <div class="stat-value">Review</div>
            <div class="stat-note">Check your rating history or return to the combined center.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Flow</div>
            <div class="stat-value">Smooth</div>
            <div class="stat-note">The new unified UI keeps rating and feedback together.</div>
        </div>
    </section>
</div>
</body>
</html>

