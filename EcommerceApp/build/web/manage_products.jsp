<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    // Check admin session
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String message = "";

    // Delete product if requested
    String deleteId = request.getParameter("delete");
    if (deleteId != null) {
        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE product_id=?");
            ps.setInt(1, Integer.parseInt(deleteId));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "✅ Product deleted successfully!";
            } else {
                message = "⚠️ Product not found.";
            }
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    // Fetch all products
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products ORDER BY product_id DESC");
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Products</title>
<style>
/* Your existing CSS here */
</style>
</head>
<body>

<header>
    <h1>Manage Products</h1>
    <div>
        <a href="admin.jsp" class="back">🏠 Dashboard</a>
        <a href="addProducts.jsp" class="add">➕ Add Product</a>
        <a href="logout.jsp" class="logout">Logout</a>
    </div>
</header>

<div class="container">
    <h2>All Products</h2>

    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price (₹)</th>
            <th>Actions</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%= rs.getInt("product_id") %></td>
            <td>
                <% String img = rs.getString("image_url"); %>
                <% if (img != null && !img.isEmpty()) { %>
                    <img src="<%= img %>" alt="Product" width="60" height="60">
                <% } else { %>
                    N/A
                <% } %>
            </td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= rs.getDouble("price") %></td>
            <td>
                <a class="btn edit" href="editProduct.jsp?id=<%= rs.getInt("product_id") %>">✏️ Edit</a>
                <a class="btn delete" href="manage_products.jsp?delete=<%= rs.getInt("product_id") %>" 
                   onclick="return confirm('Are you sure you want to delete this product?');">🗑️ Delete</a>
            </td>
        </tr>
        <% } %>
    </table>
</div>

</body>
</html>
