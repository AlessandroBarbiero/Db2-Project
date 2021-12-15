<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        body{
            text-align:center;
        }

        * {
            box-sizing: border-box;
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

<h1>Buy Page</h1>
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

<c:catch var="missingPackagesException">
    <jsp:useBean id="packages" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ServicePackageEntity>"/>
</c:catch>

<c:catch var="missingPeriodsException">
    <jsp:useBean id="validityPeriods" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ValidityPeriodEntity>"/>
</c:catch>

<br/>
<br/>
<form action="buy" method="post">
    <label for="packages">Choose a package:</label>
    <select name="packages" id="packages" onchange="window.location = 'buy?chosen=' + document.getElementById('packages').value">
        <c:forEach var="pack" items="${packages}" varStatus="row">
            <c:if test="${chosenPack==pack.id}" >
                <option value="${pack.id}" selected> ${pack.name} </option>
            </c:if>
            <c:if test="${chosenPack != pack.id}" >
                <option value="${pack.id}"> ${pack.name} </option>
            </c:if>
        </c:forEach>
    </select>

    <br/>
    <br/>

    <label for="periods">Choose a validity period:</label>
    <select name="periods" id="periods">
        <c:forEach var="period" items="${periods}" varStatus="row">
          <option value="${period.id}"> ${period.monthlyFee} €/month per ${period.numberOfMonths} months </option>
        </c:forEach>
    </select>

    <br/>
    <br/>


    <c:if test="${optionalProducts.size() > 0}" >
        <label for="optionalProducts"> Select optional products: </label>
    </c:if>
    <c:if test="${optionalProducts.size() == 0}" >
        No optional products available
    </c:if>
    <span id="optionalProducts">
        <c:forEach var="optionalProduct" items="${optionalProducts}" varStatus="row">
            <input type="checkbox" id="op${optionalProduct.getId()}" name="optionalProducts" value="${optionalProduct.getId()}">
            <label for="op${optionalProduct.getId()}">${optionalProduct.getName()}</label>
            <br/>
        </c:forEach>
    </span>

    <c:if test="${optionalProducts.size() == 0}" >
        <br/>
    </c:if>
    <br/>

    <label for="startDate"> Select starting date: </label>
    <input id="startDate" name="startDate" type="date">

    <br/>
    <br/>

    <input type="submit" value="CONFIRM">
</form>

</body>
</html>