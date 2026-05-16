<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="en">
<head>
    <title>Appointments — Upachaar</title>
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
            <a href="patients.jsp" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 0">groups</span>
                <span class="text-sm font-medium">Patients</span>
            </a>
            <a href="appointments.jsp" class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">calendar_month</span>
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
            <h1 class="text-2xl font-bold text-slate-900">Master Schedule</h1>
            <p class="text-sm text-slate-500">Manage and track all clinic visits</p>
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
                  .btn-view   { display:inline-block;padding:6px 14px;background:#2554ff;color:white;border:none;border-radius:6px;font-size:13px;font-weight:600;margin-right:8px;cursor:pointer;transition:.2s; }
                  .btn-view:hover { background:#1d46d8; }
                  .btn-delete { display:inline-block;padding:6px 14px;background:#dc2626;color:white;text-decoration:none;border-radius:6px;font-size:13px;font-weight:600;transition:.2s; }
                  .btn-delete:hover { background:#b91c1c; }
                  .stats-grid { display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:32px; }
                  .stat-card  { background:white;border:1px solid #e5e7eb;border-radius:12px;padding:24px; }
                  .stat-info h3 { font-size:12px;font-weight:600;color:#6b7280;text-transform:uppercase;margin-bottom:12px; }
                  .stat-info .value { font-size:28px;font-weight:700;color:#111827; }
                  .table-container { background:white;border:1px solid #e5e7eb;border-radius:12px;overflow:hidden; }
                  .data-table { width:100%;border-collapse:collapse;text-align:left; }
                  .data-table th { background:#e2f1ec;padding:16px 24px;font-size:12px;font-weight:700;color:#0b6b59;text-transform:uppercase; }
                  .data-table td { padding:16px 24px;font-size:14px;border-bottom:1px solid #e5e7eb; }
                  .empty-state { text-align:center;padding:40px !important;color:#6b7280; }
                </style>
                <div class="mt-6">
                    <div class="stats-grid">
                        <div class="stat-card"><div class="stat-info"><h3>TOTAL APPOINTMENTS</h3><div class="value">${not empty totalAppointments ? totalAppointments : 0}</div></div></div>
                        <div class="stat-card" style="background:#f0fdfa;"><div class="stat-info"><h3>APPOINTMENTS TODAY</h3><div class="value">${not empty appointmentsToday ? appointmentsToday : 0}</div></div></div>
                        <div class="stat-card" style="background:#f0fdf4;"><div class="stat-info"><h3>COMPLETED</h3><div class="value">${not empty completedAppointments ? completedAppointments : 0}</div></div></div>
                    </div>

                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th><th>PATIENT</th><th>DOCTOR</th><th>DEPARTMENT</th><th>DATE &amp; TIME</th><th>STATUS</th><th>ACTIONS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty appointmentList}">
                                        <tr><td colspan="7" class="empty-state">No appointments found</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="appointment" items="${appointmentList}">
                                            <tr>
                                                <td>${appointment.id}</td>
                                                <td>${appointment.patientName}</td>
                                                <td>${appointment.doctorName}</td>
                                                <td>${appointment.department}</td>
                                                <td>${appointment.appointmentDate}</td>
                                                <td>${appointment.status}</td>
                                                <td>
                                                    <button type="button" class="btn-view"
                                                        onclick="openAppointmentModal('${appointment.id}','${appointment.patientName}','${appointment.doctorName}','${appointment.department}','${appointment.appointmentDate}','${appointment.appointmentTime}','${appointment.status}','${appointment.reason}')">
                                                        View
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/deleteAppointment?id=${appointment.id}" class="btn-delete"
                                                        onclick="return confirm('Delete appointment ${appointment.id}?')">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Modal -->
                <div id="appointmentModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;justify-content:center;align-items:center;">
                    <div style="background:white;width:500px;max-width:90%;border-radius:12px;padding:30px;position:relative;box-shadow:0 10px 30px rgba(0,0,0,.2);">
                        <button onclick="closeAppointmentModal()" style="position:absolute;top:15px;right:15px;border:none;background:none;font-size:20px;cursor:pointer;">×</button>
                        <h2 style="margin-bottom:20px;color:#2554ff;">Appointment Details</h2>
                        <div style="display:flex;flex-direction:column;gap:14px;">
                            <div><strong>ID:</strong> <span id="modalApptId"></span></div>
                            <div><strong>Patient:</strong> <span id="modalApptPatient"></span></div>
                            <div><strong>Doctor:</strong> <span id="modalApptDoctor"></span></div>
                            <div><strong>Department:</strong> <span id="modalApptDept"></span></div>
                            <div><strong>Date:</strong> <span id="modalApptDate"></span></div>
                            <div><strong>Time:</strong> <span id="modalApptTime"></span></div>
                            <div><strong>Status:</strong> <span id="modalApptStatus"></span></div>
                            <div><strong>Reason:</strong> <span id="modalApptReason"></span></div>
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

    function openAppointmentModal(id,patient,doctor,department,date,time,status,reason){
        document.getElementById('modalApptId').innerText      = id;
        document.getElementById('modalApptPatient').innerText = patient;
        document.getElementById('modalApptDoctor').innerText  = doctor;
        document.getElementById('modalApptDept').innerText    = department;
        document.getElementById('modalApptDate').innerText    = date;
        document.getElementById('modalApptTime').innerText    = time;
        document.getElementById('modalApptStatus').innerText  = status;
        document.getElementById('modalApptReason').innerText  = reason;
        const m = document.getElementById('appointmentModal');
        m.style.display = 'flex';
    }
    function closeAppointmentModal(){
        document.getElementById('appointmentModal').style.display = 'none';
    }
    document.getElementById('appointmentModal').addEventListener('click', e => {
        if(e.target === document.getElementById('appointmentModal')) closeAppointmentModal();
    });
</script>
</body>
</html>