<%@ page import="it.polimi.Db2_Project.entities.ServicePackageEntity" %>
<%@ page import="it.polimi.Db2_Project.entities.ServiceType" %>
<%@ page import="it.polimi.Db2_Project.entities.OptionalProductEntity" %>
<%@ page import="it.polimi.Db2_Project.entities.OrderEntity" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

        .container{
            padding-left: 15%;
        }

        .box {
            transition: box-shadow .3s;
            padding-left: 5%;
            width: 70%;
            margin: 50px;
            border-radius:10px;
            border: 1px solid #ccc;
            background: white;
        }

        .bottomPart{
            text-align: center;
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

<jsp:useBean id="pendingOrder" scope="session" type="it.polimi.Db2_Project.entities.OrderEntity"/>
<div class="container">
    <div class="box">
        <h2>Recap</h2>
        <h3>Service Package:</h3>

        <p>Name: ${pendingOrder.servicePackage.name}</p>

        <%
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String startDate = sdf.format(pendingOrder.getStartDate());
        %>

        <p>Start date: <%=startDate%></p>
        <p>It includes</p>
        <ul>
            <c:forEach var="service" items="${pendingOrder.servicePackage.services}" varStatus="row">
                <c:choose>

                    <c:when test="${service.type.equals(ServiceType.FIXED_PHONE)}">
                        <li>
                            <p> Unlimited fixed phone calls </p>
                        </li>
                    </c:when>

                    <c:when test="${service.type.equals(ServiceType.MOBILE_PHONE)}">
                        <li>
                            <p> ${service.numberOfMinutes} MIN (mobile)  with extra fee for min: ${service.extraMinutesFee}€ </p>
                        </li>
                        <li>
                            <p> ${service.numberOfSms} SMS (mobile)  with extra fee for sms: ${service.extraSmsFee}€ </p>
                        </li>
                    </c:when>

                    <c:when test="${service.type.equals(ServiceType.MOBILE_INTERNET)}">
                        <li>
                            <p> ${service.numberOfGb} GB (mobile) with extra fee for GB: ${service.extraGbFee}€ </p>
                        </li>
                    </c:when>

                    <c:when test="${service.type.equals(ServiceType.FIXED_INTERNET)}">
                        <li>
                            <p> ${service.numberOfGb} GB (fixed) with extra fee for GB: ${service.extraGbFee}€ </p>
                        </li>
                    </c:when>
                </c:choose>
            </c:forEach>
        </ul>
        <p> Period: ${pendingOrder.validityPeriod.numberOfMonths} months </p>
        <p> Price: <b>${pendingOrder.validityPeriod.monthlyFee}€ /month </b></p>
        <br/>

        <c:if test="${!pendingOrder.optionalProducts.isEmpty()}">
            <p>Optional products added:</p>
            <ul>
                <c:forEach var="optionalProduct" items="${pendingOrder.optionalProducts}" varStatus="row">
                    <li>
                        <p> ${optionalProduct.name}: <b>${optionalProduct.monthlyFee}€ /month</b></p>
                    </li>
                </c:forEach>
            </ul>
            <br/>
        </c:if>

        <%
            float totalCost;
            totalCost = pendingOrder.getValidityPeriod().getMonthlyFee();
            for(OptionalProductEntity op : pendingOrder.getOptionalProducts())
                totalCost+=op.getMonthlyFee();
        %>

        <p>Total price = <b><%=totalCost%>€ /month</b></p>
    </div>
</div>



<div class="bottomPart">
    <c:choose>
        <c:when test="${empty user}">
            <a href="${pageContext.request.contextPath}/login?notGuest=true">Continue...</a>
        </c:when>
        <c:otherwise>
            <form action="confirmation" method="post">
                <button type="submit" class="button" name="buy" value="true"> Buy </button>
                <button type="submit" class="button" name="buy" value="false"> Fake Buy </button>
            </form>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>