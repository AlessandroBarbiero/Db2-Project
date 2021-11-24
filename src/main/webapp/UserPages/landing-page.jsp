<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <title>Telco-Service</title>
</head>

<body>
<h1><%= "Landing Page!" %>
</h1>

<form action="registration" method="post">
    <table style="width: 50%">
        <tr>
            <td>Username</td>
            <td><input type="text" name="username" /></td>
        </tr>
        <tr>
            <td>New Password</td>
            <td><input type="password" name="password" /></td>
        </tr>
        <tr>
            <td>Email</td>
            <td><input type="text" name="email" /></td>
        </tr></table>
    <input type="submit" value="Submit" /></form>

<br/>

</body>

</html>


