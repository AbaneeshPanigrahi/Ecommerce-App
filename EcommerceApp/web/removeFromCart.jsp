<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String cartIdParam = request.getParameter("cart_id");
    if (cartIdParam != null) {
        int cartId = Integer.parseInt(cartIdParam);

        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM Cart WHERE id=? AND user_email=?");
            ps.setInt(1, cartId);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    response.sendRedirect("cart.jsp");
%>
