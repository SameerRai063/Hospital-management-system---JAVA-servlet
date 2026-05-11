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
        <h1>Manage ratings and feedback.</h1>
        <p>Monitor patient reviews, inspect feedback submissions, and keep the hospital experience organized.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">Open Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Visibility</div>
            <div class="stat-value">All</div>
            <div class="stat-note">Review every rating and feedback entry in one place.</div>
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
            <div class="action-title"><span class="action-icon">★</span> Manage Ratings</div>
            <p>View, edit, and delete submitted ratings from the management panel.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/ratings">Open Ratings</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">💬</span> Feedback Inbox</div>
            <p>Read patient feedback submissions and inspect the latest comments.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/feedbacks">View Feedback</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">⌂</span> Home</div>
            <p>Return to the main landing page whenever you need to switch context.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Go Home</a>
            </div>
        </article>
    </section>

    <div class="footer-note">Use the actions above to manage hospital ratings and feedback efficiently.</div>
</div>
</body>
</html>

