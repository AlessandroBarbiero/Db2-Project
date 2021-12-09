<%@ page import="it.polimi.Db2_Project.entities.UserEntity" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Telco-Service</title>
    <style>
        * {
            box-sizing: border-box;
        }

        /* Create two equal columns that floats next to each other */
        .column {
            float: left;
            width: 50%;
            padding: 10px;

        }

        /* Clear floats after the columns */
        .row:after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
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
<c:catch var="missingPackagesException">
    <jsp:useBean id="packages" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ServicePackageEntity>"/>
</c:catch>

<c:if test="${missingPackagesException != null}">
    <jsp:forward page="/home-user" />
</c:if>


<div class="row">
    <div class="column" style="background-color: #ffffcc;">
        <h2>Column 1</h2>
        <p>Some text..</p>
    </div>
    <div class="column" style="background-color: #ffffcc;">
        <h2>Column 2</h2>
        <p>Some text..</p>
    </div>
</div>

</body>
</html>