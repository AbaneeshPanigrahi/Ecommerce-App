<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    // --- Check admin session ---
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    // --- Get order_id from request ---
    String orderIdParam = request.getParameter("order_id");
    if (orderIdParam == null || orderIdParam.isEmpty()) {
        out.println("<h3>Invalid order ID.</h3>");
        return;
    }

    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdParam);
    } catch (NumberFormatException e) {
        out.println("<h3>Invalid order ID format.</h3>");
        return;
    }

    try {
        // --- Delete order from database ---
        PreparedStatement ps = conn.prepareStatement("DELETE FROM orders WHERE id=?");
        ps.setInt(1, orderId);
        int rowsDeleted = ps.executeUpdate();
        ps.close();

        if (rowsDeleted > 0) {
            // Redirect back to manage_orders.jsp
            response.sendRedirect("manage_orders.jsp?msg=Order+deleted+successfully");
        } else {
            out.println("<h3>Order not found or already deleted.</h3>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>Error deleting order: " + e.getMessage() + "</h3>");
    }
%>
