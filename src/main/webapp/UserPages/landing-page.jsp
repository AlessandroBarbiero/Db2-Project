<%@ page import="it.polimi.Db2_Project.web.user.RegistrationServlet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <title>Telco-Service</title>
    <link rel="stylesheet" href="../style.css">
</head>

<body>
<h1> <%= "Landing Page!" %> </h1>

<!-- REGISTRATION FORM -->
<form action="registration" method="post">
    <table style="width: 50%">
        <tr>
            <td>Username</td>
            <td><input type="text" name="username" required/></td>
        </tr>
        <tr>
            <td>New Password</td>
            <td><input type="password" name="password" required/></td>
        </tr>
        <tr>
            <td>Email</td>
            <td><input type="email" name="email"/></td>
        </tr></table>
    <input type="submit" value="Submit" />
</form>

    <p>
        <%
            String errorString = (String)request.getSession().getAttribute(RegistrationServlet.getErrorString());
            if(errorString!=null) {
                out.println("<font color = red>" + errorString + " </font>");
                request.getSession().removeAttribute(RegistrationServlet.getErrorString());
            }
        %>
    </p>

<br/>

<!-- LOGIN FORM -->
<form action="login" method="post">
    <table style="width: 50%">
        <tr>
            <td>Username</td>
            <td><input type="text" name="username" required/></td>
        </tr>
        <tr>
            <td>Password</td>
            <td><input type="password" name="password" required/></td>
        </tr>
        </table>
    <input type="submit" value="Submit" />
</form>

<br/>

    <a href="${pageContext.request.contextPath}/home-user">Continue as guest</a>

</body>

</html>


