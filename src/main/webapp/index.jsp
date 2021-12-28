<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Page Dispatcher</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Audiowide">
    <style>

        h1 {
            font-family: "Audiowide", sans-serif;
            font-size:300%;
            text-align:center;
        }

        body {
            width: 500px;
            margin: auto;
        }

        .button {
            background-color: white; /* Green */
            border: 2px solid #e7e7e7;
            color: black;
            padding: 16px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            transition-duration: 0.4s;
            cursor: pointer;
            min-width: 40%;
        }

        .button:hover {background-color: #e7e7e7;}

        div{
            text-align:center;
        }

    </style>
</head>

<body>
<h1>Telco Company</h1>

<div>
    <p>Please select your role to enter the Telco company site.</p>
    <a href="home-employee">
        <button class="button">Employee</button>
    </a>
    <br>
    <br>
    <a href="login">
        <button class="button">User</button>
    </a>

</div>


</body>
</html>