package it.polimi.Db2_Project.web.user;

import it.polimi.Db2_Project.entities.*;
import it.polimi.Db2_Project.services.EmployeeService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "buyPageServlet", value = "/buy")
public class BuyPageServlet extends HttpServlet {

    @EJB
    private EmployeeService employeeService;
    private HttpSession session;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ServicePackageEntity> packages = employeeService.findAllServicePackage();
        request.setAttribute("packages", packages);


        Integer chosen = Integer.parseInt(request.getParameter("chosen"));
        request.setAttribute("chosenPack", chosen);

        List<ValidityPeriodEntity> periods = employeeService.findValidityPeriodsOfPackage(chosen);
        request.setAttribute("periods", periods);

        List<OptionalProductEntity> optionalProducts = employeeService.findOptionalProductsOfPackage(chosen);
        request.setAttribute("optionalProducts", optionalProducts);

        request.getRequestDispatcher("/UserPages/buy-page.jsp").forward(request, response);
    }

}
