package Appointment.Controller;

import Appointment.Model.dao.AppointmentDAO;
import Appointment.Model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/doctorAppointments")
public class doctorAppointmentServlet extends HttpServlet {

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

        // ── 4. Full appointments list ──────────────────────────────────────
        List<Appointment> appointments =
                appointmentDAO.getAppointmentsByDoctorId(doctorId);
        request.setAttribute("appointments", appointments);

        // ── 5. Forward to appointments JSP ────────────────────────────────
        request.getRequestDispatcher("/doctor/appointments.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Auth guard ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctorId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ── 2. Read params from the "Complete" button form ─────────────────
        String appointmentIdStr = request.getParameter("appointmentId");
        String newStatus        = request.getParameter("status");

        // ── 3. Validate and update ─────────────────────────────────────────
        if (appointmentIdStr != null && newStatus != null && !newStatus.isBlank()) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                boolean updated = appointmentDAO.updateAppointmentStatus(appointmentId, newStatus);
                if (!updated) {
                    System.err.println("Warning: no rows updated for appointmentId=" + appointmentId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // ── 4. PRG — redirect back to appointments list ────────────────────
        response.sendRedirect(request.getContextPath() + "/doctorAppointments");
    }
}