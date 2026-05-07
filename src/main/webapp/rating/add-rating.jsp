<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Add Rating — Upachar</title>
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
					<span>Add Rating<small>Patient feedback form</small></span>
				</a>
				<nav class="top-links">
					<a href="${pageContext.request.contextPath}/">Home</a>
					<a class="active" href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
					<a href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
				</nav>
			</div>
		</header>

		<main class="container">
			<section class="hero-banner">
				<div class="hero-card">
					<div class="hero-copy">
						<span class="eyebrow">Feedback intake</span>
						<h1>Capture a patient rating in a clean, guided flow.</h1>
						<p>Use the form to record appointment feedback, score the visit, and leave optional notes for the care team.</p>
					</div>

					<aside class="hero-aside">
						<div>
							<h3 class="aside-title">What to include</h3>
							<p style="margin:0;color:rgba(255,255,255,.82);line-height:1.7;">Patient ID, doctor ID, appointment ID, score, and a short review help create actionable feedback.</p>
						</div>
						<div class="aside-list">
							<div class="aside-item"><span>Score range</span><strong>1 - 5</strong></div>
							<div class="aside-item"><span>Review field</span><strong>Optional</strong></div>
							<div class="aside-item"><span>Output</span><strong>Saved instantly</strong></div>
						</div>
					</aside>
				</div>
			</section>

			<section class="section">
				<div class="form-layout">
					<section class="panel">
						<div class="panel-header">
							<div>
								<h2>Rating Details</h2>
								<p>Fill in the patient and doctor details below.</p>
							</div>
						</div>

						<form action="${pageContext.request.contextPath}/AddRatingServlet" method="post" class="form-stack">
							<div class="form-layout two-col">
								<div>
									<label for="patientId">Patient ID</label>
									<input id="patientId" type="number" name="patientId" min="1" placeholder="Enter patient ID" required>
								</div>
								<div>
									<label for="doctorId">Doctor ID</label>
									<input id="doctorId" type="number" name="doctorId" min="1" placeholder="Enter doctor ID" required>
								</div>
							</div>

							<div class="form-layout two-col">
								<div>
									<label for="appointmentId">Appointment ID</label>
									<input id="appointmentId" type="number" name="appointmentId" min="1" placeholder="Enter appointment ID" required>
								</div>
								<div>
									<label for="score">Score</label>
									<input id="score" type="number" name="score" min="1" max="5" placeholder="1 to 5" required>
								</div>
							</div>

							<div>
								<label for="review">Review</label>
								<textarea id="review" name="review" placeholder="Add optional patient feedback"></textarea>
							</div>

							<div class="actions">
								<button type="submit" class="btn">Submit Rating</button>
								<a class="btn secondary" href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
								<a class="btn ghost" href="${pageContext.request.contextPath}/">Back Home</a>
							</div>
						</form>
					</section>

					<aside class="sidebar-card">
						<h3 style="margin-top:0;">Quick Guidance</h3>
						<div class="summary-list">
							<div class="summary-line"><span>Make the score honest</span><strong>Clear feedback</strong></div>
							<div class="summary-line"><span>Keep the review concise</span><strong>1 - 3 lines</strong></div>
							<div class="summary-line"><span>Use valid IDs</span><strong>Numeric only</strong></div>
						</div>
					</aside>
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

