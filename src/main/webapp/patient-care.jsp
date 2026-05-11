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

    String appointmentId = request.getParameter("appointmentId");
    String doctorId = request.getParameter("doctorId");
    String doctorName = request.getParameter("doctorName");
    String appointmentDate = request.getParameter("appointmentDate");

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
    <title>Rate & Feedback Center</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Patient care center</div>
        <h1>Rate & Feedback Center • <%= displayName %></h1>
        <p>Your <%= displayRole.toLowerCase() %> workspace combined rating and feedback in one place. Session-backed backend context. Avatar: <%= userInitial %></p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/patient_dashboard.jsp">Back to Dashboard</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">My Ratings</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Signed in as</div>
            <div class="stat-value"><%= displayName %></div>
            <div class="stat-note">Role: <%= displayRole %> • Session-backed UI context.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Style</div>
            <div class="stat-value">Modern</div>
            <div class="stat-note">Uses the shared hospital dashboard design for a cleaner look.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Focus</div>
            <div class="stat-value">Fast</div>
            <div class="stat-note">Short forms and clear actions keep the process simple.</div>
        </div>
    </section>

    <div style="max-width: 600px; margin: 32px auto; text-align: center;">
        <section class="form-card">
            <div class="section-title">
                <div>
                    <h2>Rate Your Doctor Visit</h2>
                    <p>Share your experience and feedback about this appointment.</p>
                </div>
                <span class="badge badge-blue">Rating & Feedback</span>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/AddRatingServlet" class="stack">
                <div class="form-grid">
                    <div class="field">
                        <label for="appointmentId">Appointment ID</label>
                        <input id="appointmentId" type="number" name="appointmentId" min="1" placeholder="e.g. 12" required value="<%= appointmentId == null ? "" : appointmentId %>">
                    </div>
                    <div class="field">
                        <label for="doctorId">Doctor ID</label>
                        <input id="doctorId" type="number" name="doctorId" min="1" placeholder="e.g. 5" required value="<%= doctorId == null ? "" : doctorId %>">
                    </div>
                    <div class="field full">
                        <label for="score">Your Rating</label>
                        <select id="score" name="score" required>
                            <option value="">Select rating</option>
                            <option value="5">5 - Excellent</option>
                            <option value="4">4 - Good</option>
                            <option value="3">3 - Average</option>
                            <option value="2">2 - Needs improvement</option>
                            <option value="1">1 - Poor</option>
                        </select>
                    </div>
                    <div class="field full">
                        <label for="review">Your Feedback (Optional)</label>
                        <textarea id="review" name="review" maxlength="1000" placeholder="Share your experience about the doctor, staff, and visit. What went well? What could be improved?"></textarea>
                    </div>
                </div>

                <div class="form-actions" style="justify-content: center;">
                    <button type="submit" class="btn btn-primary">Submit Rating & Feedback</button>
                </div>
            </form>
        </section>
    </div>

    <div class="panel card-pad">
        <div class="section-title">
            <div>
                <h2>Quick notes</h2>
                <p><%= (doctorName == null || doctorName.isBlank()) ? "No doctor selected yet." : "Selected doctor: " + doctorName %></p>
            </div>
            <span class="badge badge-soft">Optional</span>
        </div>
        <div class="meta-grid">
            <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                <div class="stat-label">Appointment</div>
                <div class="stat-note"><%= appointmentDate == null ? "Choose a completed appointment to keep the review accurate." : appointmentDate %></div>
            </div>
            <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                <div class="stat-label">Tip</div>
                <div class="stat-note">If you already used the older pages, they still work — this page just combines both actions.</div>
            </div>
        </div>
    </div>

    <div class="footer-note">This combined screen keeps rating and feedback together in one modern UI.</div>
</div>
</body>
</html>

