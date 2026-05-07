<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Rating Portal — Upachar</title>
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
                    <span>Upachar<small>Patient Rating Portal</small></span>
                </a>

                <nav class="top-links" aria-label="Primary navigation">
                    <a class="active" href="${pageContext.request.contextPath}/">Home</a>
                    <a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
                    <a href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
                    <a href="${pageContext.request.contextPath}/DoctorRatingServlet">Doctor Search</a>
                </nav>
            </div>
        </header>

        <main class="container">
            <section class="hero-banner">
                <div class="hero-card home-hero">
                    <div class="hero-copy">
                        <span class="eyebrow">Patient feedback hub</span>
                        <h1>Modern rating workflow for a better healthcare experience.</h1>
                        <p>
                            Collect feedback, review doctor performance, and manage patient ratings through a polished interface
                            that keeps every action clear and easy to find.
                        </p>

                        <div class="hero-actions">
                            <a class="btn" href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add a Rating</a>
                            <a class="btn ghost" href="${pageContext.request.contextPath}/ViewRatingServlet">Browse Ratings</a>
                        </div>

                        <div class="chip-list" aria-label="Highlights">
                            <span class="chip">Fast feedback entry</span>
                            <span class="chip">Doctor-wise search</span>
                            <span class="chip">Edit and delete support</span>
                        </div>
                    </div>

                    <aside class="hero-aside">
                        <div>
                            <div class="status-pill"><span class="dot online"></span> System Online</div>
                            <h3 class="aside-title">Portal snapshot</h3>
                            <p class="aside-copy">
                                Simple actions, clear navigation, and a unified interface across all rating pages.
                            </p>
                        </div>

                        <div class="aside-list">
                            <div class="aside-item"><span>Active doctors</span><strong>50+</strong></div>
                            <div class="aside-item"><span>Feedback received</span><strong>1.2K</strong></div>
                            <div class="aside-item"><span>Average score</span><strong>4.8/5</strong></div>
                        </div>

                        <div class="hero-side-note">
                            <strong>Designed for clarity</strong>
                            <span>Every action is just one click away.</span>
                        </div>
                    </aside>
                </div>
            </section>

            <section class="section">
                <div class="section-header">
                    <div>
                        <h2>Key Metrics</h2>
                        <p>High-level view of portal activity.</p>
                    </div>
                </div>

                <div class="metric-grid">
                    <div class="metric-card">
                        <div class="metric-icon">👥</div>
                        <div>
                            <div class="metric-label">Patients served</div>
                            <div class="metric-value">1,240</div>
                        </div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-icon">⭐</div>
                        <div>
                            <div class="metric-label">Ratings this month</div>
                            <div class="metric-value">356</div>
                        </div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-icon">🏥</div>
                        <div>
                            <div class="metric-label">Doctor records</div>
                            <div class="metric-value">50+</div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="section">
                <div class="section-header">
                    <div>
                        <h2>Main Actions</h2>
                        <p>Quick access to the core workflows.</p>
                    </div>
                </div>

                <div class="feature-grid">
                    <article class="feature-card">
                        <div class="feature-icon">➕</div>
                        <h3>Add Rating</h3>
                        <p>Submit patient feedback in a clean, guided form designed for quick data entry.</p>
                        <div class="actions">
                            <a class="btn small" href="${pageContext.request.contextPath}/AddRatingServlet">Open Form</a>
                            <a class="btn secondary small" href="${pageContext.request.contextPath}/rating/add-rating.jsp">Direct JSP</a>
                        </div>
                    </article>

                    <article class="feature-card">
                        <div class="feature-icon">📋</div>
                        <h3>View Ratings</h3>
                        <p>Browse, update, and manage submitted ratings in a structured list view.</p>
                        <div class="actions">
                            <a class="btn small" href="${pageContext.request.contextPath}/ViewRatingServlet">Open List</a>
                        </div>
                    </article>

                    <article class="feature-card">
                        <div class="feature-icon">🔎</div>
                        <h3>Doctor Search</h3>
                        <p>Filter ratings by doctor ID and review patient feedback in context.</p>
                        <form action="${pageContext.request.contextPath}/DoctorRatingServlet" method="get" class="form-stack">
                            <div>
                                <label for="doctorId">Doctor ID</label>
                                <input id="doctorId" name="doctorId" type="number" min="1" placeholder="Enter doctor ID" required>
                            </div>
                            <button type="submit" class="btn small">Search</button>
                        </form>
                    </article>
                </div>
            </section>

            <section class="section">
                <div class="section-header">
                    <div>
                        <h2>How it works</h2>
                        <p>A simple flow for users and staff.</p>
                    </div>
                </div>

                <div class="workflow-grid">
                    <article class="workflow-card">
                        <span class="workflow-index">01</span>
                        <h3>Capture feedback</h3>
                        <p>Enter patient, doctor, appointment, score, and review details in one place.</p>
                    </article>

                    <article class="workflow-card">
                        <span class="workflow-index">02</span>
                        <h3>Review ratings</h3>
                        <p>See all submitted ratings with clear actions for updates and removal.</p>
                    </article>

                    <article class="workflow-card">
                        <span class="workflow-index">03</span>
                        <h3>Search by doctor</h3>
                        <p>Filter entries quickly to analyze feedback for a single doctor.</p>
                    </article>
                </div>
            </section>

            <section class="section">
                <div class="section-header">
                    <div>
                        <h2>Quick Navigation</h2>
                        <p>Fast links to the core portal pages.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="quick-links">
                        <a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating Page</a>
                        <a href="${pageContext.request.contextPath}/ViewRatingServlet">All Ratings</a>
                        <a href="${pageContext.request.contextPath}/DoctorRatingServlet">Doctor Ratings</a>
                    </div>
                </div>
            </section>
        </main>

        <footer class="footer container">
            &copy; <span id="year"></span> Upachar — Patient Rating Portal.
        </footer>
    </div>
</div>

<script>
    document.getElementById('year').textContent = new Date().getFullYear();
</script>

</body>
</html>