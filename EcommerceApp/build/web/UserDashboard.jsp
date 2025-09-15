<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<% if("admin".equals) { %>
<div class="container">
    <h2>All User Details</h2>
    <table>
        <tr>
            <th>User ID</th>
            <th>Name</th>
            <th>Address</th>
        </tr>
        <%
            try {
                PreparedStatement ps = conn.prepareStatement("SELECT id, name, address FROM user ORDER BY id DESC");
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("address") %></td>
            </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</div>
<% } %>
