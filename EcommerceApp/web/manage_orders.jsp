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

    ResultSet rs = null;
    try {
        Statement st = conn.createStatement();
        String sql = "SELECT id, user_email, total_amount, status, created_at " +
                     "FROM orders ORDER BY id DESC";
        rs = st.executeQuery(sql);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Orders</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f9fa; padding: 20px; }
        h1 { margin-bottom: 20px; color: #333; }
        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #343a40; color: white; }
        tr:hover { background: #f1f1f1; }
        .btn-details { background:#0d6efd; color:white; padding:6px 12px; border-radius:4px; text-decoration:none; margin-right:5px; }
        .btn-details:hover { background:#0b5ed7; }
        .btn-delete { background:#dc3545; color:white; padding:6px 12px; border-radius:4px; text-decoration:none; }
        .btn-delete:hover { background:#b02a37; }
    </style>
</head>
<body>
    <h1>Manage Orders</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>User Email</th>
            <th>Total Amount</th>
            <th>Status</th>
            <th>Order Date</th>
            <th>Actions</th>
        </tr>
        <%
            while (rs != null && rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("user_email") %></td>
            <td>₹<%= rs.getDouble("total_amount") %></td>
            <td><%= rs.getString("status") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <td>
                <a href="order_details.jsp?order_id=<%= rs.getInt("id") %>" class="btn-details">View Details</a>
                <a href="order_delete.jsp?order_id=<%= rs.getInt("id") %>" 
                   class="btn-delete"
                   onclick="return confirm('Are you sure you want to delete this order?');">
                   Delete
                </a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
