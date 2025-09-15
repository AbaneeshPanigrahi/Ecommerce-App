<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    ResultSet rs = null;
    try {
        Statement st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM products ORDER BY product_id DESC");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Happy Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#f8f9fa; color:#333; }

        /* Header */
        header { background:#042352; color:white; display:flex; align-items:center; justify-content:space-between; padding:12px 20px; }
        .logo { font-size:1.6rem; font-weight:bold; color:white; text-decoration:none; }
        .search-bar { flex:1; margin:0 15px; display:flex; }
        .search-bar input { width:100%; padding:8px 12px; border:none; border-radius:4px 0 0 4px; }
        .search-bar button { padding:8px 12px; border:none; background:#027ef2; border-radius:0 4px 4px 0; cursor:pointer; transition:0.3s; }
        .search-bar button:hover { background:white; }
        .user-cart a { color:white; text-decoration:none; font-weight:500; margin-left:15px; transition:0.3s; }
        .user-cart a:hover { text-decoration:underline; }

        /* Profile Button */
        .profile { background: #4f46e5; color: white !important; padding: 6px 12px; border-radius: 20px; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: background 0.3s, transform 0.2s; }
        .profile:hover { background: #4338ca; transform: scale(1.05); text-decoration: none; color: #fff !important; }

        /* Container */
        .container { display:flex; padding:20px; gap:20px; flex-wrap:wrap; justify-content:center; }

        /* Product Cards */
        .products { display:grid; grid-template-columns:repeat(auto-fill, minmax(220px,1fr)); gap:20px; flex:1; }
        .card { background:white; border-radius:8px; padding:15px; text-align:center; box-shadow:0 2px 6px rgba(0,0,0,0.05); transition:0.3s; }
        .card:hover { box-shadow:0 4px 12px rgba(0,0,0,0.1); transform:translateY(-3px); }
        .card img { width:160px; height:160px; object-fit:contain; margin-bottom:10px; }
        .card h4 { font-size:1.1rem; margin:6px 0; color:#0d6efd; }
        .card p { font-size:0.9rem; margin:5px 0; color:#555; }
        .price { font-weight:bold; color:#dc3545; margin:8px 0; font-size:1rem; }
        .btn { background:#198754; border:none; padding:8px 14px; color:white; border-radius:5px; cursor:pointer; font-weight:500; transition:0.3s; }
        .btn:hover { background:#157347; }

        /* Responsive */
        @media(max-width:768px){
            .container { flex-direction:column; padding:10px; }
            .products { grid-template-columns:repeat(auto-fill,minmax(160px,1fr)); gap:15px; }
        }
    </style>
</head>
<body>

<header>
    <a href="home.jsp" class="logo">HappyStore</a>
    <div class="search-bar">
        <input type="text" placeholder="Search products...">
        <button><i class="fas fa-search"></i></button>
    </div>
    <div class="user-cart">
        <a href="user.jsp" class="profile"><i class="fas fa-user"></i> Profile</a>
        <a href="order.jsp"><i class="fas fa-box"></i> Orders</a>
        <a href="cart.jsp"><i class="fas fa-shopping-cart"></i> Cart</a>
        <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</header>

<div class="container">
    <div class="products">
    <%
        while(rs != null && rs.next()){
    %>
        <div class="card">
            <img src="<%= rs.getString("image_url") %>" alt="Product">
            <h4><%= rs.getString("name") %></h4>
            <p><%= rs.getString("description") %></p>
            <p class="price">₹<%= rs.getDouble("price") %></p>
            <form method="post" action="addToCart.jsp">
                <input type="hidden" name="product_id" value="<%= rs.getInt("product_id") %>">
                <button type="submit" class="btn">Add to Cart</button>
            </form>
        </div>
    <%
        }
    %>
    </div>
</div>

</body>
</html>
