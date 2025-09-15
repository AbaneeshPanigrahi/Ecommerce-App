<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int orderId = Integer.parseInt(request.getParameter("order_id"));
    String status = request.getParameter("status");

    try {
        PreparedStatement ps = conn.prepareStatement("UPDATE orders SET status=? WHERE id=?");
        ps.setString(1, status);
        ps.setInt(2, orderId);
        ps.executeUpdate();
        response.sendRedirect("manage_orders.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
