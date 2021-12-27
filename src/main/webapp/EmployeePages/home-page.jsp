<%@ page import="java.util.List" %>
<%@ page import="it.polimi.Db2_Project.entities.ServiceEntity" %>
<%@ page import="it.polimi.Db2_Project.web.employee.OptionalProductCreationServlet" %>
<%@ page import="it.polimi.Db2_Project.web.employee.ServicePackageCreationServlet" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

        body{
            text-align: center;
        }

        .list{
            padding-left: 30%;
            text-align: left;
        }

        .bar {
            height: 50px;
            background: lightgray;
            width:100%;
        }

        .barText {
            position: absolute;
            line-height: 10px;
            right: 0;
            width: 30%;
            padding-left: 10px;
        }

        .button {
            background-color: white; /* Green */
            border: 2px solid #e7e7e7;
            color: black;
            padding: 8px 16px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 15px;
            margin: 4px 2px;
            transition-duration: 0.4s;
            cursor: pointer;
            min-width: 5%;
        }

        .button:hover {background-color: #e7e7e7;}
    </style>
</head>
<body>

<h1>Home Page</h1>

<div class="bar">
    <div class="barText">
        <a href="sales-report">
            <button class="button">Sales Report &#10146;</button>
        </a>
    </div>
</div>

<!-- SERVICE PACKAGE CREATION -->
<form action="service-package-creation" method="post">
    <h2>SERVICE PACKAGE CREATION</h2>

    <label> Insert name:
        <input type="text" name="servicePackageName" required/>
    </label>
    <br />

    <h3>Select the SERVICES to include into this Service Package</h3>

    <c:catch var="missingServicesException">
        <jsp:useBean id="services" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ServiceEntity>"/>
    </c:catch>
    <!-- if the bean is not found I need to redirect to the servlet that will create it -->
    <c:if test="${missingServicesException != null}">
        <jsp:forward page="/home-employee" />
    </c:if>

    <div class="list">
        <c:forEach var="service" items="${services}" varStatus="row">
            <input type="checkbox" id="s${service.id}" name="selected_services" value="${service.id}">
            <label for="s${service.id}">${service.toString()}</label>
            <br />
        </c:forEach>
    </div>

    <br/>
    <hr />

    <h3>Select the VALIDITY PERIODS from which to select for this Service Package</h3>

    <jsp:useBean id="validityPeriods" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ValidityPeriodEntity>"/>

    <div class="list">
        <c:forEach var="validityPeriod" items="${validityPeriods}" varStatus="row">
            <input type="checkbox" id="vp${validityPeriod.id}" name="selected_validity_periods" value="${validityPeriod.id}">
            <label for="vp${validityPeriod.id}">${validityPeriod.toString()}</label>
            <br />
        </c:forEach>
    </div>

    <br/>
    <hr />

    <h3>Select the OPTIONAL PRODUCTS from which to select for this Service Package</h3>

    <jsp:useBean id="optionalProducts" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.OptionalProductEntity>"/>

    <div class="list">
        <c:forEach var="optionalProduct" items="${optionalProducts}" varStatus="row">
            <input type="checkbox" id="op${optionalProduct.name}" name="selected_optional_products" value="${optionalProduct.name}">
            <label for="op${optionalProduct.name}">${optionalProduct.toString()}</label>
            <br />
        </c:forEach>
    </div>

    <br/>
    <p>
        <%
            if("true".equals(request.getParameter("success")))
                out.println("<font color = green>" + "ServicePackage correctly created" + " </font>");
            else {
                String errorStringSPC = (String) request.getSession().getAttribute(ServicePackageCreationServlet.getErrorString());
                if (errorStringSPC != null) {
                    out.println("<font color = red>" + errorStringSPC + " </font>");
                    request.getSession().removeAttribute(ServicePackageCreationServlet.getErrorString());
                }
            }
        %>
    </p>
    <br/>
    <input type="submit" value="Confirm" />
</form>

<br/>
<hr/>
<hr/>
<br/>

<!-- OPTIONAL PRODUCT CREATION -->
<form action="optional-product-creation" method="post">
    <h2>OPTIONAL PRODUCT CREATION</h2>
    <div class="list">
        <table style="width: 50%">
            <tr>
                <td>Name</td>
                <td><input type="text" name="name" required/></td>
            </tr>
            <tr>
                <td>Monthly fee</td>
                <td><input type="number" step="0.01" name="monthlyFee" required/></td>
            </tr>
        </table>
    </div>
    <p>
        <%
            String errorStringOP = (String)request.getSession().getAttribute(OptionalProductCreationServlet.getErrorString());
            if(errorStringOP!=null) {
                out.println("<font color = red>" + errorStringOP + " </font>");
                request.getSession().removeAttribute(OptionalProductCreationServlet.getErrorString());
            }
        %>
    </p>
    <br/>
    <input type="submit" value="Confirm" />
</form>

<br/>
</body>
</html>