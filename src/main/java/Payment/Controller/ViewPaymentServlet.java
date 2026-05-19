package Payment.Controller;

import Payment.Model.Payment;
import Payment.Model.dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/billing")
public class ViewPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PaymentDAO paymentDAO = new PaymentDAO(con);
            String search = request.getParameter("search");

            request.setAttribute("totalRevenue", paymentDAO.getTotalRevenue());
            request.setAttribute("paidCount", paymentDAO.countPaymentsByStatus("completed"));
            request.setAttribute("pendingCount", paymentDAO.countPaymentsByStatus("pending"));
            request.setAttribute("pendingAmount", paymentDAO.getPendingAmount());
            request.setAttribute("failedCount", paymentDAO.countPaymentsByStatus("failed"));

            List<Payment> payments = paymentDAO.getPayments(search);
            request.setAttribute("billingList", payments);
            request.setAttribute("search", search);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load billing data.");
        }

        request.getRequestDispatcher("/admin/billing.jsp").forward(request, response);
    }
}
