<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Notification.Model.Notification" %>
<%@ page import="Notification.Model.dao.NotificationDAO" %>
<%@ page import="java.util.List" %>
<%
    Integer userId = (session.getAttribute("userId") instanceof Integer) ? (Integer) session.getAttribute("userId") : null;
    List<Notification> notifications = java.util.Collections.emptyList();
    int unreadCount = 0;
    if (userId != null) {
        NotificationDAO notificationDAO = new NotificationDAO();
        notifications = notificationDAO.getNotificationsForUser(userId);
        unreadCount = notificationDAO.countUnreadForUser(userId);
    }

    java.util.function.Function<String, String> esc = value -> {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Patient Notifications - Upachaar</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="bg-[#F7FAFA] font-[Inter] text-slate-900 antialiased">
<div class="flex h-screen w-full">
    <aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6">
        <div class="px-8 mb-10">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Patient Portal</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1">
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patientAppointments">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patientProfile">
                <span class="material-symbols-outlined">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/chat">
                <span class="material-symbols-outlined">forum</span>
                <span class="text-sm font-medium">Chat</span>
            </a>
        </nav>
    </aside>

    <main class="flex-1 overflow-y-auto">
        <header class="h-16 bg-white border-b border-slate-100 flex items-center justify-between px-10">
            <div>
                <h1 class="text-xl font-bold text-slate-900">Notifications</h1>
                <p class="text-sm text-slate-500">Recent updates about your appointments and hospital messages.</p>
            </div>
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/patient/notifications.jsp"
                   class="relative inline-flex size-11 items-center justify-center rounded-full bg-blue-50 text-[#0052FF]"
                   aria-label="Notifications">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">notifications</span>
                    <span class="absolute right-2 top-2 size-2 rounded-full bg-red-500"></span>
                </a>
                <div class="flex items-center gap-3 border-l border-slate-200 pl-5">
                    <span class="text-sm font-bold text-slate-900">${sessionScope.userName}</span>
                    <a href="${pageContext.request.contextPath}/patientProfile"
                       class="inline-flex size-10 items-center justify-center rounded-full bg-blue-100 text-[#0052FF] hover:bg-blue-200 transition-colors"
                       aria-label="Profile">
                        <span class="material-symbols-outlined text-3xl">account_circle</span>
                    </a>
                </div>
                <a href="${pageContext.request.contextPath}/logout"
                   class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-700 transition-colors">
                    <span class="material-symbols-outlined text-[20px]">logout</span>
                    Logout
                </a>
            </div>
        </header>

        <section class="m-10 rounded-2xl border border-slate-100 bg-white p-8 shadow-sm">
            <div class="mb-6 flex items-center justify-between">
                <div>
                    <h2 class="text-lg font-bold">Recent Notifications</h2>
                    <p class="text-sm text-slate-500"><%= unreadCount %> unread notification<%= unreadCount == 1 ? "" : "s" %></p>
                </div>
            </div>

            <% if (notifications.isEmpty()) { %>
                <div class="flex items-center gap-4 rounded-xl bg-blue-50 p-5 text-[#0052FF]">
                    <span class="material-symbols-outlined text-3xl">notifications</span>
                    <div>
                        <h2 class="font-semibold text-slate-900">No new notifications</h2>
                        <p class="text-sm text-slate-500">Appointment updates and hospital notices will appear here.</p>
                    </div>
                </div>
            <% } else { %>
                <div class="space-y-3">
                    <% for (Notification notification : notifications) { %>
                        <article class="rounded-xl border <%= notification.isRead() ? "border-slate-100 bg-white" : "border-blue-100 bg-blue-50" %> p-5">
                            <div class="flex items-start justify-between gap-4">
                                <div>
                                    <h3 class="font-bold text-slate-900"><%= esc.apply(notification.getTitle()) %></h3>
                                    <p class="mt-1 text-sm text-slate-600"><%= esc.apply(notification.getMessage()) %></p>
                                </div>
                                <span class="whitespace-nowrap text-xs font-semibold text-slate-400"><%= notification.getFormattedDate() %></span>
                            </div>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>
