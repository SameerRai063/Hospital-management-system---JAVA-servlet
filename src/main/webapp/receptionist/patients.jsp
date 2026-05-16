<!DOCTYPE html>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String userName    = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
    String userRole    = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "Super Admin";
    String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));
    int    totalPatients = (request.getAttribute("totalPatients") != null) ? (Integer) request.getAttribute("totalPatients") : 0;
    String errorMessage  = (String) request.getAttribute("errorMessage");
%>
<html lang="en">
<head>
    <title>Patients — Upachaar</title>
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
            <a href="doctors.jsp" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 0">medical_services</span>
                <span class="text-sm font-medium">Doctors</span>
            </a>
            <a href="patients.jsp" class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">groups</span>
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
            <h1 class="text-2xl font-bold text-slate-900">Patient Directory</h1>
            <p class="text-sm text-slate-500">View and update patient records</p>
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
                  .toast { display:flex;align-items:center;gap:10px;padding:12px 18px;border-radius:8px;font-size:13px;font-weight:500;margin:16px 0;animation:fadeOut .5s ease 3.5s forwards; }
                  .toast-success { background:#d1fae5;color:#065f46;border:1px solid #6ee7b7; }
                  .toast-error   { background:#fee2e2;color:#991b1b;border:1px solid #fca5a5; }
                  @keyframes fadeOut { to{opacity:0;height:0;padding:0;margin:0;overflow:hidden;} }
                  .table-container { background:white;border:1px solid #e5e7eb;border-radius:12px;overflow:hidden;margin-top:24px; }
                  .data-table { width:100%;border-collapse:collapse;text-align:left; }
                  .data-table th { background:#e2f1ec;padding:16px 24px;font-size:12px;font-weight:700;color:#0b6b59;text-transform:uppercase;letter-spacing:.5px; }
                  .data-table td { padding:16px 24px;font-size:14px;color:#111827;border-bottom:1px solid #e5e7eb; }
                  .action-buttons { display:flex;gap:8px;align-items:center; }
                  .btn-view   { background:#0d7f6b;color:white;border:none;padding:6px 12px;border-radius:6px;font-size:12px;font-weight:500;cursor:pointer;display:flex;align-items:center;gap:5px;text-decoration:none;transition:background .2s; }
                  .btn-delete { background:#fee2e2;color:#991b1b;border:none;padding:6px 12px;border-radius:6px;font-size:12px;font-weight:500;cursor:pointer;display:flex;align-items:center;gap:5px;text-decoration:none;transition:background .2s; }
                  .modal-overlay { position:fixed;inset:0;background:rgba(10,15,30,.55);backdrop-filter:blur(4px);display:flex;align-items:center;justify-content:center;z-index:1000;opacity:0;pointer-events:none;transition:opacity .25s ease; }
                  .modal-overlay.active { opacity:1;pointer-events:all; }
                  .modal-card { background:white;border-radius:16px;width:560px;max-width:95vw;box-shadow:0 24px 60px rgba(0,0,0,.18);overflow:hidden;transform:translateY(20px) scale(.97);transition:transform .28s cubic-bezier(.34,1.56,.64,1); }
                  .modal-overlay.active .modal-card { transform:translateY(0) scale(1); }
                  .modal-header { background:linear-gradient(135deg,#0d7f6b 0%,#0a5f51 100%);padding:24px 28px;display:flex;align-items:center;justify-content:space-between; }
                  .modal-avatar { width:56px;height:56px;border-radius:50%;background:rgba(255,255,255,.2);border:2px solid rgba(255,255,255,.4);display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:700;color:white; }
                  .modal-body { padding:24px 28px; }
                  .info-section { margin-bottom:20px; }
                  .info-section-title { font-size:10px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:#0d7f6b;margin-bottom:12px;padding-bottom:6px;border-bottom:1px solid #e5e7eb; }
                  .info-grid { display:grid;grid-template-columns:1fr 1fr;gap:12px; }
                  .info-label { font-size:11px;color:#6b7280;font-weight:500; }
                  .info-value { font-size:14px;color:#111827;font-weight:600; }
                  .modal-footer { padding:16px 28px;border-top:1px solid #e5e7eb;display:flex;justify-content:flex-end;gap:10px; }
                  .btn-close-modal { background:#f3f4f6;color:#374151;border:none;padding:8px 18px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer; }
                </style>
                <div class="mt-6">
                <c:if test="${param.success == 'deleted'}">
                    <div class="toast toast-success"><i class="fa-solid fa-circle-check"></i> Patient deleted successfully.</div>
                </c:if>
                <c:if test="${param.error == 'not_found'}">
                    <div class="toast toast-error"><i class="fa-solid fa-circle-exclamation"></i> Patient not found.</div>
                </c:if>

                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>PATIENT ID</th><th>NAME</th><th>AGE</th><th>GENDER</th><th>PHONE</th><th>BLOOD GROUP</th><th>ACTIONS</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty patientList}">
                                <tr><td colspan="7" style="text-align:center;padding:60px;">No patients found.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="patient" items="${patientList}">
                                    <c:set var="age" value="${2026 - patient.user.dob.year - 1900}" />
                                    <tr>
                                        <td>${patient.user.id}</td>
                                        <td>${patient.user.name}</td>
                                        <td>${age}</td>
                                        <td>${patient.user.gender}</td>
                                        <td>${patient.user.phone}</td>
                                        <td>${patient.bloodGroup}</td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn-view" onclick="openModal({
                                                    id:'${patient.user.id}',name:'${patient.user.name}',
                                                    gender:'${patient.user.gender}',dob:'${patient.user.dob}',
                                                    phone:'${patient.user.phone}',email:'${patient.user.email}',
                                                    address:'${patient.user.address}',bloodGroup:'${patient.bloodGroup}',
                                                    createdAt:'${patient.user.createdAt}'
                                                })"><i class="fa-solid fa-eye"></i> View</button>
                                                <a href="${pageContext.request.contextPath}/deletePatient?id=${patient.user.id}" class="btn-delete" onclick="return confirm('Are you sure?')"><i class="fa-solid fa-trash"></i> Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                </div>

                <!-- Patient Modal -->
                <div class="modal-overlay" id="patientModal" onclick="handleOverlayClick(event)">
                    <div class="modal-card">
                        <div class="modal-header">
                            <div style="display:flex;align-items:center;gap:16px;">
                                <div class="modal-avatar" id="modalAvatar">P</div>
                                <div style="color:white;font-weight:700;" id="modalPatName">—</div>
                            </div>
                            <button style="background:none;border:none;color:white;cursor:pointer;" onclick="closeModal()"><i class="fa-solid fa-xmark"></i></button>
                        </div>
                        <div class="modal-body">
                            <div class="info-section">
                                <div class="info-section-title">Personal Information</div>
                                <div class="info-grid">
                                    <div><div class="info-label">ID</div><div id="modalPatId" class="info-value"></div></div>
                                    <div><div class="info-label">Gender</div><div id="modalPatGender" class="info-value"></div></div>
                                    <div><div class="info-label">Phone</div><div id="modalPatPhone" class="info-value"></div></div>
                                    <div><div class="info-label">Blood Group</div><div id="modalPatBlood" class="info-value"></div></div>
                                    <div style="grid-column:span 2;"><div class="info-label">Email</div><div id="modalPatEmail" class="info-value"></div></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn-close-modal" onclick="closeModal()">Close</button>
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

    const patientModal = document.getElementById('patientModal');
    function openModal(p) {
        document.getElementById('modalPatName').textContent   = p.name || '—';
        document.getElementById('modalPatId').textContent     = p.id || '—';
        document.getElementById('modalPatGender').textContent = p.gender || '—';
        document.getElementById('modalPatPhone').textContent  = p.phone || '—';
        document.getElementById('modalPatBlood').textContent  = p.bloodGroup || '—';
        document.getElementById('modalPatEmail').textContent  = p.email || '—';
        document.getElementById('modalAvatar').textContent    = (p.name || 'P').charAt(0).toUpperCase();
        patientModal.classList.add('active');
    }
    function closeModal() { patientModal.classList.remove('active'); }
    function handleOverlayClick(e) { if(e.target===patientModal) closeModal(); }
</script>
</body>
</html>