<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    try {
        // Fetch cart items
        PreparedStatement psCart = conn.prepareStatement(
            "SELECT product_id, quantity, price FROM Cart c JOIN products p ON c.product_id=p.product_id WHERE user_email=?"
        );
        psCart.setString(1, email);
        ResultSet rsCart = psCart.executeQuery();

        double totalAmount = 0.0;
        while (rsCart.next()) {
            int qty = rsCart.getInt("quantity");
            double price = rsCart.getDouble("price");
            totalAmount += price * qty;
        }

        if (totalAmount == 0) {
            out.println("<p>Your cart is empty. <a href='home.jsp'>Go shopping</a></p>");
            return;
        }

        // Insert order
        PreparedStatement psOrder = conn.prepareStatement(
            "INSERT INTO orders (user_email, total_amount, status) VALUES (?, ?, 'Pending')",
            Statement.RETURN_GENERATED_KEYS
        );
        psOrder.setString(1, email);
        psOrder.setDouble(2, totalAmount);
        psOrder.executeUpdate();

        ResultSet rsOrder = psOrder.getGeneratedKeys();
        int orderId = 0;
        if (rsOrder.next()) {
            orderId = rsOrder.getInt(1);
        }

        // Insert order_items
        rsCart.beforeFirst(); // Reset cursor
        while (rsCart.next()) {
            int productId = rsCart.getInt("product_id");
            int qty = rsCart.getInt("quantity");
            double price = rsCart.getDouble("price");

            PreparedStatement psItem = conn.prepareStatement(
                "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)"
            );
            psItem.setInt(1, orderId);
            psItem.setInt(2, productId);
            psItem.setInt(3, qty);
            psItem.setDouble(4, price);
            psItem.executeUpdate();
            psItem.close();
        }

        // Clear cart
        PreparedStatement psClear = conn.prepareStatement("DELETE FROM Cart WHERE user_email=?");
        psClear.setString(1, email);
        psClear.executeUpdate();

        out.println("<p>? Order placed successfully! <a href='orders.jsp'>View Orders</a></p>");

        rsCart.close();
        psCart.close();
        rsOrder.close();
        psOrder.close();
        psClear.close();

    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error placing order: " + e.getMessage());
    }
%>
