package message.Controller;

import utils.DBConnection;

import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class GetMessagesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String senderIdParam = request.getParameter("senderId");
        String receiverIdParam = request.getParameter("receiverId");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        if (senderIdParam == null || receiverIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Missing senderId or receiverId");
            return;
        }

        int senderId;
        int receiverId;
        try {
            senderId = Integer.parseInt(senderIdParam);
            receiverId = Integer.parseInt(receiverIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "senderId and receiverId must be integers");
            return;
        }

        if (!session.getAttribute("userId").equals(senderId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid sender");
            return;
        }

        String sql = "SELECT m.sender_id, m.message_text " +
                "FROM messages m " +
                "JOIN conversations c ON c.id = m.conversation_id " +
                "WHERE c.patient_id = ? " +
                "ORDER BY m.sent_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, resolvePatientId(conn, senderId, receiverId));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    boolean ownMessage = rs.getInt("sender_id") == senderId;
                    response.getWriter().println(
                            "<div class=\"flex " + (ownMessage ? "justify-end" : "justify-start") + "\">"
                                    + "<div class=\"max-w-[70%] rounded-lg px-4 py-2 text-sm "
                                    + (ownMessage ? "bg-[#0052FF] text-white" : "bg-white border border-slate-200 text-slate-800")
                                    + "\">"
                                    + escapeHtml(rs.getString("message_text"))
                                    + "</div></div>");
                }
            }

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load messages: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private int resolvePatientId(Connection conn, int senderId, int receiverId) throws Exception {
        if (hasRole(conn, senderId, "patient")) {
            return senderId;
        }
        if (hasRole(conn, receiverId, "patient")) {
            return receiverId;
        }
        throw new IllegalArgumentException("A chat conversation must include a patient.");
    }

    private boolean hasRole(Connection conn, int userId, String role) throws Exception {
        String sql = "SELECT 1 FROM users WHERE id = ? AND role = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, role);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
