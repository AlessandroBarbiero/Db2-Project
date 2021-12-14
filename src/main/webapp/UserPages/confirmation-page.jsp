<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

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

        .userBar {
            height: 50px;
            background: lightgray;
            width:100%;
        }

        .userText {
            position: absolute;
            line-height: 25px;
            right: 0px;
            width: 30%;
            padding-left: 10px;
        }
    </style>
</head>
<body>
<h1> Confirmation Page </h1>
<br/>

<c:catch var="missingUser">
    <jsp:useBean id="user" scope="session" type="it.polimi.Db2_Project.entities.UserEntity"/>
</c:catch>

<div class="userBar">
    <div class="userText">
        <c:choose>
            <c:when test="${empty user}">
                <p> GUEST </p>
            </c:when>
            <c:otherwise>
                <p> Hi, ${user.username}! Nice to see you </p>
            </c:otherwise>
        </c:choose>
    </div>
</div>




<c:choose>
    <c:when test="${empty user}">
        <a href="${pageContext.request.contextPath}/login?notGuest=true">Continue...</a>
    </c:when>
    <c:otherwise>
        <form action="confirmation">
            <button type="submit" name="buy" value="true"> Buy </button>
            <button type="submit" name="buy" value="false"> Fake Buy </button>
        </form>
    </c:otherwise>
</c:choose>

</body>
</html>