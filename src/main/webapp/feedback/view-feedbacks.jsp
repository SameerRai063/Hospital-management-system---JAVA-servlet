<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="Feedback.Model.Feedback" %>
<html>
<head>
    <title>View Feedbacks</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <h1>Feedbacks</h1>
    <div class="card">
        <table class="table">
            <thead>
            <tr><th>ID</th><th>Appointment</th><th>Patient</th><th>Doctor</th><th>Rating</th><th>Comment</th><th>Submitted</th></tr>
            </thead>
            <tbody>
            <%
                List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
                if (feedbacks == null) feedbacks = Collections.emptyList();
                for (Feedback f : feedbacks) {
            %>
            <tr>
                <td><%=f.getId()%></td>
                <td><%=f.getAppointmentId()%></td>
                <td><%=f.getPatientId()%></td>
                <td><%=f.getDoctorId()%></td>
                <td><%=f.getRating()%></td>
                <td><%=f.getComment()%></td>
                <td><%=f.getCreatedAt()%></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <p><a href="<%=request.getContextPath()%>/admin_dashboard.jsp">Back to dashboard</a></p>
</div>
</body>
</html>

