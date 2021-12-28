<%@ page import="it.polimi.Db2_Project.entities.UserEntity" %>
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


        * {
            box-sizing: border-box;
        }

        .column1 {
            float: left;
            width: 70%;
            padding: 10px;
            background-color: white;
        }

        .column2 {
            float: left;
            width: 30%;
            padding: 10px;
            background-color: white;
        }

        /* Clear floats after the columns */
        .row:after {
            content: "";
            display: table;
            clear: both;
        }

        body{
            background: white;
        }
        .box {
            transition: box-shadow .3s;
            width: 300px;
            margin: 50px;
            border-radius:10px;
            border: 1px solid #ccc;
            background: white;
        }
        .box:hover {
            box-shadow: 0 0 11px rgba(33,33,33,.4);
        }

        .container {
            display: flex; /* or inline-flex */
            flex-wrap: wrap;
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

        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
        }
    </style>
</head>
<body>

<c:catch var="missingUser">
    <jsp:useBean id="user" scope="session" type="it.polimi.Db2_Project.entities.UserEntity"/>
</c:catch>

<h1>Home Page</h1>
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

<br/>
<c:catch var="missingPackagesException">
    <jsp:useBean id="packages" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ServicePackageEntity>"/>
</c:catch>

<c:if test="${missingPackagesException != null}">
    <jsp:forward page="/home-user" />
</c:if>

<c:catch var="missingRejectedOrdersException">
    <jsp:useBean id="rejectedOrders" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.OrderEntity>"/>
</c:catch>


<div class="row">
    <div class="column1">
        <h2>Select one service package from the available ones:</h2>
        <div class="container">
        <c:forEach var="pack" items="${packages}" varStatus="row">
            <a href="buy?chosen=${pack.id}">
                <div class="box">
                        <h2 style="text-align: center">${pack.name}</h2>
                        <h5 style="text-align: center"> It includes</h5>
                        <ul>
                            <c:forEach var="service" items="${pack.services}" varStatus="row">
                                <c:if test="${service.numberOfMinutes > 0}">
                                    <li>
                                            <p> ${service.numberOfMinutes} MIN </p>
                                    </li>
                                </c:if>
                                <c:if test="${service.numberOfSms > 0}">
                                    <li>
                                            <p> ${service.numberOfSms} SMS </p>
                                    </li>
                                </c:if>
                                <c:if test="${service.numberOfGb > 0}">
                                    <li>
                                          <p> ${service.numberOfGb} GB </p>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>
                        <h5 style="text-align: center"> Periods</h5>
                        <ul>
                            <c:forEach var="periods" items="${pack.possibleValidityPeriods}" varStatus="row">
                                <li>
<%--                                    <c:if test="${periods.monthlyFee }">--%>
<%--                                        --%>
<%--                                    </c:if>--%>
                                    <p> ${periods.monthlyFee} € /month PER ${periods.numberOfMonths} months</p>
                                </li>

                            </c:forEach>
                        </ul>


                </div>
            <a/>
        </c:forEach>
        </div>
    </div>
    <div class="column2">
        <h2>List of rejected orders</h2>
        <c:if test="${user != null}">
            <table>
                <tr>
                    <th>Package included</th>
                    <th>Date</th>
                    <th>Total cost</th>
                </tr>
                <c:forEach var="rejected" items="${rejectedOrders}" varStatus="row">
                    <tr>
                        <td> <a href="retrieve-order?orderId=${rejected.id}"> ${rejected.servicePackage.name} </a></td>
                        <td>${rejected.creation}</td>
                        <td>${rejected.totalPrice}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>





    </div>
</div>

</body>
</html>