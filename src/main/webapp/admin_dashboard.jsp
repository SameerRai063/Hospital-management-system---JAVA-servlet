<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!AuthUtil.isAdmin(request)) {
        response.sendRedirect(request.getContextPath() + AuthUtil.getDashboardPath(request));
        return;
    }

    String displayName = AuthUtil.getUsername(request);
    if (displayName == null || displayName.isBlank()) {
        displayName = "Admin";
    }

    String displayRole = AuthUtil.getUserRole(request);
    if (displayRole == null || displayRole.isBlank()) {
        displayRole = "ADMIN";
    }

    char userInitial = Character.toUpperCase(displayName.charAt(0));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Admin control center</div>
        <h1>Welcome back, <%= displayName %>.</h1>
        <p>Your <%= displayRole.toLowerCase() %> control center is connected to the backend session, so ratings and feedback reflect live hospital activity.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">Open Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Signed in as</div>
            <div class="stat-value"><%= displayName %></div>
            <div class="stat-note">Role: <%= displayRole %> • Session-backed UI context.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Response</div>
            <div class="stat-value">Quick</div>
            <div class="stat-note">Track concerns faster with a simple interface.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Control</div>
            <div class="stat-value">Central</div>
            <div class="stat-note">Jump directly to rating management and feedback review.</div>
        </div>
    </section>

    <section class="action-grid">
        <article class="action-card">
            <div class="action-title"><span class="action-icon">★</span> Manage Ratings & Feedback</div>
            <p>View, review, and manage all patient ratings and feedback from the system.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/ratings">View All Ratings</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">📊</span> Hospital Insights</div>
            <p>Monitor quality metrics and patient satisfaction across all doctors and services.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Go Home</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">⌂</span> Home</div>
            <p>Return to the main landing page whenever you need to switch context or modules.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Go Home</a>
            </div>
        </article>
    </section>

    <div class="footer-note">Use the actions above to manage hospital ratings and feedback efficiently. Avatar: <%= userInitial %></div>
</div>
</body>
</html>

