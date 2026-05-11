<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
        return;
    }
    if (!AuthUtil.isPatient(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
        return;
    }

    String appointmentId = request.getParameter("appointmentId");
    String doctorId = request.getParameter("doctorId");
    String doctorName = request.getParameter("doctorName");
    String appointmentDate = request.getParameter("appointmentDate");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Doctor Rating</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/dashboard-ui.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Doctor rating</div>
        <h1>Share your rating after a completed appointment.</h1>
        <p>This streamlined form keeps your doctor rating consistent with the feedback center and your dashboard.</p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="<%=request.getContextPath()%>/patient-care.jsp">Open Combined Center</a>
            <a class="link-btn link-btn-soft" href="<%=request.getContextPath()%>/ViewRatingServlet">My Ratings</a>
        </div>
    </section>

    <div class="meta-grid">
        <div class="form-card">
            <div class="section-title">
                <div>
                    <h2>Add rating</h2>
                    <p>Complete the form below and submit your review.</p>
                </div>
                <span class="badge badge-blue">Rating</span>
            </div>

            <div class="panel card-pad" style="margin-bottom:16px; background:rgba(255,255,255,0.65)">
                <div class="section-title" style="margin-bottom:0">
                    <div>
                        <strong>Selected details</strong>
                        <div class="helper">Doctor: <%= (doctorName != null && !doctorName.isBlank()) ? doctorName : ("#" + (doctorId == null ? "" : doctorId)) %></div>
                        <div class="helper">Appointment: <%= (appointmentId == null ? "" : appointmentId) %></div>
                        <div class="helper">Date: <%= (appointmentDate == null ? "-" : appointmentDate) %></div>
                    </div>
                </div>
            </div>

            <% if (error != null && !error.isBlank()) { %>
                <div class="alert"><b>Error:</b> <%= error %></div>
            <% } %>

            <form method="post" action="<%=request.getContextPath()%>/AddRatingServlet" class="stack">
                <div class="form-grid">
                    <div class="field">
                        <label for="appointmentId">Appointment ID</label>
                        <input id="appointmentId" type="number" name="appointmentId" required min="1" value="<%= appointmentId == null ? "" : appointmentId %>">
                    </div>
                    <div class="field">
                        <label for="doctorId">Doctor ID</label>
                        <input id="doctorId" type="number" name="doctorId" min="1" value="<%= doctorId == null ? "" : doctorId %>">
                    </div>
                    <div class="field full">
                        <label for="score">Rating</label>
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
                        <textarea id="review" name="review" maxlength="1000" placeholder="Write your experience (optional)"></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Submit Rating</button>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/ViewRatingServlet">Back to Ratings</a>
                </div>
            </form>
        </div>

        <div class="info-card card-pad">
            <div class="badge badge-green">Helpful tips</div>
            <div style="height:12px"></div>
            <h2 style="margin:0 0 10px; font-size:22px;">Make your rating useful</h2>
            <p class="helper" style="margin-top:0">Use the 1–5 scale honestly. If you want to add more context, use the feedback center to write a longer comment.</p>
            <div class="stack" style="margin-top:18px">
                <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                    <div class="stat-label">Tip 1</div>
                    <div class="stat-note">Keep the appointment ID accurate.</div>
                </div>
                <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                    <div class="stat-label">Tip 2</div>
                    <div class="stat-note">Use the combined center if you also want to send feedback.</div>
                </div>
                <div class="stat-card" style="box-shadow:none; background:rgba(255,255,255,0.65)">
                    <div class="stat-label">Tip 3</div>
                    <div class="stat-note">Your edit/delete history remains available in My Ratings.</div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

