package Appointment.Controller;

import Appointment.Model.dao.AppointmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/doctorDashboard")
public class doctorDashboard extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Auth guard ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctorId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int doctorId = (Integer) session.getAttribute("doctorId");

        // ── 2. Counts ──────────────────────────────────────────────────────
        request.setAttribute("totalAppts",     appointmentDAO.countTotalAppointments(doctorId));
        request.setAttribute("scheduledCount", appointmentDAO.countScheduledAppointments(doctorId));
        request.setAttribute("completedCount", appointmentDAO.countCompletedAppointments(doctorId));

        // ── 3. Doctor profile for sidebar ──────────────────────────────────
        request.setAttribute("doctorName",      session.getAttribute("doctorName"));
        request.setAttribute("doctorSpecialty", session.getAttribute("doctorSpecialty"));
        request.setAttribute("doctorInitials",  session.getAttribute("doctorInitials"));

        // ── 4. Forward to dashboard JSP ────────────────────────────────────
        request.getRequestDispatcher("/doctor/dashboard.jsp")
                .forward(request, response);
    }
}