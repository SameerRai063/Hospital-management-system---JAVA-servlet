<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!AuthUtil.isDoctor(request)) {
        response.sendRedirect(request.getContextPath() + AuthUtil.getDashboardPath(request));
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Doctor workspace</div>
        <h1>Track ratings and patient feedback.</h1>
        <p>See how your patients feel, review feedback, and keep improving the consultation experience.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">Open Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Doctor view</div>
            <div class="stat-value">Focused</div>
            <div class="stat-note">Review only your ratings and patient feedback.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Improvement</div>
            <div class="stat-value">Driven</div>
            <div class="stat-note">Use comments to enhance patient communication.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Access</div>
            <div class="stat-value">Easy</div>
            <div class="stat-note">Open the rating and feedback panels in one tap.</div>
        </div>
    </section>

    <section class="action-grid">
        <article class="action-card">
            <div class="action-title"><span class="action-icon">★</span> My Ratings</div>
            <p>Inspect the ratings you received from patients and monitor service quality.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/ratings">View Ratings</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">💬</span> Patient Feedback</div>
            <p>Read submitted feedback and better understand patient expectations.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/feedbacks">View Feedback</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">⌂</span> Home</div>
            <p>Return to the home page whenever you need to switch modules.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Go Home</a>
            </div>
        </article>
    </section>

    <div class="footer-note">Your dashboard keeps ratings and feedback within easy reach.</div>
</div>
</body>
</html>

