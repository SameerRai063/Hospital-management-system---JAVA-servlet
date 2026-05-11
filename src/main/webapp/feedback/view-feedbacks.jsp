<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="Feedback.Model.Feedback" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String dashboardPath = request.getContextPath() + AuthUtil.getDashboardPath(request);

    String displayName = AuthUtil.getUsername(request);
    if (displayName == null || displayName.isBlank()) {
        displayName = "User";
    }

    String displayRole = AuthUtil.getUserRole(request);
    if (displayRole == null || displayRole.isBlank()) {
        displayRole = "USER";
    }

    char userInitial = Character.toUpperCase(displayName.charAt(0));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Feedbacks</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/dashboard-ui.css">
</head>
<body>
<div class="dashboard-shell">
    <section class="hero">
        <div class="hero-kicker">Feedback overview</div>
        <h1>Feedback Overview • <%= displayName %></h1>
        <p>Feedback is organized in a simple, readable table. Session: <%= displayRole %>. Avatar: <%= userInitial %></p>
        <div class="hero-actions">
            <a class="link-btn link-btn-secondary" href="<%=dashboardPath%>">Back to Dashboard</a>
            <a class="link-btn link-btn-soft" href="<%=request.getContextPath()%>/feedback/add-feedback.jsp">Add Feedback</a>
        </div>
    </section>

    <div class="summary-grid">
        <div class="stat-card">
            <div class="stat-label">Signed in as</div>
            <div class="stat-value"><%= displayName %></div>
            <div class="stat-note">Role: <%= displayRole %> • Session-backed UI context.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Focus</div>
            <div class="stat-value">Clarity</div>
            <div class="stat-note">Review appointment, rating, and comment details at a glance.</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Action</div>
            <div class="stat-value">Review</div>
            <div class="stat-note">Use this page to follow up on patient experience.</div>
        </div>
    </div>

    <section class="table-card">
        <div class="section-title" style="padding:22px 22px 0">
            <div>
                <h2>Feedback list</h2>
                <p>Most recent feedback appears first.</p>
            </div>
            <span class="badge badge-blue">Admin / Doctor view</span>
        </div>

        <div class="table-wrap">
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Appointment</th>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Rating</th>
                    <th>Comment</th>
                    <th>Submitted</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                    if (feedbacks == null) feedbacks = Collections.emptyList();
                    if (feedbacks.isEmpty()) {
                %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">No feedback found yet.</div>
                        </td>
                    </tr>
                <%
                    } else {
                        for (Feedback f : feedbacks) {
                %>
                    <tr>
                        <td><%=f.getId()%></td>
                        <td><%=f.getAppointmentId()%></td>
                        <td><%=f.getPatientId()%></td>
                        <td><%=f.getDoctorId()%></td>
                        <td><span class="badge badge-green"><%=f.getRating()%>/5</span></td>
                        <td><%=f.getComment() == null ? "-" : f.getComment()%></td>
                        <td><%=f.getCreatedAt()%></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </section>

    <div class="footer-note">Use this list to monitor patient experience and improve service quality.</div>
</div>
</body>
</html>

