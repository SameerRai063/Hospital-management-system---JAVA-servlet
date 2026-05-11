package User.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
// removed unused imports (URLEncoder, StandardCharsets) — exceptions are logged server-side now
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;
import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;

@WebServlet("/login")
public class LoginUserServlet extends HttpServlet {
    private static final Logger LOG = Logger.getLogger(LoginUserServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String plainPassword = request.getParameter("password");

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            UserDAO userDAO = new UserDAO(con);

            // 1. Fetch the user from the database by email
            User user = userDAO.getUserByEmail(email);

            // DEBUG: log fetched user details (local debug only) - remove in production
            LOG.info("DEBUG: login attempt email=" + email + " user=" + (user == null ? "null" : user.getEmail()) + " storedHash=" + (user == null ? "null" : user.getPassword()));

            // 2. Check if user exists AND if the plain password matches the hashed password
            boolean bcryptOk = false;
            if (user != null) {
                try {
                    bcryptOk = BCrypt.checkpw(plainPassword, user.getPassword());
                } catch (Exception ex) {
                    // Log and continue; bcrypt failure will be treated as authentication failure
                    LOG.log(Level.WARNING, "BCrypt check failed for email=" + email, ex);
                }
            }

            // Log result of bcrypt check for debugging (remove in production)
            LOG.info("DEBUG: bcryptOk=" + bcryptOk + " for email=" + email);

            if (user != null && bcryptOk) {

                // Login Successful! Create the session
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getEmail());
                session.setAttribute("role", user.getRole() == null ? null : user.getRole().toUpperCase());
                session.setAttribute("firstName", user.getName());
                session.setAttribute("lastName", "");

                // Route to the correct dashboard based on their role
                String role = user.getRole();

                if ("patient".equalsIgnoreCase(role)) {
                    LOG.info("Login success for email=" + email + " role=patient -> redirecting to patient_dashboard.jsp");
                    response.sendRedirect(request.getContextPath() + "/patient_dashboard.jsp");

                } else if ("admin".equalsIgnoreCase(role)) {
                    LOG.info("Login success for email=" + email + " role=admin -> redirecting to admin_dashboard.jsp");
                    response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");

                } else if ("doctor".equalsIgnoreCase(role)) {
                    LOG.info("Login success for email=" + email + " role=doctor -> redirecting to doctor_dashboard.jsp");
                    response.sendRedirect(request.getContextPath() + "/doctor_dashboard.jsp");

                } else if ("receptionist".equalsIgnoreCase(role)) {
                    LOG.info("Login success for email=" + email + " role=receptionist -> redirecting to receptionist_dashboard.jsp");
                    response.sendRedirect(request.getContextPath() + "/receptionist_dashboard.jsp");

                } else {
                    // Fallback for unknown roles
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }

            } else {
                // Login Failed! Incorrect email or password
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid_credentials");
            }

        } catch (Exception e) {
            // Log the full exception server-side for debugging
            LOG.log(Level.SEVERE, "Login error for email=" + email, e);
            // Do not expose internal exception details to the end user. Redirect with generic error.
                try {
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=system_error");
                } catch (Exception ex) {
                // Log and swallow redirect/encoding errors
                LOG.log(Level.SEVERE, "Failed to redirect to login.jsp after error for email=" + email, ex);
                // No further action: response already in error state
            }
        } finally {
            // Ensure the database connection is closed to prevent memory leaks
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
                LOG.log(Level.WARNING, "Failed to close DB connection", e);
            }
        }
    }
}