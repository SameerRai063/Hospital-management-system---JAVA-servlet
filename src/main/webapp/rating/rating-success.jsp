<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Rating Status — Upachar</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
<div class="site">
	<div class="page-shell">
		<header class="topbar">
			<div class="topbar-inner container">
				<a class="brand" href="${pageContext.request.contextPath}/">
					<span class="brand-mark"></span>
					<span>Status<small>Action complete</small></span>
				</a>
				<nav class="top-links">
					<a href="${pageContext.request.contextPath}/">Home</a>
					<a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
					<a href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
				</nav>
			</div>
		</header>

		<main class="container">
			<section class="hero-banner">
				<div class="success-card">
					<div class="success-icon">
						<svg width="34" height="34" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M20 7L10 17l-5-5" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
						</svg>
					</div>
					<div>
						<h1>${param.message != null ? param.message : 'Completed successfully'}</h1>
						<p>Your action has been processed. You can add another rating or return to the list to continue managing feedback.</p>
					</div>
				</div>
			</section>

			<section class="section">
				<div class="feature-grid">
					<article class="feature-card">
						<div class="feature-icon">➕</div>
						<h3>Add Another Rating</h3>
						<p>Capture more feedback entries right away using the same consistent form.</p>
						<div class="actions">
							<a class="btn" href="${pageContext.request.contextPath}/AddRatingServlet">Open Form</a>
						</div>
					</article>

					<article class="feature-card">
						<div class="feature-icon">📋</div>
						<h3>Review Ratings</h3>
						<p>Check the current list, edit entries, or remove outdated records.</p>
						<div class="actions">
							<a class="btn secondary" href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
						</div>
					</article>

					<article class="feature-card">
						<div class="feature-icon">🏠</div>
						<h3>Return Home</h3>
						<p>Go back to the landing page for a full view of the portal’s core actions.</p>
						<div class="actions">
							<a class="btn ghost" href="${pageContext.request.contextPath}/">Home</a>
						</div>
					</article>
				</div>
			</section>
		</main>

		<footer class="footer container">
			<div class="link-row">
				<a href="${pageContext.request.contextPath}/">Home</a>
				<a href="${pageContext.request.contextPath}/ViewRatingServlet">All Ratings</a>
				<a href="${pageContext.request.contextPath}/DoctorRatingServlet">Doctor Search</a>
			</div>
		</footer>
	</div>
</div>

</body>
</html>

