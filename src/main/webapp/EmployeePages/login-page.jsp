<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Telco-Management</title>
</head>
<body>
<h1><%= "Telco Login Page" %>
</h1>
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

</body>
</html>