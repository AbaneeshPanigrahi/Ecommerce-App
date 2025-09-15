<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String orderId = request.getParameter("order_id");

    if (orderId != null) {
        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM orders WHERE id = ?");
            ps.setInt(1, Integer.parseInt(orderId));
            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                out.println("<script>alert('Order deleted successfully!'); window.location='manage_orders.jsp';</script>");
            } else {
                out.println("<script>alert('Order not found!'); window.location='manage_orders.jsp';</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error deleting order!'); window.location='manage_orders.jsp';</script>");
        }
    } else {
        response.sendRedirect("manage_orders.jsp");
    }
%>
