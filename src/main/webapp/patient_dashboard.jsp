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
        <h1>Welcome back, patient.</h1>
        <p>Manage your care experience from one place. Leave feedback after visits, rate your doctor, and review your activity history.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">Open My Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Experience</div>
            <div class="stat-value">Simple</div>
            <div class="stat-note">Rate appointments and share feedback in a few clicks.</div>
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
            <div class="action-title"><span class="action-icon">♥</span> Rate & Feedback Center</div>
            <p>Open the combined page to submit both your rating and feedback in one modern interface.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/patient-care.jsp">Open Center</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">★</span> My Ratings</div>
            <p>View all ratings you have submitted and manage your doctor reviews from a clean list.</p>
            <div class="quick-links">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/ratings">Open Ratings</a>
            </div>
        </article>
        <article class="action-card">
            <div class="action-title"><span class="action-icon">💬</span> Leave Feedback</div>
            <p>Share your experience in detail so your care team can improve future visits.</p>
            <div class="quick-links">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/feedback/add-feedback.jsp">Give Feedback</a>
            </div>
        </article>
    </section>

    <div class="footer-note">Use the cards above to move between rating and feedback features.</div>
</div>
</body>
</html>

