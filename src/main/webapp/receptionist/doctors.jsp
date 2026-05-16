<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="Doctor.Model.Doctor" %>
<%
  String userName = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
  String userRole = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "Super Admin";
  String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

  int totalDoctors = (request.getAttribute("totalDoctors") != null) ? (Integer) request.getAttribute("totalDoctors") : 0;
  int activeToday  = (request.getAttribute("activeToday")  != null) ? (Integer) request.getAttribute("activeToday")  : 0;
  int onLeave      = (request.getAttribute("onLeave")      != null) ? (Integer) request.getAttribute("onLeave")      : 0;

  List<Doctor> doctorsList = null;
  Object obj = request.getAttribute("doctorsList");
  if (obj != null) { doctorsList = (List<Doctor>) obj; }

  String errorMessage = (String) request.getAttribute("errorMessage");
  String errorClass   = (String) request.getAttribute("errorClass");
  String successParam = request.getParameter("success");
  String errorParam   = request.getParameter("error");
%>
<html lang="en">
<head>
    <title>Doctors — Upachaar</title>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary":            "#0052FF",
                        "brand-blue":         "#0052FF",
                        "mint":               "#70C1B3",
                        "off-white":          "#F7FAFA",
                        "pending-blue":       "#3b82f6",
                        "outstanding-orange": "#f59e0b",
                    },
                    fontFamily: {
                        "display": ["Inter", "sans-serif"],
                        "sans":    ["Inter", "sans-serif"],
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg":  "0.5rem",
                        "xl":  "1rem",
                        "2xl": "1.5rem",
                    },
                },
            },
        }
    </script>

    <style type="text/tailwindcss">
        :root { --sidebar-width: 260px; }
        body  { background-color: #F7FAFA; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        .page-fade { animation: fadeUp .22s ease both; }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 99px; }
    </style>
</head>

<body class="font-display text-slate-900 antialiased">
<div class="flex h-screen w-full overflow-hidden">

    <aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 flex-shrink-0">
        <div class="px-8 mb-10">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Front Desk Suite</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1 overflow-y-auto px-0">
            <a href="dashboard.jsp" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 0">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <a href="doctors.jsp" class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">medical_services</span>
                <span class="text-sm font-medium">Doctors</span>
            </a>
            <a href="patients.jsp" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 0">groups</span>
                <span class="text-sm font-medium">Patients</span>
            </a>
            <a href="appointments.jsp" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 0">calendar_month</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
        </nav>
        <div class="mt-auto p-8 border-t border-white/10">
            <div class="flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-white/20 ring-2 ring-white/30 flex items-center justify-center text-white font-bold text-base flex-shrink-0">PS</div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-white truncate">Priya Singh</p>
                    <p class="text-xs text-white/60 truncate font-medium uppercase tracking-wider">Lead Receptionist</p>
                </div>
                <button class="text-white/60 hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[20px]">logout</span>
                </button>
            </div>
        </div>
    </aside>

    <main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-20 shrink-0 px-10 flex items-center justify-between bg-white border-b border-slate-100 shadow-sm">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Doctors Roster</h1>
            <p class="text-sm text-slate-500">Manage schedules and availability</p>
        </div>
        <div class="flex items-center gap-6">
            <button class="relative text-slate-400 hover:text-slate-600 transition-colors">
                <span class="material-symbols-outlined text-[28px]">notifications</span>
                <span class="absolute top-0 right-0 size-2 bg-red-500 rounded-full border-2 border-white"></span>
            </button>
            <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                <div class="text-right">
                    <p class="text-sm font-bold text-slate-900 leading-none">Priya Singh</p>
                    <p class="text-xs text-slate-500 mt-0.5">Lead Receptionist</p>
                </div>
                <div class="size-10 rounded-full bg-blue-50 flex items-center justify-center text-[#0052FF] font-bold text-sm">PS</div>
            </div>
        </div>
    </header>

        <div class="flex-1 overflow-y-auto px-10 pb-10">
            <div class="page-fade">
                <style>
                  .alert { padding:12px 16px;border-radius:8px;margin-bottom:24px;display:flex;align-items:center;gap:12px;font-size:14px;font-weight:500;animation:fadeIn .3s ease; }
                  @keyframes fadeIn { from{opacity:0;transform:translateY(-10px)} to{opacity:1;transform:translateY(0)} }
                  .alert-success { background:#ecfdf5;color:#065f46;border:1px solid #a7f3d0; }
                  .alert-error   { background:#fef2f2;color:#991b1b;border:1px solid #fecaca; }
                  .error-banner  { background:#fee2e2;color:#991b1b;border:1px solid #fca5a5;border-radius:8px;padding:12px 20px;margin-bottom:20px;font-size:13px; }
                  .stats-grid { display:grid;grid-template-columns:repeat(3,1fr);gap:24px;margin-bottom:24px; }
                  .stat-card  { background:white;border:1px solid #e5e7eb;border-radius:12px;padding:24px;position:relative;overflow:hidden;height:120px;display:flex;flex-direction:column;justify-content:center; }
                  .stat-title { font-size:12px;font-weight:600;color:#6b7280;text-transform:uppercase;letter-spacing:.5px;margin-bottom:12px;position:relative;z-index:2; }
                  .stat-value-row { display:flex;align-items:baseline;gap:8px;position:relative;z-index:2; }
                  .stat-num   { font-size:28px;font-weight:700;color:#111827; }
                  .stat-label { font-size:13px;color:#6b7280; }
                  .badge-available { background:#d1fae5;color:#065f46;padding:4px 10px;border-radius:12px;font-size:11px;font-weight:600; }
                  .bg-shape   { position:absolute;right:-20%;top:-20%;width:150px;height:150px;border-radius:50%;z-index:1; }
                  .shape-blue   { background:#f0f4ff; } .shape-green  { background:#ecfdf5; } .shape-orange { background:#fff7ed; }
                  .table-container { background:white;border:1px solid #e5e7eb;border-radius:12px;overflow:hidden; }
                  .data-table { width:100%;border-collapse:collapse;text-align:left; }
                  .data-table th { background:#e2f1ec;padding:16px 24px;font-size:12px;font-weight:700;color:#0b6b59;text-transform:uppercase;letter-spacing:.5px; }
                  .data-table td { padding:16px 24px;font-size:14px;color:#111827;border-bottom:1px solid #e5e7eb; }
                  .empty-state { text-align:center;padding:60px 20px !important;color:#6b7280;font-size:14px; }
                  .btn-view   { background:#0d7f6b;color:white;border:none;padding:6px 12px;border-radius:6px;font-size:12px;cursor:pointer;transition:opacity .2s; }
                  .btn-view:hover { opacity:.9; }
                  .btn-delete { background:#ef4444;color:white;border:none;padding:6px 12px;border-radius:6px;font-size:12px;cursor:pointer;text-decoration:none;display:inline-block;margin-left:8px;transition:opacity .2s; }
                  .btn-delete:hover { opacity:.9; }
                  .pagination-bar { display:flex;justify-content:space-between;align-items:center;padding:16px 24px;border-top:1px solid #e5e7eb; }
                  .pagination-info { font-size:13px;color:#6b7280; }
                  .pagination-controls { display:flex;align-items:center;gap:8px; }
                  .page-btn { width:32px;height:32px;display:flex;align-items:center;justify-content:center;border:none;background:transparent;border-radius:4px;color:#6b7280;cursor:pointer;font-size:14px; }
                  .page-btn.active { background:#0d7f6b;color:white; }
                  .modal-overlay { position:fixed;inset:0;background:rgba(17,24,39,.6);display:flex;justify-content:center;align-items:center;z-index:1000;opacity:0;visibility:hidden;transition:all .3s ease; }
                  .modal-overlay.active { opacity:1;visibility:visible; }
                  .modal-card { background:white;width:100%;max-width:550px;border-radius:12px;box-shadow:0 20px 25px -5px rgba(0,0,0,.1);transform:translateY(-20px);transition:transform .3s ease;overflow:hidden; }
                  .modal-overlay.active .modal-card { transform:translateY(0); }
                  .modal-header { padding:20px 24px;border-bottom:1px solid #e5e7eb;display:flex;justify-content:space-between;align-items:center;background:#f8fafc; }
                  .modal-header h3 { font-size:18px;font-weight:700;color:#111827; }
                  .btn-close { background:none;border:none;font-size:20px;color:#6b7280;cursor:pointer;transition:color .2s; }
                  .btn-close:hover { color:#ef4444; }
                  .modal-body { padding:24px; }
                  .modal-profile-header { display:flex;align-items:center;gap:16px;margin-bottom:24px;padding-bottom:20px;border-bottom:1px solid #e5e7eb; }
                  .modal-avatar { width:64px;height:64px;background:#e2f1ec;color:#0d7f6b;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:24px;font-weight:700;text-transform:uppercase; }
                  .modal-info h4 { font-size:18px;font-weight:700;color:#111827;margin-bottom:4px; }
                  .modal-info p  { font-size:13px;color:#6b7280;margin-bottom:8px; }
                  .modal-grid { display:grid;grid-template-columns:1fr 1fr;gap:20px; }
                  .modal-item label { display:block;font-size:12px;color:#6b7280;text-transform:uppercase;font-weight:600;margin-bottom:4px; }
                  .modal-item p { font-size:14px;color:#111827;font-weight:500; }
                </style>
                <div class="mt-6">
                <% if (errorMessage != null) { %>
                <div class="error-banner"><strong>Database Error:</strong> [<%= errorClass %>] <%= errorMessage %></div>
                <% } %>
                <% if ("deleted".equals(successParam)) { %>
                <div class="alert alert-success" id="alertBox"><i class="fa-solid fa-circle-check"></i> Doctor has been successfully removed from the system.</div>
                <% } else if (errorParam != null) { %>
                <div class="alert alert-error" id="alertBox"><i class="fa-solid fa-circle-exclamation"></i>
                    <% if ("not_found".equals(errorParam)) { %>Error: Doctor not found.
                    <% } else if ("delete_failed".equals(errorParam)) { %>Error: Could not delete doctor. Ensure no active appointments exist.
                    <% } else { %>An unexpected error occurred.<% } %>
                </div>
                <% } %>

                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-title">TOTAL DOCTORS</div><div class="stat-value-row"><span class="stat-num"><%= totalDoctors %></span><span class="stat-label">registered</span></div><div class="bg-shape shape-blue"></div></div>
                    <div class="stat-card"><div class="stat-title">ACTIVE TODAY</div><div class="stat-value-row"><span class="stat-num"><%= activeToday %></span><span class="badge-available">Available</span></div><div class="bg-shape shape-green"></div></div>
                    <div class="stat-card"><div class="stat-title">ON LEAVE</div><div class="stat-value-row"><span class="stat-num"><%= onLeave %></span><i class="fa-regular fa-calendar-days"></i></div><div class="bg-shape shape-orange"></div></div>
                </div>

                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr><th>DOCTOR ID</th><th>NAME</th><th>SPECIALTY</th><th>EXPERIENCE</th><th>STATUS</th><th>ACTIONS</th></tr>
                        </thead>
                        <tbody>
                        <% if (doctorsList == null || doctorsList.isEmpty()) { %>
                            <tr><td colspan="6" class="empty-state">No doctors found.</td></tr>
                        <% } else { for (Doctor doc : doctorsList) {
                            String status = doc.getStatus(); %>
                            <tr>
                                <td><%= doc.getUserId() %></td>
                                <td><%= doc.getUser() != null ? doc.getUser().getName() : "—" %></td>
                                <td><%= doc.getDepartment() != null ? doc.getDepartment() : "—" %></td>
                                <td><%= doc.getExperienceYears() %> yrs</td>
                                <td>
                                    <% if ("active".equalsIgnoreCase(status)) { %>
                                        <span style="background:#d1fae5;color:#065f46;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Active</span>
                                    <% } else if ("on leave".equalsIgnoreCase(status)) { %>
                                        <span style="background:#fee2e2;color:#991b1b;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">On Leave</span>
                                    <% } else { %>
                                        <span style="background:#e5e7eb;color:#374151;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Unknown</span>
                                    <% } %>
                                </td>
                                <td>
                                    <button type="button" class="btn-view" onclick="openDoctorModal(this)"
                                        data-id="<%= doc.getUserId() %>"
                                        data-name="<%= doc.getUser() != null ? doc.getUser().getName() : "—" %>"
                                        data-department="<%= doc.getDepartment() != null ? doc.getDepartment() : "—" %>"
                                        data-experience="<%= doc.getExperienceYears() %>"
                                        data-status="<%= doc.getStatus() != null ? doc.getStatus() : "—" %>"
                                        data-qualifications="<%= doc.getQualifications() != null ? doc.getQualifications() : "—" %>"
                                        data-phone="<%= doc.getUser() != null ? doc.getUser().getPhone() : "—" %>"
                                        data-email="<%= doc.getUser() != null ? doc.getUser().getEmail() : "—" %>"
                                        data-gender="<%= doc.getUser() != null ? doc.getUser().getGender() : "—" %>">View</button>
                                    <a href="deleteDoctor?id=<%= doc.getUserId() %>" class="btn-delete"
                                        onclick="return confirm('Delete this doctor?')">Delete</a>
                                </td>
                            </tr>
                        <% } } %>
                        </tbody>
                    </table>
                    <div class="pagination-bar">
                        <div class="pagination-info">Showing <%= (totalDoctors > 0) ? "1" : "0" %>–<%= Math.min(10, totalDoctors) %> of <%= totalDoctors %> doctors</div>
                        <div class="pagination-controls">
                            <button class="page-btn"><i class="fa-solid fa-chevron-left"></i></button>
                            <button class="page-btn active">1</button>
                            <button class="page-btn"><i class="fa-solid fa-chevron-right"></i></button>
                        </div>
                    </div>
                </div>
                </div>

                <!-- Doctor Modal -->
                <div class="modal-overlay" id="viewModal">
                    <div class="modal-card">
                        <div class="modal-header">
                            <h3>Doctor Profile</h3>
                            <button class="btn-close" onclick="closeDoctorModal()"><i class="fa-solid fa-xmark"></i></button>
                        </div>
                        <div class="modal-body">
                            <div class="modal-profile-header">
                                <div class="modal-avatar" id="modalAvatar">D</div>
                                <div class="modal-info">
                                    <h4 id="modalDocName">Name</h4>
                                    <p id="modalDocDepartment">Department</p>
                                    <span class="badge-available" id="modalDocStatus" style="display:inline-block;">Active</span>
                                </div>
                            </div>
                            <div class="modal-grid">
                                <div class="modal-item"><label>Doctor ID</label><p id="modalDocId">-</p></div>
                                <div class="modal-item"><label>Experience</label><p id="modalDocExp">-</p></div>
                                <div class="modal-item" style="grid-column:span 2;"><label>Qualifications</label><p id="modalDocQual">-</p></div>
                                <div class="modal-item"><label>Phone</label><p id="modalDocPhone">-</p></div>
                                <div class="modal-item"><label>Email</label><p id="modalDocEmail">-</p></div>
                                <div class="modal-item"><label>Gender</label><p id="modalDocGender" style="text-transform:capitalize;">-</p></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="fixed bottom-6 right-6 z-50 flex flex-col gap-3 pointer-events-none" id="toast-container"></div>

<script>
    const COLORS = ['#0052FF','#70C1B3','#f59e0b','#f43f5e','#8B5CF6','#3b82f6','#EC4899'];
    function initials(n){ return n.split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }
    function avatarColor(n){ let h=0; for(let c of n) h=c.charCodeAt(0)+((h<<5)-h); return COLORS[Math.abs(h)%COLORS.length]; }

    function toast(msg) {
        const c = document.getElementById('toast-container');
        const el = document.createElement('div');
        el.className = 'flex items-center gap-3 bg-slate-900 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-medium border-l-4 border-[#0052FF] pointer-events-auto';
        el.innerHTML = `<span class="material-symbols-outlined text-[#0052FF] text-[18px]">check_circle</span><span>${msg}</span>`;
        c.appendChild(el);
        setTimeout(() => el.remove(), 3500);
    }

    // Auto-dismiss alert
    const alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition='opacity .5s'; alertBox.style.opacity='0'; setTimeout(()=>alertBox.remove(),500); }, 4000);
    }

    function openDoctorModal(btn) {
        const name   = btn.dataset.name || 'N/A';
        const status = btn.dataset.status || '';
        document.getElementById('modalAvatar').innerText       = name.charAt(0).toUpperCase();
        document.getElementById('modalDocName').innerText      = name;
        document.getElementById('modalDocId').innerText        = btn.dataset.id || 'N/A';
        document.getElementById('modalDocDepartment').innerText= btn.dataset.department || 'N/A';
        document.getElementById('modalDocExp').innerText       = (btn.dataset.experience || '0') + ' Years';
        document.getElementById('modalDocQual').innerText      = btn.dataset.qualifications || 'N/A';
        document.getElementById('modalDocPhone').innerText     = btn.dataset.phone || 'N/A';
        document.getElementById('modalDocEmail').innerText     = btn.dataset.email || 'N/A';
        document.getElementById('modalDocGender').innerText    = btn.dataset.gender || 'N/A';
        const badge = document.getElementById('modalDocStatus');
        if (status.toLowerCase() === 'active') { badge.innerText='Active'; badge.style.background='#d1fae5'; badge.style.color='#065f46'; }
        else if (status.toLowerCase() === 'on leave') { badge.innerText='On Leave'; badge.style.background='#fee2e2'; badge.style.color='#991b1b'; }
        else { badge.innerText=status; badge.style.background='#e5e7eb'; badge.style.color='#374151'; }
        document.getElementById('viewModal').classList.add('active');
    }
    function closeDoctorModal() { document.getElementById('viewModal').classList.remove('active'); }
    document.getElementById('viewModal').addEventListener('click', e => { if(e.target===document.getElementById('viewModal')) closeDoctorModal(); });
</script>
</body>
</html>