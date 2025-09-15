<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String productIdParam = request.getParameter("product_id");
    if (productIdParam == null || productIdParam.isEmpty()) {
        out.println("Product ID missing!");
        return;
    }

    int productId = Integer.parseInt(productIdParam);

    try {
        // Check if product is already in cart
        PreparedStatement psCheck = conn.prepareStatement(
            "SELECT id, quantity FROM Cart WHERE user_email=? AND product_id=?"
        );
        psCheck.setString(1, email);
        psCheck.setInt(2, productId);
        ResultSet rsCheck = psCheck.executeQuery();

        if (rsCheck.next()) {
            // Update quantity
            int cartId = rsCheck.getInt("id");
            int qty = rsCheck.getInt("quantity") + 1;
            PreparedStatement psUpdate = conn.prepareStatement(
                "UPDATE Cart SET quantity=? WHERE id=?"
            );
            psUpdate.setInt(1, qty);
            psUpdate.setInt(2, cartId);
            psUpdate.executeUpdate();
            psUpdate.close();
        } else {
            // Insert new row
            PreparedStatement psInsert = conn.prepareStatement(
                "INSERT INTO Cart (user_email, product_id, quantity) VALUES (?, ?, 1)"
            );
            psInsert.setString(1, email);
            psInsert.setInt(2, productId);
            psInsert.executeUpdate();
            psInsert.close();
        }

        rsCheck.close();
        psCheck.close();

        response.sendRedirect("cart.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error adding to cart: " + e.getMessage());
    }
%>
