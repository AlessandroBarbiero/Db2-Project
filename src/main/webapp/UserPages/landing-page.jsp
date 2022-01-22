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
        h2 {
            font-family: "Audiowide", sans-serif;
            font-size:150%;
            text-align:center;
        }

        form {
            border: 3px solid #f1f1f1;
            width: 70%;
            text-align: center;
            display: table;
        }

        #form1 {
            margin-left: auto;
        }

        #form2 {
            margin-right: auto;
        }

        input[type=text], input[type=password], input[type=email] {
            width: 80%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .container, #guest {
            display: inline;
        }

        button, #guest {
            background-color: #04AA6D;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            cursor: pointer;
            width: 30%;
        }

        button:hover, #guest:hover {
            opacity: 0.8;
        }

        .column {
            float: left;
            width: 48%;
            padding: 10px;
            background-color: white;
        }

        /* Clear floats after the columns */
        .row:after {
            content: "";
            display: table;
            clear: both;
        }

        .pair{
            display: table-row;
            margin: auto;
        }

        .pair label, .pair input {
            display: table-cell;
        }

    </style>
</head>

<body>
<h1> Landing Page! </h1>

<div class="row">
    <div class="column">
        <!-- LOGIN FORM -->
        <form action="login" method="post" id="form1">
            <div class="container">
                <h2>Login</h2>
                <p class="pair">
                    <label><b>Username</b></label>
                    <input type="text" name="username" required>
                </p>

                <p class="pair">
                    <label><b>Password</b></label>
                    <input type="password" name="password" required>
                </p>

                <br>

                <button type="submit" value="Login">Login</button>

                <%
                    if(request.getParameter("notGuest") == null && request.getSession().getAttribute("pendingOrder")==null){
                %>
                <br>
                or
                <br>
                <a href="${pageContext.request.contextPath}/home-user"><div id="guest">Continue as guest</div></a>
                <%
                    }
                %>
            </div>
        </form>




    </div>
    <div class="column">
        <!-- REGISTRATION FORM -->
        <form action="registration" method="post" id="form2">
            <div class="container">
                <h2>Registration</h2>
                <p class="pair">
                    <label><b>Username</b></label>
                    <input type="text" name="username" required>
                </p>

                <p class="pair">
                    <label><b>New Password</b></label>
                    <input type="password" name="password" required>
                </p>

                <p class="pair">
                    <label><b>Email</b></label>
                    <input type="email" name="email" required>
                </p>

                <br>

                <button type="submit" value="Register">Register</button>
            </div>
        </form>

    </div>
</div>



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
<br/>

</body>

</html>


