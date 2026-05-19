package Appointment.Controller;

import Appointment.Model.dao.AppointmentDAO;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.DBConnection;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/doctorDashboard")
public class doctorDashboard extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctorId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int doctorId = (Integer) session.getAttribute("doctorId");

        request.setAttribute("totalAppts", appointmentDAO.countTotalAppointments(doctorId));
        request.setAttribute("todayCount", appointmentDAO.countTodayAppointments(doctorId));
        request.setAttribute("scheduledCount", appointmentDAO.countScheduledAppointments(doctorId));
        request.setAttribute("completedCount", appointmentDAO.countCompletedAppointments(doctorId));
        loadDoctorProfile(request, session, doctorId);

        request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
    }

    private void loadDoctorProfile(HttpServletRequest request, HttpSession session, int doctorId) {
        try (Connection con = DBConnection.getConnection()) {
            Doctor doctor = new DoctorDAO(con).getDoctorById(doctorId);
            if (doctor != null && doctor.getUser() != null) {
                String name = doctor.getUser().getName();
                String specialty = doctor.getDepartment();
                String initials = buildInitials(name);

                request.setAttribute("doctorName", name);
                request.setAttribute("doctorSpecialty", specialty);
                request.setAttribute("doctorInitials", initials);
                session.setAttribute("doctorName", name);
                session.setAttribute("doctorSpecialty", specialty);
                session.setAttribute("doctorInitials", initials);
                session.setAttribute("userName", name);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String fallbackName = (String) session.getAttribute("userName");
        request.setAttribute("doctorName", fallbackName);
        request.setAttribute("doctorSpecialty", "");
        request.setAttribute("doctorInitials", buildInitials(fallbackName));
    }

    private String buildInitials(String name) {
        if (name == null || name.isBlank()) {
            return "DR";
        }

        String[] parts = name.trim().split("\\s+");
        StringBuilder initials = new StringBuilder();
        for (String part : parts) {
            if (!part.isBlank()) {
                initials.append(Character.toUpperCase(part.charAt(0)));
            }
            if (initials.length() == 2) {
                break;
            }
        }
        return !initials.isEmpty() ? initials.toString() : "DR";
    }
}
