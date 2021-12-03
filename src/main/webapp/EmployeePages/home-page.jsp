<%@ page import="java.util.List" %>
<%@ page import="it.polimi.Db2_Project.entities.ServiceEntity" %>
<%@ page import="it.polimi.Db2_Project.web.employee.OptionalProductCreationServlet" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Telco-Management</title>
</head>
<body>

<h1> <%= "Home Page" %> </h1>


<!-- SERVICE PACKAGE CREATION -->
<form action="service-package-creation" method="post">
    <h2>SERVICE PACKAGE CREATION</h2>
    <table style="width: 70%">
        <tr>
            <td>Insert name
            <input type="text" name="servicePackageName" required/>
            </td>
        </tr>
        <tr><td>---</td></tr>
        <tr>
            <td>Select the SERVICES to include into this Service Package</td>
        </tr>
        <jsp:useBean id="services" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ServiceEntity>"/>
        <c:forEach var="service" items="${services}" varStatus="row">
            <tr>
                <td>
                    <input type="checkbox" id="${service.id}" name="${service.id}">
                    <label for="${service.id}">${service.toString()}</label>
                </td>
            </tr>
        </c:forEach>
        <tr><td>---</td></tr>

        <tr>
            <td>Select the VALIDITY PERIODS from which to select for this Service Package</td>
        </tr>
        <jsp:useBean id="validityPeriods" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ValidityPeriodEntity>"/>
        <c:forEach var="validityPeriod" items="${validityPeriods}" varStatus="row">
            <tr>
                <td>
                    <input type="checkbox" id="${validityPeriod.id}" name="${validityPeriod.id}">
                    <label for="${validityPeriod.id}">${validityPeriod.toString()}</label>
                </td>
            </tr>
        </c:forEach>
        <tr><td>---</td></tr>

        <tr>
            <td>Select the OPTIONAL PRODUCTS from which to select for this Service Package</td>
        </tr>
        <jsp:useBean id="optionalProducts" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.OptionalProductEntity>"/>
        <c:forEach var="optionalProduct" items="${optionalProducts}" varStatus="row">
            <tr>
                <td>
                    <input type="checkbox" id="${optionalProduct.name}" name="${optionalProduct.name}">
                    <label for="${optionalProduct.name}">${optionalProduct.toString()}</label>
                </td>
            </tr>
        </c:forEach>
        <tr><td>---</td></tr>
    </table>
    <br/>
    <input type="submit" value="Confirm" />
</form>

<br/>
<hr/>
<br/>
<!-- OPTIONAL PRODUCT CREATION -->
<form action="optional-product-creation" method="post">
    <h2>OPTIONAL PRODUCT CREATION</h2>
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
    <p>
        <%
            String errorString = (String)request.getSession().getAttribute(OptionalProductCreationServlet.getErrorString());
            if(errorString!=null)
                out.println("<font color = red>" + errorString + " </font>");
        %>
    </p>
    <br/>
    <input type="submit" value="Confirm" />
</form>
<br/>
</body>
</html>