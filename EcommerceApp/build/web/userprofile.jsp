<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String gender = request.getParameter("gender");
    String address = request.getParameter("address");
    String email = request.getParameter("email");

    try {
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE user SET name=?, phone=?, gender=?, address=?, email=? WHERE id=?"
        );
        ps.setString(1, name);
        ps.setString(2, phone);
        ps.setString(3, gender);
        ps.setString(4, address);
        ps.setString(5, email);
        ps.setInt(6, id);

        int updated = ps.executeUpdate();
        if (updated > 0) {
            out.println("<script>alert('Profile updated successfully!'); window.location='user.jsp';</script>");
        } else {
            out.println("<script>alert('Update failed. Try again.'); window.location='user.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error occurred!'); window.location='user.jsp';</script>");
    }
%>
