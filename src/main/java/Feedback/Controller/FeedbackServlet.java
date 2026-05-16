package Feedback.Controller;

import Feedback.Model.Feedback;
import Feedback.Model.dao.FeedbackDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

/**
 * Handles GET /reviews  → loads and forwards to admin/reviews.jsp
 * Handles GET /deleteReview → deletes one review then redirects back
 */
@WebServlet({"/reviews", "/deleteReview"})
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Auth guard ────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/deleteReview".equals(path)) {
            handleDelete(request, response);
        } else {
            handleList(request, response);
        }
    }

    // ── List all reviews ──────────────────────────────────────────────────

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            FeedbackDAO dao = new FeedbackDAO(con);

            // Attribute names must match what reviews.jsp reads via EL / scriptlet
            int totalReviews      = dao.countTotalFeedback();
            double averageRating  = dao.getAverageRating();
            List<Feedback> list   = dao.getAllFeedback();

            request.setAttribute("totalReviews",   totalReviews);   // JSP: <%= totalReviews %>
            request.setAttribute("averageRating",  averageRating);  // JSP: <%= averageRating %>
            request.setAttribute("reviewList",     list);           // JSP: ${reviewList}

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load review data.");
        } finally {
            closeQuietly(con);
        }

        request.getRequestDispatcher("/admin/reviews.jsp")
                .forward(request, response);
    }

    // ── Delete one review then redirect ───────────────────────────────────

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            Connection con = null;
            try {
                con = DBConnection.getConnection();
                new FeedbackDAO(con).deleteFeedback(Integer.parseInt(idParam.trim()));
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                closeQuietly(con);
            }
        }

        // PRG pattern – redirect back to the list so F5 doesn't re-delete
        response.sendRedirect(request.getContextPath() + "/reviews");
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private void closeQuietly(Connection con) {
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
}