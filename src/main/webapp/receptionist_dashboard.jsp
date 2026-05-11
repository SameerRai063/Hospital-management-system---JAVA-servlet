<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!AuthUtil.isReceptionist(request)) {
        response.sendRedirect(request.getContextPath() + AuthUtil.getDashboardPath(request));
        return;
    }

    String displayName = AuthUtil.getUsername(request);
    if (displayName == null || displayName.isBlank()) {
        displayName = "Receptionist";
    }

    String displayRole = AuthUtil.getUserRole(request);
    if (displayRole == null || displayRole.isBlank()) {
        displayRole = "RECEPTIONIST";
    }

    char userInitial = Character.toUpperCase(displayName.charAt(0));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receptionist Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Reception desk</div>
        <h1>Welcome back, <%= displayName %>.</h1>
        <p>Your <%= displayRole.toLowerCase() %> workspace is connected to the backend session, so front-desk navigation reflects the live account.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/feedbacks">Open Feedback</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Signed in as</div>
            <div class="stat-value"><%= displayName %></div>
            <div class="stat-note">Role: <%= displayRole %> • Session-backed UI context.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Visibility</div>
            <div class="stat-value">Clear</div>
            <div class="stat-note">Open ratings and feedback pages when needed.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Support</div>
            <div class="stat-value">Quick</div>
            <div class="stat-note">Designed as a lightweight starting point for desk operations.</div>
        </div>
    </section>

    <section class="action-grid">
        <article class="action-card">
            <div class="action-title"><span class="action-icon">★</span> View Ratings & Feedback</div>
            <p>Check patient ratings and feedback to support front-desk operations and customer service.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/feedbacks">View All</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">📞</span> Patient Support</div>
            <p>Help patients with inquiries and direct them to appropriate services or staff.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Go Home</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">⌂</span> Home</div>
            <p>Return to the landing page anytime to switch roles or modules.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Go Home</a>
            </div>
        </article>
    </section>

    <div class="footer-note">A clean front-desk dashboard keeps navigation simple and fast. Avatar: <%= userInitial %></div>
</div>
</body>
</html>

