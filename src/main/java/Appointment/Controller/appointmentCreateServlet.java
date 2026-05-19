package Appointment.Controller;

import Appointment.Model.Appointment;
import Appointment.Model.dao.AppointmentDAO;
import Notification.Model.dao.NotificationDAO;
import Payment.Model.Payment;
import Payment.Model.dao.PaymentDAO;
import User.Model.User;
import java.sql.Connection;
import utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.ParseException;

@WebServlet("/appointmentCreate")
public class appointmentCreateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        try {
            // 1. Read form fields
            int patientId     = user.getId();
            int doctorId      = Integer.parseInt(request.getParameter("doctorId"));
            String department = request.getParameter("department");
            String dateStr    = request.getParameter("appointmentDate");  // "yyyy-MM-dd"
            String timeStr    = request.getParameter("appointmentTime");  // "09:00 AM"
            String reason     = request.getParameter("reason");
            String status     = "scheduled";

            // 2. Validate
            if (doctorId == 0 || dateStr == null || dateStr.isEmpty()
                    || timeStr == null || timeStr.isEmpty() || "—".equals(timeStr)
                    || department == null || department.trim().isEmpty()
                    || reason == null || reason.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/patientAppointments?error=missingFields");
                return;
            }

            java.sql.Time appointmentTime = parseAppointmentTime(timeStr);

            // 4. Build Appointment
            Appointment appointment = new Appointment();
            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setDepartment(department);
            appointment.setAppointmentDate(Date.valueOf(dateStr));
            appointment.setAppointmentTime(appointmentTime);
            appointment.setReason(reason.trim());
            appointment.setStatus(status);

            // 5. Save appointment, get generated id
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            int appointmentId = appointmentDAO.addAppointment(appointment);

            if (appointmentId == -1) {
                response.sendRedirect(request.getContextPath()
                        + "/patientAppointments?error=appointmentFailed");
                return;
            }

            // 6. Build Payment
            Payment payment = new Payment();
            payment.setPatientId(patientId);
            payment.setAppointmentId(appointmentId);
            payment.setAmount(new BigDecimal("120.00"));

            // 7. Save payment
            try (Connection con = DBConnection.getConnection()) {
                PaymentDAO paymentDAO = new PaymentDAO(con);
                boolean paymentSaved = paymentDAO.addPayment(payment);
                System.out.println("Payment saved: " + paymentSaved);
                System.out.println("appointmentId: " + appointmentId);
                System.out.println("patientId: "     + patientId);
                System.out.println("amount: "        + payment.getAmount());
            } catch (Exception e) {
                e.printStackTrace(); // ← check Tomcat console for the real error
                response.sendRedirect(request.getContextPath()
                        + "/patientAppointments?error=paymentFailed");
                return;
            }

            sendBookingNotifications(user, doctorId, department, dateStr, timeStr);

            // 8. Redirect with success
            response.sendRedirect(request.getContextPath()
                    + "/patientAppointments?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/patientAppointments?error=serverError");
        }
    }

    private void sendBookingNotifications(User patient, int doctorId, String department, String dateStr, String timeStr) {
        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            String patientName = patient.getName() != null ? patient.getName() : "A patient";
            String title = "New Appointment Booking";
            String message = patientName + " booked a " + department + " appointment for " + dateStr + " at " + timeStr + ".";

            notificationDAO.addNotificationForRole("admin", title, message);
            notificationDAO.addNotificationForRole("receptionist", title, message);
            notificationDAO.addNotification(doctorId, title, message);
            notificationDAO.addNotification(patient.getId(), "Appointment Booked", "Your appointment is booked for " + dateStr + " at " + timeStr + ".");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private java.sql.Time parseAppointmentTime(String timeStr) throws ParseException {
        String normalized = timeStr.trim();
        java.text.SimpleDateFormat parser = normalized.toUpperCase().contains("AM") || normalized.toUpperCase().contains("PM")
                ? new java.text.SimpleDateFormat("hh:mm a")
                : new java.text.SimpleDateFormat("HH:mm");
        parser.setLenient(false);
        return new java.sql.Time(parser.parse(normalized).getTime());
    }
}
