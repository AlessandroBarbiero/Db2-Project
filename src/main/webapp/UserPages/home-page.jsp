<%@ page import="it.polimi.Db2_Project.entities.UserEntity" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Telco-Service</title>
</head>
<body>
<c:catch var="missingUser">
<jsp:useBean id="user" scope="session" type="it.polimi.Db2_Project.entities.UserEntity"/>
</c:catch>

<h1> <%= "Home Page" %> </h1>
<c:choose>
    <c:when test="${empty user}">
        <p style="text-align: right"> GUEST </p>
    </c:when>
    <c:otherwise>
        <p style="text-align: right">Hi, ${user.username}! Nice to see you </p>
    </c:otherwise>
</c:choose>
<br/>

</body>
</html>