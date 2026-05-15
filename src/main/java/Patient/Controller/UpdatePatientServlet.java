package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;

import utils.DBConnection;
import User.Model.User;
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

@WebServlet("/update-patient")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdatePatientServlet extends HttpServlet {

    // Directory where you want to save profile images
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        Connection con = null;
        try {
            int targetUserId = 0;
            String userRole = loggedInUser.getRole().toLowerCase();

            // AUTHORIZATION: Patient (Self), Admin, or Receptionist
            if (userRole.equals("patient")) {
                targetUserId = loggedInUser.getId(); // Self update
            } else if (userRole.equals("admin") || userRole.equals("receptionist")) {
                targetUserId = Integer.parseInt(request.getParameter("targetUserId")); // Staff updating patient
            } else {
                response.sendRedirect("login.jsp?error=unauthorized");
                return;
            }

            // ==========================================
            // IMAGE UPLOAD LOGIC
            // ==========================================
            String finalImageName = request.getParameter("oldProfileImage");

            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }

                filePart.write(uploadFilePath + File.separator + fileName);
                finalImageName = fileName;
            }
            // ==========================================

            con = DBConnection.getConnection();

            // 1. Build the User object
            User user = new User();
            user.setId(targetUserId);
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setAddress(request.getParameter("address"));
            user.setProfileImage(finalImageName); // Attach the image to the user

            // 2. Build the Patient object and attach the User to it
            Patient patient = new Patient();
            patient.setUserId(targetUserId);
            patient.setBloodGroup(request.getParameter("bloodGroup"));
            patient.setUser(user); // <-- Crucial: The DAO expects this!

            // 3. Get Passwords from the form
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");

            // 4. Call the PatientDAO (It handles the transaction and both tables)
            PatientDAO patientDAO = new PatientDAO(con);
            boolean isUpdated = patientDAO.updatePatientProfile(patient, currentPassword, newPassword);

            if (isUpdated) {
                if (userRole.equals("patient")) {
                    loggedInUser.setName(user.getName()); // Update session name
                    loggedInUser.setProfileImage(user.getProfileImage()); // Update session image
                    response.sendRedirect("patient_dashboard.jsp?success=updated");
                } else {
                    response.sendRedirect("view-patients?success=updated");
                }
            } else {
                // Fails if DB error OR if currentPassword is wrong
                response.sendRedirect("edit_patient.jsp?error=failed_or_wrong_password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_patient.jsp?error=exception");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}