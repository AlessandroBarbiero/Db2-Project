package it.polimi.Db2_Project.web.user;

import it.polimi.Db2_Project.entities.*;
import it.polimi.Db2_Project.services.*;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "buyPageServlet", value = "/buy")
public class BuyPageServlet extends HttpServlet {

    @EJB
    private ServicePackageService servicePackageService;
    @EJB
    private ValidityPeriodService validityPeriodService;
    @EJB
    private OptionalProductService optionalProductService;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<ServicePackageEntity> packages = servicePackageService.findAllServicePackage();
        request.setAttribute("packages", packages);

        Integer chosen = Integer.parseInt(request.getParameter("chosen"));
        request.setAttribute("chosenPack", chosen);

        List<ValidityPeriodEntity> periods = validityPeriodService.findValidityPeriodsOfPackage(chosen);
        request.setAttribute("periods", periods);

        List<OptionalProductEntity> optionalProducts = optionalProductService.findOptionalProductsOfPackage(chosen);
        request.setAttribute("optionalProducts", optionalProducts);

        request.getRequestDispatcher("/UserPages/buy-page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        boolean error = false;
        HttpSession session = request.getSession();
        Integer pack = Integer.parseInt(request.getParameter("packages"));
        Integer validityPeriod = Integer.parseInt(request.getParameter("periods"));
        String[] optionalProductsStr = request.getParameterValues("optionalProducts");
        if(optionalProductsStr == null){
            optionalProductsStr = new String[]{};
        }
        List<Integer> optionalProducts = Arrays.stream(optionalProductsStr).map(Integer::parseInt).collect(Collectors.toList());
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Date startDate = null;
        try {
            startDate = sdf.parse(request.getParameter("startDate"));
        }
        catch (ParseException e) {
            error = true;
        }

        if(startDate == null || error) {
            response.sendRedirect("home-user");
            return;
        }

        OrderEntity order = new OrderEntity(false, startDate, Timestamp.from(Instant.now()));

        order.setValidityPeriod(validityPeriodService.findValidityPeriodById(validityPeriod).get());
        order.setServicePackage(servicePackageService.findServicePackageById(pack).get());

        // prendo la lista delle entity degli opt products e li collego all'ordine
        List <OptionalProductEntity> opList = new ArrayList<>();
        for (int op: optionalProducts){
            opList.add(optionalProductService.findOptionalProductById(op).get());
        }
        order.setOptionalProducts(opList);

        session.setAttribute("pendingOrder", order);

        response.sendRedirect("confirmation");
    }

    public static String getFullURL(HttpServletRequest request) {
        StringBuilder requestURL = new StringBuilder(request.getRequestURL().toString());
        String queryString = request.getQueryString();

        if (queryString == null) {
            return requestURL.toString();
        } else {
            return requestURL.append('?').append(queryString).toString();
        }
    }
}


