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
    <jsp:useBean id="purchasesPerPackage" scope="request" type="java.util.Map<java.lang.String, java.lang.Integer>"/>
</c:catch>

<c:if test="${missingElement != null}">
    <jsp:forward page="/sales-report" />
</c:if>

<jsp:useBean id="purchasesPerPackageAndVP" scope="request" type="java.util.List<it.polimi.Db2_Project.utility.PurchasesBean>"/>

<div class="central-box">
    <table>
        <tr>
            <td>Package Name</td>
            <td>Total Purchases</td>
        </tr>
        <c:forEach var="value" items="${purchasesPerPackage}">
            <tr>
                <td>${value.key}</td>
                <td>${value.value}</td>
            </tr>
        </c:forEach>
    </table>

    <br/>

    <table>
        <tr>
            <td>Package Name</td>
            <td>Number Of Months</td>
            <td>MonthlyFee</td>
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
</div>
<br/>
</body>
</html>