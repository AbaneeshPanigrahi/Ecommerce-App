<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Manage Products</title>
        <style>
            body {
                font-family: Arial;
                background:#f3f4f6;
                margin:0;
            }
            header {
                background:#232f3e;
                color:white;
                padding:15px;
            }
            .container {
                max-width:900px;
                margin:20px auto;
                background:white;
                padding:20px;
                border-radius:8px;
            }
            table {
                width:100%;
                border-collapse:collapse;
                margin-top:20px;
            }
            table th, table td {
                border:1px solid #ddd;
                padding:10px;
                text-align:center;
            }
            table th {
                background:#f9fafb;
            }
            .btn {
                padding:6px 12px;
                border:none;
                border-radius:5px;
                cursor:pointer;
            }
            .add-btn {
                background:#10b981;
                color:white;
                margin-bottom:15px;
            }
            .del-btn {
                background:#ef4444;
                color:white;
            }
        </style>
    </head>
    <body>
        <header><h2>Admin - Manage Products</h2></header>
        <div class="container">
            <form action="addProduct.jsp" method="post">
                <h3>Add Product</h3>
                <input type="text" name="name" placeholder="Product Name" required><br><br>
                <textarea name="description" placeholder="Description"></textarea><br><br>
                <input type="number" step="0.01" name="price" placeholder="Price" required><br><br>
                <input type="text" name="image_url" placeholder="Image URL"><br><br>
                <button type="submit" class="btn add-btn">Add Product</button>
            </form>

            <h3>Existing Products</h3>
            <table>
                <tr><th>ID</th><th>Name</th><th>Price</th><th>Action</th></tr>
                        <%
                            try {
                                Statement st = conn.createStatement();
                                ResultSet rs = st.executeQuery("SELECT * FROM products");
                                while (rs.next()) {
                        %>
                <tr>

                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td>₹<%= rs.getDouble("price") %></td>
                    <td>
                        <form action="delete.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn del-btn">Delete</button>
                        </form>
                        <!-- Edit button/link -->
                        <form action="editProduct.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn">Edit</button>
                        </form>
                    </td>
                </tr>


                <%
                        }
                    } catch(Exception e) { e.printStackTrace(); }
                %>
            </table>
        </div>
    </body>
</html>
