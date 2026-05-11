<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Patient Dashboard</title>
</head>
<body>
<h1>Patient Dashboard</h1>
<p>Welcome, this is your patient dashboard. Use the links below to navigate to ratings and feedback features.</p>
<ul>
    <li><a href="${pageContext.request.contextPath}/ratings">My Ratings</a></li>
    <li><a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a></li>
    <li><a href="${pageContext.request.contextPath}/feedback/add-feedback.jsp">Leave Feedback</a></li>
    <li><a href="${pageContext.request.contextPath}/ratings">View Ratings</a></li>
    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
</ul>
</body>
</html>

