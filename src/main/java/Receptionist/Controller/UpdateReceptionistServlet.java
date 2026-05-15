package Receptionist.Controller;

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
import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;

@WebServlet("/update-receptionist")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdateReceptionistServlet extends HttpServlet {

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

            // AUTHORIZATION: Receptionist (Self) or Admin
            if (userRole.equals("receptionist")) {
                targetUserId = loggedInUser.getId();
            } else if (userRole.equals("admin")) {
                targetUserId = Integer.parseInt(request.getParameter("targetUserId"));
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
            user.setGender(request.getParameter("gender")); // Kept from your snippet
            user.setAddress(request.getParameter("address"));
            user.setPhone(request.getParameter("phone"));
            // Note: If your DAO also expects email, ensure you add: user.setEmail(request.getParameter("email"));
            user.setProfileImage(finalImageName);

            // 2. Build the Receptionist object
            Receptionist receptionist = new Receptionist();
            receptionist.setUserId(targetUserId);
            receptionist.setStatus(request.getParameter("status"));
            receptionist.setUser(user); // Important: DAO needs this!

            // 3. Get Passwords
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");

            // 4. Call DAO
            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);
            boolean isUpdated = receptionistDAO.updateReceptionistProfile(receptionist, currentPassword, newPassword);

            if (isUpdated) {
                if (userRole.equals("receptionist")) {
                    // Update session attributes so the UI updates instantly without requiring a re-login
                    loggedInUser.setName(user.getName());
                    loggedInUser.setProfileImage(user.getProfileImage());
                    response.sendRedirect("receptionist_dashboard.jsp?success=updated");
                } else {
                    response.sendRedirect("view-receptionists?success=updated");
                }
            } else {
                response.sendRedirect("edit_receptionist.jsp?error=failed_or_wrong_password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_receptionist.jsp?error=exception");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}