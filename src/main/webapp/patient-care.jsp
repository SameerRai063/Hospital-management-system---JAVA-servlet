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
        <h1>Rate your visit and leave feedback in one place.</h1>
        <p>This page keeps your doctor rating and feedback form together, so you can submit everything without jumping between pages.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="${pageContext.request.contextPath}/patient_dashboard.jsp">Back to Dashboard</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/ratings">My Ratings</a>
            <a class="link-btn link-btn-soft" href="${pageContext.request.contextPath}/feedback/add-feedback.jsp">Feedback Only</a>
        </div>
    </section>

    <section class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">One page</div>
            <div class="stat-value">Unified</div>
            <div class="stat-note">Submit a rating and feedback without opening multiple screens.</div>
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

    <div class="meta-grid">
        <section class="form-card">
            <div class="section-title">
                <div>
                    <h2>Doctor rating</h2>
                    <p>Rate your completed appointment.</p>
                </div>
                <span class="badge badge-blue">Rating</span>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/AddRatingServlet" class="stack">
                <div class="form-grid">
                    <div class="field">
                        <label for="appointmentId">Appointment ID</label>
                        <input id="appointmentId" type="number" name="appointmentId" min="1" placeholder="e.g. 12" required value="<%= appointmentId == null ? "" : appointmentId %>">
                    </div>
                    <div class="field">
                        <label for="doctorId">Doctor ID</label>
                        <input id="doctorId" type="number" name="doctorId" min="1" placeholder="e.g. 5" value="<%= doctorId == null ? "" : doctorId %>">
                    </div>
                    <div class="field full">
                        <label for="score">Your rating</label>
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
                        <label for="review">Review</label>
                        <textarea id="review" name="review" maxlength="1000" placeholder="Share a few lines about your experience."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Submit Rating</button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/rating/add-rating.jsp">Open Old Rating Page</a>
                </div>
            </form>
        </section>

        <section class="form-card">
            <div class="section-title">
                <div>
                    <h2>Feedback form</h2>
                    <p>Leave broader feedback about the visit.</p>
                </div>
                <span class="badge badge-green">Feedback</span>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/submitFeedback" class="stack">
                <div class="form-grid">
                    <div class="field">
                        <label for="appointment_id">Appointment ID</label>
                        <input id="appointment_id" type="number" name="appointment_id" min="1" placeholder="e.g. 12" required value="<%= appointmentId == null ? "" : appointmentId %>">
                    </div>
                    <div class="field">
                        <label for="doctor_id">Doctor ID</label>
                        <input id="doctor_id" type="number" name="doctor_id" min="1" placeholder="e.g. 5" required value="<%= doctorId == null ? "" : doctorId %>">
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
                    </div>
                    <div class="field full">
                        <label for="comment">Comment</label>
                        <textarea id="comment" name="comment" placeholder="Tell us what went well and what could be improved."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Submit Feedback</button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/feedback/add-feedback.jsp">Open Old Feedback Page</a>
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

