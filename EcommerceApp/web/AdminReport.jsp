<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db.jsp" %>
<%
    String email = (String) session.getAttribute("admin_email");
    if (email == null) {
        response.sendRedirect("AdminLogin.jsp");
        return;
    }

    if("POST".equalsIgnoreCase(request.getMethod())){
        String siteName = request.getParameter("siteName");
        String contactEmail = request.getParameter("contactEmail");
        String supportPhone = request.getParameter("supportPhone");

        PreparedStatement ps = conn.prepareStatement(
            "UPDATE settings SET site_name=?, contact_email=?, support_phone=? WHERE id=1"
        );
        ps.setString(1, siteName);
        ps.setString(2, contactEmail);
        ps.setString(3, supportPhone);
        ps.executeUpdate();
        out.println("<p style='color:green;'>Settings Updated Successfully!</p>");
    }

    PreparedStatement ps = conn.prepareStatement("SELECT * FROM settings WHERE id=1");
    ResultSet rs = ps.executeQuery();
    rs.next();
%>

<h2>Admin Settings</h2>
<form method="post">
    <label>Site Name:</label>
    <input type="text" name="siteName" value="<%= rs.getString("site_name") %>" /><br/><br/>
    <label>Contact Email:</label>
    <input type="email" name="contactEmail" value="<%= rs.getString("contact_email") %>" /><br/><br/>
    <label>Support Phone:</label>
    <input type="text" name="supportPhone" value="<%= rs.getString("support_phone") %>" /><br/><br/>
    <input type="submit" value="Update Settings" />
</form>
