<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Dashboard — Upachaar</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "brand-blue": "#0052FF", "mint": "#70C1B3",
            "pending-blue": "#3b82f6", "outstanding-orange": "#f59e0b",
          },
          fontFamily: { "display": ["Inter","sans-serif"], "sans": ["Inter","sans-serif"] },
          borderRadius: { "DEFAULT":"0.25rem","lg":"0.5rem","xl":"1rem","2xl":"1.5rem" },
        },
      },
    }
  </script>
  <style type="text/tailwindcss">
    body { background-color: #F7FAFA; }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
      vertical-align: middle;
    }
    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 99px; }
  </style>
</head>
<body class="font-display text-slate-900 antialiased">
<div class="flex h-screen w-full overflow-hidden">

  <!-- ═══════════════ SIDEBAR ═══════════════ -->
  <aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 flex-shrink-0">
    <div class="px-8 mb-10">
      <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
      <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Clinical Suite</p>
    </div>

    <nav class="flex-1 flex flex-col gap-1 px-0">

      <%-- Dashboard — ACTIVE --%>
      <a href="<%= request.getContextPath() %>/doctorDashboard"
         class="bg-white text-[#0052FF] mx-4 px-4 py-3 rounded-full flex items-center gap-3 shadow-lg shadow-black/10 font-semibold">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">dashboard</span>
        <span class="text-sm font-medium">Dashboard</span>
      </a>

      <%-- Appointments — inactive --%>
      <a href="<%= request.getContextPath() %>/doctorAppointments"
         class="text-white/70 hover:text-white mx-4 px-4 py-3 rounded-full flex items-center gap-3 hover:bg-white/10 transition-all">
        <span class="material-symbols-outlined">calendar_month</span>
        <span class="text-sm font-medium">Appointments</span>
      </a>

    </nav>

    <!-- Profile -->
    <div class="mt-auto p-8 border-t border-white/10">
      <div class="flex items-center gap-4">
        <div class="w-12 h-12 rounded-full bg-white/20 ring-2 ring-white/30 flex items-center justify-center text-white font-bold text-base flex-shrink-0">
          ${doctorInitials}
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-bold text-white truncate">${doctorName}</p>
          <p class="text-xs text-white/60 truncate font-medium uppercase tracking-wider">${doctorSpecialty}</p>
        </div>
        <form method="post" action="<%= request.getContextPath() %>/logout" style="margin:0">
          <button type="submit" class="text-white/60 hover:text-white transition-colors">
            <span class="material-symbols-outlined text-[20px]">logout</span>
          </button>
        </form>
      </div>
    </div>
  </aside>

  <!-- ═══════════════ MAIN ═══════════════ -->
  <main class="flex-1 flex flex-col overflow-hidden">

    <header class="h-20 shrink-0 px-10 flex items-center border-b border-slate-100">
      <div>
        <h1 class="text-2xl font-bold text-slate-900">Welcome back, Doctor</h1>
        <p class="text-sm text-slate-500" id="dash-date"></p>
      </div>
    </header>

    <div class="flex-1 overflow-y-auto px-10 pb-10">

      <!-- ── Health Summary ── -->
      <section class="mt-6 mb-8">
        <div class="mb-6">
          <h2 class="text-lg font-bold text-slate-800">Health Summary</h2>
        </div>
        <div class="grid grid-cols-3 gap-6">

          <div class="bg-brand-blue p-6 rounded-2xl shadow-lg shadow-brand-blue/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer">
            <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
              <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">calendar_month</span>
            </div>
            <div>
              <p class="text-white/80 text-xs font-medium mb-1">Total Appointments</p>
              <p class="text-lg font-bold leading-tight">${totalAppts}</p>
            </div>
          </div>

          <div class="bg-mint p-6 rounded-2xl shadow-lg shadow-mint/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer">
            <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
              <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">check_circle</span>
            </div>
            <div>
              <p class="text-white/80 text-xs font-medium mb-1">Completed</p>
              <p class="text-lg font-bold leading-tight">${completedCount}</p>
            </div>
          </div>

          <div class="bg-pending-blue p-6 rounded-2xl shadow-lg shadow-blue-500/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer">
            <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
              <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">event_available</span>
            </div>
            <div>
              <p class="text-white/80 text-xs font-medium mb-1">Scheduled</p>
              <p class="text-lg font-bold leading-tight">${scheduledCount}</p>
            </div>
          </div>

        </div>
      </section>

    </div>
  </main>
</div>

<script>
  (function () {
    var days   = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
    var months = ['January','February','March','April','May','June',
      'July','August','September','October','November','December'];
    var now = new Date();
    document.getElementById('dash-date').textContent =
            days[now.getDay()] + ', ' + months[now.getMonth()] + ' ' + now.getDate() + ', ' + now.getFullYear();
  })();
</script>
</body>
</html>