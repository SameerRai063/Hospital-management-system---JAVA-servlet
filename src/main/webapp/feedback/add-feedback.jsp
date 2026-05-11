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

    String dashboardPath = request.getContextPath() + AuthUtil.getDashboardPath(request);

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
    <title>Leave Feedback</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Patient feedback</div>
        <h1>Share Your Experience • <%= displayName %></h1>
        <p>Your <%= displayRole.toLowerCase() %> feedback form is connected to the backend session. Keep your feedback short, honest, and helpful. Avatar: <%= userInitial %></p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="<%=dashboardPath%>">Back to Dashboard</a>
            <a class="link-btn link-btn-soft" href="<%=request.getContextPath()%>/ratings">View My Ratings</a>
        </div>
    </section>

    <div class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Signed in as</div>
            <div class="stat-value"><%= displayName %></div>
            <div class="stat-note">Role: <%= displayRole %> • Session-backed UI context.</div>
        </div>
    </div>

    <div class="meta-grid">
        <div class="form-card">
            <div class="section-title">
                <div>
                    <h2>Submit feedback</h2>
                    <p>Fill in the appointment, doctor, rating, and your comment.</p>
                </div>
                <span class="badge badge-soft">Quick form</span>
            </div>

            <form method="post" action="<%=request.getContextPath()%>/submitFeedback" class="stack">
                <div class="form-grid">
                    <div class="field">
                        <label for="appointment_id">Appointment ID</label>
                        <input id="appointment_id" type="number" name="appointment_id" min="1" placeholder="e.g. 12" required>
                        <div class="helper">Enter the appointment you want to review.</div>
                    </div>
                    <div class="field">
                        <label for="doctor_id">Doctor ID</label>
                        <input id="doctor_id" type="number" name="doctor_id" min="1" placeholder="e.g. 5" required>
                        <div class="helper">This helps link your feedback to the doctor.</div>
                    </div>
                    <div class="field full">
                        <label for="rating">Overall rating</label>
                        <select id="rating" name="rating" required>
                            <option value="">Select rating</option>
                            <option value="5">5 - Excellent</option>
                            <option value="4">4 - Good</option>
                            <option value="3">3 - Average</option>
                            <option value="2">2 - Needs improvement</option>
                            <option value="1">1 - Poor</option>
                        </select>
                        <div class="helper">Choose a rating that matches your experience.</div>
                    </div>
                    <div class="field full">
                        <label for="comment">Comment</label>
                        <textarea id="comment" name="comment" placeholder="Tell us what went well and what we can improve."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Submit Feedback</button>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/feedbacks">View Feedbacks</a>
                </div>
            </form>
        </div>

        <div class="info-card card-pad">
            <div class="badge badge-green">Helpful tips</div>
            <div style="height:12px"></div>
            <h2 style="margin:0 0 10px; font-size:22px;">What makes good feedback?</h2>
            <p class="helper" style="margin-top:0">Mention the visit experience, staff behavior, waiting time, and anything your care team should know.</p>
            <div class="stack" style="margin-top:18px">
                <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                    <div class="stat-label">Tip 1</div>
                    <div class="stat-note">Be specific about the appointment you are reviewing.</div>
                </div>
                <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                    <div class="stat-label">Tip 2</div>
                    <div class="stat-note">Use the rating scale honestly and add a short note.</div>
                </div>
                <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                    <div class="stat-label">Tip 3</div>
                    <div class="stat-note">Keep your comments respectful and constructive.</div>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-note">Your feedback helps improve care quality across the hospital.</div>
</div>
</body>
</html>

