<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    double total = 0.0;

    PreparedStatement ps = conn.prepareStatement(
        "SELECT c.id AS cart_id, p.name, p.price, p.image_url, c.quantity " +
        "FROM Cart c JOIN products p ON c.product_id = p.product_id " +
        "WHERE c.user_email=?"
    );
    ps.setString(1, email);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Cart</title>
</head>
<body>
<h2>My Cart</h2>

<%
    boolean hasItems = false;
%>
<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>Image</th>
        <th>Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>
        <th>Action</th>
    </tr>
<%
    while (rs.next()) {
        hasItems = true;
        int qty = rs.getInt("quantity");
        double price = rs.getDouble("price");
        double subtotal = price * qty;
        total += subtotal;
%>
    <tr>
        <td><img src="<%= rs.getString("image_url") %>" width="60" height="60"></td>
        <td><%= rs.getString("name") %></td>
        <td>?<%= price %></td>
        <td><%= qty %></td>
        <td>?<%= subtotal %></td>
        <td>
            <form method="post" action="removeFromCart.jsp">
                <input type="hidden" name="cart_id" value="<%= rs.getInt("cart_id") %>">
                <button type="submit">Remove</button>
            </form>
        </td>
    </tr>
<%
    }
%>
</table>

<%
    if (!hasItems) {
        out.println("<p>Your cart is empty.</p>");
    } else {
%>
    <h3>Total: ?<%= total %></h3>
    <form method="post" action="checkout.jsp">
        <button type="submit">Proceed to Checkout</button>
    </form>
<%
    }
%>
</body>
</html>
