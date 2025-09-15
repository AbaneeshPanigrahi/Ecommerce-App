<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    try {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id=?");
        ps.setInt(1, id);
        ps.executeUpdate();
        response.sendRedirect("admin_products.jsp");
    } catch(Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
