package it.polimi.Db2_Project.web.employee;

import it.polimi.Db2_Project.entities.OptionalProductEntity;
import it.polimi.Db2_Project.entities.ServiceEntity;
import it.polimi.Db2_Project.entities.ValidityPeriodEntity;
import it.polimi.Db2_Project.services.OptionalProductService;
import it.polimi.Db2_Project.services.ServiceService;
import it.polimi.Db2_Project.services.ValidityPeriodService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "employeeHomePageServlet", value = "/home-employee")
public class EmployeeHomePageServlet extends HttpServlet {

    @EJB
    private ServiceService serviceService;
    @EJB
    private ValidityPeriodService validityPeriodService;
    @EJB
    private OptionalProductService optionalProductService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ServiceEntity> services = serviceService.findAllServices();
        request.setAttribute("services", services);


        List<ValidityPeriodEntity> validityPeriods = validityPeriodService.findAllValidityPeriods();
        request.setAttribute("validityPeriods", validityPeriods);

        List<OptionalProductEntity> optionalProducts = optionalProductService.findAllOptionalProducts();
        request.setAttribute("optionalProducts", optionalProducts);

        request.getRequestDispatcher("/EmployeePages/home-page.jsp").forward(request, response);
    }
}
