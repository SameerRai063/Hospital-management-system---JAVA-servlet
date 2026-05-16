package Feedback.Controller;

import Feedback.Model.Feedback;
import Feedback.Model.dao.FeedbackDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/submitFeedback")
public class SubmitFeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Auth guard ─────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ── Get patientId from session ─────────────────────────────────────
        // Adjust cast to match whatever type your session stores the user as
        Object userObj = session.getAttribute("loggedInUser");
        int patientId;
        try {
            // If loggedInUser is your User/Patient model object with getId()
            patientId = (int) userObj.getClass().getMethod("getId").invoke(userObj);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ── Read form parameters ───────────────────────────────────────────
        String comment  = request.getParameter("comment");
        String ratingStr = request.getParameter("rating");

        // Basic validation
        if (comment == null || comment.isBlank() || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard?error=invalid");
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard.jsp?error=invalid");
            return;
        }

        // ── Build model ────────────────────────────────────────────────────
        Feedback feedback = new Feedback(patientId, comment.trim(), rating);

        // ── Persist ────────────────────────────────────────────────────────
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            boolean saved = new FeedbackDAO(con).addFeedback(feedback);
            if (saved) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard.jsp?success=feedback");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard.jsp?error=save");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/dashboard.jsp?error=server");
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
