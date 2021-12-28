<%@ page import="it.polimi.Db2_Project.web.user.RegistrationServlet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <title>Telco-Service</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Audiowide">
    <style>
        h1 {
            font-family: "Audiowide", sans-serif;
            font-size:300%;
            text-align:center;
        }
        .box{
            padding-left: 25%;
        }

    </style>
</head>

<body>
<h1> Landing Page! </h1>
<div class="box">
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
        </tr>
    </table>

    <input type="submit" value="Register" />
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
    <input type="submit" value="Login" />
</form>

<br/>

<%
    if(request.getParameter("notGuest") == null && request.getSession().getAttribute("pendingOrder")==null){
%>
        <a href="${pageContext.request.contextPath}/home-user">Continue as guest</a>
<%
    }
%>

</div>
</body>

</html>


