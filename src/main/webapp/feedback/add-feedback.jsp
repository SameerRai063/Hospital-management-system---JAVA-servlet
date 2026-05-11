<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Add Feedback</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <h1>Leave Feedback</h1>
    <form method="post" action="<%=request.getContextPath()%>/submitFeedback">
        <div>
            <label>Appointment ID: <input type="number" name="appointment_id" required></label>
        </div>
        <div>
            <label>Doctor ID: <input type="number" name="doctor_id" required></label>
        </div>
        <div>
            <label>Rating (1-5): <input type="number" name="rating" min="1" max="5" required></label>
        </div>
        <div>
            <label>Comment:</label><br>
            <textarea name="comment" rows="4" cols="50"></textarea>
        </div>
        <div>
            <button type="submit" class="btn btn-primary">Submit Feedback</button>
        </div>
    </form>
    <p><a href="<%=request.getContextPath()%>/patient_dashboard.jsp">Back to dashboard</a></p>
</div>
</body>
</html>

