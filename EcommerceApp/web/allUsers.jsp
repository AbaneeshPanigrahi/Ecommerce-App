<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%
    // Check if user is admin
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<div class="container">
    <h2>All User Details</h2>
    <table border="1" cellpadding="10">
        <tr>
            <th>User ID</th>
            <th>Name</th>
            <th>Address</th>
        </tr>
        <%
            try {
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT id, fullname, address FROM user ORDER BY id DESC"
                );
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("fullname") %></td>
            <td><%= rs.getString("address") %></td>
        </tr>
        <%
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</div>
