<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    String image_url = request.getParameter("image_url");

    try {
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE products SET name=?, description=?, price=?, image_url=? WHERE id=?"
        );
        ps.setString(1, name);
        ps.setString(2, description);
        ps.setDouble(3, price);
        ps.setString(4, image_url);
        ps.setInt(5, id);

        int updated = ps.executeUpdate();
        if (updated > 0) {
            response.sendRedirect("admin_products.jsp");
        } else {
            out.println("<script>alert('Update failed!'); window.location='admin_products.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='admin_products.jsp';</script>");
    }
%>
