<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        h2 {
            text-align: center;
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

        .central-box{
            padding-left: 15%;
            padding-right: 15%;
        }
    </style>
</head>
<body>
<h1> Sales Report </h1>

<c:catch var="missingElement">
    <jsp:useBean id="purchasesPerPackage" scope="request" type="java.util.List<it.polimi.Db2_Project.dto.PurchasesBean>"/>
</c:catch>

<c:if test="${missingElement != null}">
    <jsp:forward page="/sales-report" />
</c:if>


<div class="central-box">
    <table>
        <tr>
            <td>Package Name</td>
            <td>Total Purchases</td>
        </tr>
        <c:forEach var="value" items="${purchasesPerPackage}">
            <tr>
                <td>${value.servicePackageName}</td>
                <td>${value.totalPurchases}</td>
            </tr>
        </c:forEach>
    </table>

    <br/><br/>

    <jsp:useBean id="purchasesPerPackageAndVP" scope="request" type="java.util.List<it.polimi.Db2_Project.dto.PurchasesBean>"/>

    <table>
        <tr>
            <td>Package Name</td>
            <td>Number Of Months</td>
            <td>Monthly Fee</td>
            <td>Total Purchases</td>
        </tr>
        <c:forEach var="tuple" items="${purchasesPerPackageAndVP}">
            <tr>
                <td>${tuple.servicePackageName}</td>
                <td>${tuple.numberOfMonths}</td>
                <td>${tuple.monthlyFee}</td>
                <td>${tuple.totalPurchases}</td>
            </tr>
        </c:forEach>
    </table>
    <br/><br/>

    <jsp:useBean id="salesPerPackage" scope="request" type="java.util.List<it.polimi.Db2_Project.dto.SalesBean>"/>
    <table>
        <tr>
            <td>Package Name</td>
            <td>Revenue without Optional Products</td>
            <td>Revenue with Optional Products</td>
        </tr>
        <c:forEach var="sale" items="${salesPerPackage}">
            <tr>
                <td>${sale.servicePackageName}</td>
                <td>${sale.revenueWithoutOpProd}</td>
                <td>${sale.revenueWithOpProd}</td>
            </tr>
        </c:forEach>
    </table>
    <br/><br/>

    <jsp:useBean id="avgPerPackage" scope="request" type="java.util.List<it.polimi.Db2_Project.dto.AverageBean>"/>
    <table>
        <tr>
            <td>Package Name</td>
            <td>Average optional products sold</td>
        </tr>
        <c:forEach var="value" items="${avgPerPackage}">
            <tr>
                <td>${value.servicePackageName}</td>
                <td>${value.avg}</td>
            </tr>
        </c:forEach>
    </table>
    <br/>

    <jsp:useBean id="bestSeller" scope="request" type="java.util.List<it.polimi.Db2_Project.dto.BestSellerOptProdBean>"/>
    <h2>Best Seller Optional Product</h2>
    <table>
        <tr>
            <td>Optional Product Name</td>
            <td>Revenue</td>
        </tr>
        <c:forEach var="value" items="${bestSeller}">
            <tr>
                <td>${value.optionalProductName}</td>
                <td>${value.revenue}</td>
            </tr>
        </c:forEach>
    </table>
    <br/>

    <jsp:useBean id="insolventUsers" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.UserEntity>"/>

    <h2>Insolvent Users</h2>
    <table>
        <tr>
            <td>Username</td>
            <td>Email</td>
        </tr>
        <c:forEach var="user" items="${insolventUsers}">
            <tr>
                <td>${user.username}</td>
                <td>${user.email}</td>
            </tr>
        </c:forEach>
    </table>

    <br/>

    <jsp:useBean id="suspendedOrders" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.OrderEntity>"/>

    <h2>Suspended Orders</h2>
    <table>
        <tr>
            <td>User</td>
            <td>Date</td>
            <td>Service Package</td>
            <td>Number of months</td>
            <td>Monthly fee</td>
            <td>Total Price</td>
        </tr>
        <c:forEach var="order" items="${suspendedOrders}">
            <tr>
                <td>${order.user.username}</td>
                <td>${order.creation}</td>
                <td>${order.servicePackage.name}</td>
                <td>${order.validityPeriod.numberOfMonths}</td>
                <td>${order.validityPeriod.monthlyFee}</td>
                <td>${order.totalPrice}</td>
            </tr>
        </c:forEach>
    </table>

    <br/>

    <jsp:useBean id="alerts" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.BlacklistEntity>"/>

    <h2>Alerts</h2>
    <table>
        <tr>
            <td>UserId</td>
            <td>Username</td>
            <td>Email</td>
            <td>Last Rejection</td>
            <td>Amount</td>
        </tr>
        <c:forEach var="alert" items="${alerts}">
            <tr>
                <td>${alert.userId}</td>
                <td>${alert.username}</td>
                <td>${alert.email}</td>
                <td>${alert.lastRejection}</td>
                <td>${alert.amount}</td>
            </tr>
        </c:forEach>
    </table>
</div>
<br/>
</body>
</html>