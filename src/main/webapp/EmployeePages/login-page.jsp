<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Telco-Management</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Audiowide">
    <style>
        h1 {
            font-family: "Audiowide", sans-serif;
            font-size:300%;
            text-align:center;
        }

        form {
            border: 3px solid #f1f1f1;
            width: 50%;
            text-align: center;
            margin: auto;
        }

        input[type=text], input[type=password] {
            width: 50%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .container {
            padding: 16px;
        }

        button {
            background-color: #04AA6D;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            cursor: pointer;
            width: 20%;
        }

        button:hover {
            opacity: 0.8;
        }

    </style>
</head>
<body>

<h1>Telco Login Page</h1>

<br/>


<!-- LOGIN FORM -->
<form action="login-employee" method="post">
    <div class="container">
        <label><b>Username</b></label>
        <input type="text" name="username" required>
         </br>
         </br>
         </br>
        <label><b>Password</b></label>
        <input type="password" name="password" required>
         </br>
         </br>
         </br>
        <button type="submit">Login</button>
    </div>
</form>

</body>
</html>