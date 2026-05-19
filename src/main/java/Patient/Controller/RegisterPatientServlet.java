package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;

import utils.DBConnection;
import User.Model.User;
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;

@WebServlet("/register-patient")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize       = 1024 * 1024 * 10,
        maxRequestSize    = 1024 * 1024 * 50
)
public class RegisterPatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String ctx = request.getContextPath();
        Connection con = null;

        try {
            String name            = request.getParameter("name");
            String email           = request.getParameter("email");
            String plainPassword   = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String phone           = request.getParameter("phone");
            String gender          = request.getParameter("gender");
            String address         = request.getParameter("address");
            String dobStr          = request.getParameter("dob");
            String bloodGroup      = request.getParameter("bloodGroup");

            if (isBlank(name) || isBlank(email) || isBlank(plainPassword)
                    || isBlank(phone) || isBlank(gender) || isBlank(bloodGroup)) {
                forwardWithError(request, response, "Please fill in all required fields.");
                return;
            }

            if (!plainPassword.equals(confirmPassword)) {
                forwardWithError(request, response, "Passwords do not match.");
                return;
            }

            if (plainPassword.length() < 6) {
                forwardWithError(request, response, "Password must be at least 6 characters.");
                return;
            }

            String fileName = "default_patient.png";

            // Build User — password is plain text, DAO will hash it
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(plainPassword);
            user.setPhone(phone);
            user.setGender(gender);
            user.setAddress(address);
            user.setProfileImage(fileName);
            user.setRole("patient");
            if (!isBlank(dobStr)) user.setDob(Date.valueOf(dobStr));

            // Build Patient
            Patient patient = new Patient();
            patient.setUser(user);
            patient.setBloodGroup(bloodGroup);
            patient.setActive(true);

            // Save
            con = DBConnection.getConnection();
            PatientDAO patientDAO = new PatientDAO(con);
            boolean success = patientDAO.registerPatient(patient);

            if (success) {
                response.sendRedirect(ctx + "/login.jsp?success=registered");
            } else {
                forwardWithError(request, response, "Registration failed. Please try again.");
            }

        } catch (IllegalArgumentException e) {
            forwardWithError(request, response, e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "A server error occurred. Please try again.");

        } finally {
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse res, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", msg);
        req.getRequestDispatcher("/register.jsp").forward(req, res);
    }
}
