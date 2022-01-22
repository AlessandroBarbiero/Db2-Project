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

        /*.list{*/
        /*    padding-left: 30%;*/
        /*    text-align: left;*/
        /*}*/

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

        button {
            background-color: #04AA6D;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border: none;
            cursor: pointer;
            width: 30%;
        }

        button:hover {
            opacity: 0.8;
        }

        .pair{
            display: table-row;
            margin: auto;
        }

        .container {
            display: inline;
        }

        input[type=text],[type=number] {
            width: 80%;
            padding: 12px 20px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        form {
            border: 3px solid #f1f1f1;
            text-align: center;
            display: table;
        }

        #form1 {
            margin-left: 10%;
            width: 90%;
        }

        #form2 {
            margin-right: 10%;
            width: 80%;
        }

        .column1 {
            float: left;
            width: 55%;
            padding: 10px;
            background-color: white;
        }

        .column2 {
            float: left;
            width: 40%;
            padding: 10px;
            background-color: white;
        }

        .list{
            text-align: left;
            margin-left: 10%;
        }
    </style>
</head>
<body>

<h1>Home Page</h1>


<div class="bar">
    <div class="barText">

    </div>
</div>

<div class="row">
    <div class="column1">
        <!-- SERVICE PACKAGE CREATION -->
        <form action="service-package-creation" method="post" id="form1">
            <div class="container">
                <h2 style="font-family:Audiowide, sans-serif;">Service Package Creation</h2>
                <p class="pair">
                    <label><b>Insert name</b></label>
                    <input type="text" name="servicePackageName" required/>
                </p>

                <br>

                <!-- SERVICES -->
                <h3 style="text-align: left; margin: 5%">Select the services</h3>

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
                        <c:if test="${service.type == 'FIXED_PHONE'}">
                            <label for="s${service.id}"> Fixed Phone: no parameters specified </label>
                        </c:if>

                        <c:if test="${service.type == 'MOBILE_PHONE'}">
                            <label for="s${service.id}"> Mobile Phone: ${service.numberOfMinutes} Min, ${service.numberOfSms} Sms, ${String.format('%.2f', service.extraMinutesFee)} € extra Min, ${String.format('%.2f',service.extraSmsFee)} € extra Sms</label>
                        </c:if>

                        <c:if test="${service.type == 'FIXED_INTERNET'}">
                            <label for="s${service.id}"> Fixed Internet: ${service.numberOfGb} Gb, ${String.format('%.2f',service.extraGbFee)} € extra Gb </label>
                        </c:if>

                        <c:if test="${service.type == 'MOBILE_INTERNET'}">
                            <label for="s${service.id}"> Mobile Internet: ${service.numberOfGb} Gb, ${String.format('%.2f',service.extraGbFee)} € extra Gb </label>
                        </c:if>

                        <br/>
                    </c:forEach>
                </div>
                <br/>

                <h3 style="text-align: left; margin: 5%">Select the validity periods</h3>

                <jsp:useBean id="validityPeriods" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.ValidityPeriodEntity>"/>

                <div class="list">
                    <c:forEach var="validityPeriod" items="${validityPeriods}" varStatus="row">
                        <input type="checkbox" id="vp${validityPeriod.id}" name="selected_validity_periods" value="${validityPeriod.id}">
                        <label for="vp${validityPeriod.id}">${validityPeriod.monthlyFee} €/month per ${validityPeriod.numberOfMonths} months</label>
                        <br />
                    </c:forEach>
                </div>

                <br/>

                <h3 style="text-align: left; margin: 5%">Select the optional products</h3>

                <jsp:useBean id="optionalProducts" scope="request" type="java.util.List<it.polimi.Db2_Project.entities.OptionalProductEntity>"/>

                <div class="list">
                    <c:forEach var="optionalProduct" items="${optionalProducts}" varStatus="row">
                        <input type="checkbox" id="op${optionalProduct.name}" name="selected_optional_products" value="${optionalProduct.name}">
                        <label for="op${optionalProduct.name}">${optionalProduct.name} ${optionalProduct.monthlyFee} €</label>
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

            </div>
            <button type="submit" value="Confirm">Confirm</button>
        </form>

    </div>


    <div class="column2">
        <!-- OPTIONAL PRODUCT CREATION -->
        <form action="optional-product-creation" method="post" id="form2">
            <div class="container">
                <h2 style="font-family:Audiowide, sans-serif;">Optional Product Creation</h2>

                <p class="pair">
                    <label><b>Name </b></label>
                    <input type="text" name="name" required/>
                </p>

                <p class="pair">
                    <label><b>Monthly fee </b></label>
                    <input type="number" step="0.01" name="monthlyFee" required/>
                </p>

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
                <button type="submit" value="Confirm">Confirm</button>

            </div>

        </form>

        <a href="sales-report">
            <button class="button">Sales Report &#10146;</button>
        </a>
    </div>

</div>

</body>
</html>