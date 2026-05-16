<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en">
<head>
    <title>Dashboard — Upachaar</title>
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
            <a href="dashboard.jsp" class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">dashboard</span>
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
            <h1 class="text-2xl font-bold text-slate-900">Good morning, Priya!</h1>
            <p class="text-sm text-slate-500">Friday, May 15, 2026 · Front Desk Overview</p>
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
                <!-- Stats Row -->
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-6 mt-8 mb-8">
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Today's Appointments</p>
                        <h3 class="text-3xl font-black text-slate-800">12</h3>
                        <p class="text-xs text-mint font-semibold mt-1">↑ 3 from yesterday</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Patients Registered</p>
                        <h3 class="text-3xl font-black text-slate-800">284</h3>
                        <p class="text-xs text-[#0052FF] font-semibold mt-1">↑ 5 this week</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Doctors On Duty</p>
                        <h3 class="text-3xl font-black text-slate-800">8</h3>
                        <p class="text-xs text-slate-400 font-semibold mt-1">2 on leave today</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Pending Messages</p>
                        <h3 class="text-3xl font-black text-slate-800">3</h3>
                        <p class="text-xs text-outstanding-orange font-semibold mt-1">Needs attention</p>
                    </div>
                </div>

                <!-- Upcoming Appointments Table -->
                <div class="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex items-center justify-between">
                        <h2 class="font-bold text-slate-800">Today's Schedule</h2>
                        <a href="appointments.jsp" class="text-xs font-bold text-[#0052FF] uppercase tracking-widest hover:opacity-70 transition-opacity">View All →</a>
                    </div>
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-[#e2f1ec]">
                                <th class="px-6 py-4 text-xs font-bold text-[#0b6b59] uppercase tracking-wide">Patient</th>
                                <th class="px-6 py-4 text-xs font-bold text-[#0b6b59] uppercase tracking-wide">Doctor</th>
                                <th class="px-6 py-4 text-xs font-bold text-[#0b6b59] uppercase tracking-wide">Time</th>
                                <th class="px-6 py-4 text-xs font-bold text-[#0b6b59] uppercase tracking-wide">Type</th>
                                <th class="px-6 py-4 text-xs font-bold text-[#0b6b59] uppercase tracking-wide">Status</th>
                            </tr>
                        </thead>
                        <tbody id="dashboard-table"></tbody>
                    </table>
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

    const appointments = [
        {name:'Priya Sharma',  doctor:'Dr. A. Kapoor', time:'09:00 AM', type:'Follow-up',       status:'upcoming'},
        {name:'Rohan Mehta',   doctor:'Dr. A. Kapoor', time:'10:30 AM', type:'Consultation',    status:'pending'},
        {name:'Anjali Verma',  doctor:'Dr. S. Reddy',  time:'12:00 PM', type:'Routine Checkup', status:'completed'},
        {name:'Karan Patel',   doctor:'Dr. S. Reddy',  time:'02:15 PM', type:'Report Review',   status:'upcoming'},
    ];
    const statusCls = {
        upcoming:  'bg-blue-50 text-blue-600',
        pending:   'bg-amber-50 text-amber-600',
        completed: 'bg-emerald-50 text-emerald-700',
    };
    const tbody = document.getElementById('dashboard-table');
    tbody.innerHTML = appointments.map(a => `
        <tr class="border-b border-slate-100 hover:bg-slate-50 transition-colors">
            <td class="px-6 py-4 text-sm font-semibold text-slate-800">${a.name}</td>
            <td class="px-6 py-4 text-sm text-slate-600">${a.doctor}</td>
            <td class="px-6 py-4 text-sm text-slate-600 font-mono">${a.time}</td>
            <td class="px-6 py-4 text-sm text-slate-600">${a.type}</td>
            <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold capitalize ${statusCls[a.status] || ''}">${a.status}</span></td>
        </tr>`).join('');
</script>
</body>
</html>