<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!AuthUtil.isPatient(request)) {
        response.sendRedirect(request.getContextPath() + AuthUtil.getDashboardPath(request));
        return;
    }

    String displayName = AuthUtil.getUsername(request);
    if (displayName == null || displayName.isBlank()) {
        displayName = "Patient";
    }

    String displayRole = AuthUtil.getUserRole(request);
    if (displayRole == null || displayRole.isBlank()) {
        displayRole = "PATIENT";
    }

    char userInitial = Character.toUpperCase(displayName.charAt(0));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Patient portal</div>
        <h1>Welcome back, <%= displayName %>.</h1>
        <p>Your <%= displayRole.toLowerCase() %> portal is connected to the backend session, so you can rate visits, leave feedback, and review history without leaving this page.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">Open My Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Signed in as</div>
            <div class="stat-value"><%= displayName %></div>
            <div class="stat-note">Role: <%= displayRole %> • Session-backed UI context.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Access</div>
            <div class="stat-value">24/7</div>
            <div class="stat-note">Review your submitted ratings and feedback anytime.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Support</div>
            <div class="stat-value">Fast</div>
            <div class="stat-note">Navigate quickly between ratings, feedback, and home.</div>
        </div>
    </section>

    <section class="action-grid">
        <article class="action-card">
            <div class="action-title"><span class="action-icon">★</span> Rate & Leave Feedback</div>
            <p>Share your rating and feedback about your doctor visit in one simple form.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/patient-care.jsp">Rate Now</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">📋</span> My Ratings & Feedback</div>
            <p>View all your submitted ratings and feedback about past doctors and visits.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/ratings">View History</a>
            </div>
        </article>
    </section>

    <div class="footer-note">Use the cards above to move between rating and feedback features. Avatar: <%= userInitial %></div>
</div>
</body>
</html>

