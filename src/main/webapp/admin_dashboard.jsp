<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
<h1>Admin Dashboard</h1>
<p>Welcome, admin. Manage ratings and feedback from here.</p>
<ul>
    <li><a href="${pageContext.request.contextPath}/ratings">Manage Ratings</a></li>
    <li><a href="${pageContext.request.contextPath}/ViewFeedbackServlet">View Feedback</a></li>
    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
</ul>
</body>
</html>

