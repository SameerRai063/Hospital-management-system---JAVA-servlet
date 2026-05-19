<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Appointments — Upachaar</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        // softened palette for better contrast and cohesion
                        "brand-blue": "#0B63D6", "mint": "#2DD4BF",
                        "pending-blue": "#2563EB", "outstanding-orange": "#f59e0b",
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

            <%-- Dashboard — inactive --%>
            <a href="<%= request.getContextPath() %>/doctorDashboard"
               class="text-white/70 hover:text-white mx-4 px-4 py-3 rounded-full flex items-center gap-3 hover:bg-white/10 transition-all">
                <span class="material-symbols-outlined">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>

            <%-- Appointments — ACTIVE --%>
            <a href="<%= request.getContextPath() %>/doctorAppointments"
               class="bg-white text-[#0052FF] mx-4 px-4 py-3 rounded-full flex items-center gap-3 shadow-lg shadow-black/10 font-semibold">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">calendar_month</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>

        </nav>

        <!-- Profile — populated from session via servlet -->
        <div class="mt-auto p-8 border-t border-white/10">
            <!-- sidebar: removed logout button here (use header logout for consistency) -->
            <div class="text-xs text-white/70">Logged in as <span class="font-semibold">${sessionScope.userName}</span></div>
        </div>
    </aside>

    <!-- ═══════════════ MAIN ═══════════════ -->
    <main class="flex-1 flex flex-col overflow-hidden">

        <header class="h-16 shrink-0 px-10 flex items-center justify-between bg-white border-b border-slate-100">
            <div>
                <h1 class="text-xl font-bold text-slate-900">Appointments</h1>
            </div>
            <div class="flex items-center gap-3">
                <a href="<%= request.getContextPath() %>/notifications.jsp"
                   class="relative inline-flex size-11 items-center justify-center rounded-full bg-slate-50 text-slate-600 hover:bg-blue-50 hover:text-[#0052FF] transition-colors"
                   aria-label="Notifications">
                    <span class="material-symbols-outlined">notifications</span>
                    <span class="absolute right-2 top-2 size-2 rounded-full bg-red-500"></span>
                </a>
                <div class="flex items-center gap-3 border-l border-slate-200 pl-5">
                    <span class="text-sm font-bold text-slate-900">${sessionScope.userName}</span>
                    <a href="#"
                       class="inline-flex size-10 items-center justify-center rounded-full bg-blue-100 text-[#0052FF] hover:bg-blue-200 transition-colors"
                       aria-label="Profile">
                        <span class="material-symbols-outlined text-3xl">account_circle</span>
                    </a>
                </div>
                <a href="<%= request.getContextPath() %>/logout"
                   class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-700 transition-colors">
                    <span class="material-symbols-outlined text-[20px]">logout</span>
                    Logout
                </a>
            </div>
        </header>

        <div class="flex-1 overflow-y-auto px-10 pb-10">

            <!-- ── Health Summary — counts from servlet ── -->
            <section class="mt-6 mb-8">
                <div class="mb-6">
                    <h2 class="text-lg font-bold text-slate-800">Health Summary</h2>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

                    <%-- totalAppts set by: request.setAttribute("totalAppts", ...) --%>
                    <div class="bg-brand-blue p-6 rounded-2xl shadow-lg ring-1 ring-white/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer">
                        <div class="bg-white/95 size-12 rounded-xl flex items-center justify-center text-brand-blue font-bold">
                            <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">calendar_month</span>
                        </div>
                        <div>
                            <p class="text-slate-100 text-xs font-medium mb-1">Total Appointments</p>
                            <p class="text-2xl font-extrabold leading-tight">${totalAppts}</p>
                        </div>
                    </div>

                    <%-- scheduledCount set by: request.setAttribute("scheduledCount", ...) --%>
                    <div class="bg-mint p-6 rounded-2xl shadow-lg ring-1 ring-white/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer">
                        <div class="bg-white/95 size-12 rounded-xl flex items-center justify-center text-[10px] font-bold text-brand-blue">
                            <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">schedule</span>
                        </div>
                        <div>
                            <p class="text-slate-900 text-xs font-medium mb-1">Scheduled</p>
                            <p class="text-2xl font-extrabold leading-tight">${scheduledCount}</p>
                        </div>
                    </div>

                    <%-- completedCount set by: request.setAttribute("completedCount", ...) --%>
                    <div class="bg-pending-blue p-6 rounded-2xl shadow-lg ring-1 ring-white/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer">
                        <div class="bg-white/95 size-12 rounded-xl flex items-center justify-center text-pending-blue font-bold">
                            <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">check_circle</span>
                        </div>
                        <div>
                            <p class="text-slate-100 text-xs font-medium mb-1">Completed</p>
                            <p class="text-2xl font-extrabold leading-tight">${completedCount}</p>
                        </div>
                    </div>

                </div>
            </section>

            <!-- ── Appointments Table — list from servlet ── -->
            <section class="mb-8">
                <div class="mb-6">
                    <h2 class="text-lg font-bold text-slate-800">All Appointments</h2>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
                    <table class="w-full text-sm">
                        <thead>
                        <tr class="bg-slate-50 border-b border-slate-100">
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">ID</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Patient</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Patient ID</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Reason</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Date</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Time</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Status</th>
                            <th class="text-left px-6 py-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Action</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">

                        <%-- appointments list set by: request.setAttribute("appointments", ...) --%>
                        <c:choose>
                            <c:when test="${empty appointments}">
                                <tr>
                                    <td colspan="8" class="px-6 py-16 text-center text-slate-400">
                                        <span class="material-symbols-outlined text-4xl block mb-2">calendar_month</span>
                                        No appointments found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="appt" items="${appointments}">
                                    <tr class="hover:bg-slate-50 transition-colors">

                                            <%-- appt.id --%>
                                        <td class="px-6 py-4 font-mono text-xs text-slate-500">#${appt.id}</td>

                                            <%-- appt.patientName --%>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center text-brand-blue font-bold text-xs flex-shrink-0">
                                                        ${fn:substring(appt.patientName, 0, 1)}
                                                </div>
                                                <span class="font-medium text-slate-800">${appt.patientName}</span>
                                            </div>
                                        </td>

                                            <%-- appt.patientId --%>
                                        <td class="px-6 py-4 text-slate-500 font-mono text-xs">${appt.patientId}</td>

                                            <%-- appt.reason --%>
                                        <td class="px-6 py-4 text-slate-600 max-w-[160px] truncate" title="${appt.reason}">
                                                ${appt.reason}
                                        </td>

                                            <%-- appt.appointmentDate --%>
                                        <td class="px-6 py-4 text-slate-700">${appt.appointmentDate}</td>

                                            <%-- appt.appointmentTime --%>
                                        <td class="px-6 py-4 text-slate-700">${appt.formattedAppointmentTime}</td>

                                            <%-- appt.status — color-coded badge --%>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${appt.status == 'completed'}">
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-700">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 inline-block"></span>
                                                            Completed
                                                        </span>
                                                </c:when>
                                                <c:when test="${appt.status == 'scheduled'}">
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-700">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-blue-500 inline-block"></span>
                                                            Scheduled
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold bg-slate-100 text-slate-600">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-slate-400 inline-block"></span>
                                                            ${appt.status}
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                            <%-- doPost: appointmentId + status=completed → updateAppointmentStatus() --%>
                                        <td class="px-6 py-4">
                                            <c:if test="${appt.status != 'completed'}">
                                                <form method="post" action="<%= request.getContextPath() %>/doctorAppointments" style="margin:0">
                                                    <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                    <input type="hidden" name="status"        value="completed" />
                                                    <button type="submit"
                                                            class="text-xs font-semibold text-white bg-brand-blue hover:bg-blue-700 px-3 py-1.5 rounded-lg transition-colors">
                                                        Mark Complete
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${appt.status == 'completed'}">
                                                <span class="text-xs text-slate-400 font-medium">—</span>
                                            </c:if>
                                        </td>

                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>

                        </tbody>
                    </table>
                </div>
            </section>

        </div>
    </main>
</div>

</body>
</html>
