package it.polimi.Db2_Project.web.employee;

import it.polimi.Db2_Project.entities.OptionalProductEntity;
import it.polimi.Db2_Project.entities.ServiceEntity;
import it.polimi.Db2_Project.entities.ValidityPeriodEntity;
import it.polimi.Db2_Project.exceptions.ValidityPeriodOverloadException;
import it.polimi.Db2_Project.services.EmployeeService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "servicePackageCreationServlet", value = "/service-package-creation")
public class ServicePackageCreationServlet extends HttpServlet {
    @EJB
    private EmployeeService employeeService;

    private static final String ERROR_STRING = "errorStringSPC";
    private static final String INVALID_CHOICE = "Please select only one price given a time interval " +
            "(e.g. you can't select 3.00€ / 8 months and 5.00€ / 8 months)";
    private static final String NAME_ALREADY_USED = "The selected name for this Service Package is already in use," +
            " please select a different one";
    private static final String NO_SERVICES = "Please select at least one service";
    private static final String NO_VALIDITY_PERIODS = "Please select at least one validity period";

    public static String getErrorString(){
        return ERROR_STRING;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String name = request.getParameter("servicePackageName");
        if(employeeService.findServicePackageByName(name).isPresent()){
            session.setAttribute(ERROR_STRING, NAME_ALREADY_USED);
            response.sendRedirect("home-employee");
            return;
        }

        List<ServiceEntity> chosenServices = findSelectedServices(request);
        if(chosenServices.isEmpty()){
            session.setAttribute(ERROR_STRING, NO_SERVICES);
            response.sendRedirect("home-employee");
            return;
        }

        List<ValidityPeriodEntity> chosenValidityPeriods;
        try {
            chosenValidityPeriods = findSelectedValidityPeriods(request);
        } catch (ValidityPeriodOverloadException e) {
            session.setAttribute(ERROR_STRING, INVALID_CHOICE);
            response.sendRedirect("home-employee");
            return;
        }
        if(chosenValidityPeriods.isEmpty()){
            session.setAttribute(ERROR_STRING, NO_VALIDITY_PERIODS);
            response.sendRedirect("home-employee");
            return;
        }

        List<OptionalProductEntity> chosenOptionalProducts = findSelectedOptionalProducts(request);
        employeeService.createServicePackage(name, chosenServices, chosenValidityPeriods, chosenOptionalProducts);

        response.sendRedirect("home-employee");
    }

    private List<ServiceEntity> findSelectedServices(HttpServletRequest request){
        boolean selected;
        int serviceId;
        List<ServiceEntity> chosenServices = new ArrayList<>();
        List<ServiceEntity> services = employeeService.findAllServices();
        for(ServiceEntity service : services){
            serviceId = service.getId();
            selected = request.getParameter("s" + serviceId) != null;
            if(selected)
                chosenServices.add(service);
        }

        return chosenServices;
    }

    private List<ValidityPeriodEntity> findSelectedValidityPeriods(HttpServletRequest request) throws ValidityPeriodOverloadException {
        boolean selected;
        int validityPeriodId;
        List<ValidityPeriodEntity> chosenValidityPeriods = new ArrayList<>();
        List<ValidityPeriodEntity> validityPeriods = employeeService.findAllValidityPeriods();

        for(ValidityPeriodEntity validityPeriod : validityPeriods){
            validityPeriodId = validityPeriod.getId();
            selected = request.getParameter("vp" + validityPeriodId) != null;
            if(selected) {
                if(ValidityPeriodEntity.findSameNumberOfMonths(chosenValidityPeriods, validityPeriod))
                    throw new ValidityPeriodOverloadException();
                chosenValidityPeriods.add(validityPeriod);
            }
        }

        return chosenValidityPeriods;
    }

    private List<OptionalProductEntity> findSelectedOptionalProducts(HttpServletRequest request){
        boolean selected;
        String optionalProductName;
        List<OptionalProductEntity> chosenOptionalProducts = new ArrayList<>();
        List<OptionalProductEntity> optionalProducts = employeeService.findAllOptionalProducts();

        for(OptionalProductEntity optionalProduct : optionalProducts){
            optionalProductName = optionalProduct.getName();
            selected = request.getParameter("op" + optionalProductName) != null;
            if(selected)
                chosenOptionalProducts.add(optionalProduct);
        }

        return chosenOptionalProducts;
    }
}

