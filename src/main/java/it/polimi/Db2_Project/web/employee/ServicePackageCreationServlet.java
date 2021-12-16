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
import java.util.Optional;

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
            response.sendRedirect("home-employee?success=false");
            return;
        }

        List<ServiceEntity> chosenServices = findSelectedServices(request);
        if(chosenServices.isEmpty()){
            session.setAttribute(ERROR_STRING, NO_SERVICES);
            response.sendRedirect("home-employee?success=false");
            return;
        }

        List<ValidityPeriodEntity> chosenValidityPeriods;
        try {
            chosenValidityPeriods = findSelectedValidityPeriods(request);
        } catch (ValidityPeriodOverloadException e) {
            session.setAttribute(ERROR_STRING, INVALID_CHOICE);
            response.sendRedirect("home-employee?success=false");
            return;
        }
        if(chosenValidityPeriods.isEmpty()){
            session.setAttribute(ERROR_STRING, NO_VALIDITY_PERIODS);
            response.sendRedirect("home-employee?success=false");
            return;
        }

        List<OptionalProductEntity> chosenOptionalProducts = findSelectedOptionalProducts(request);
        employeeService.createServicePackage(name, chosenServices, chosenValidityPeriods, chosenOptionalProducts);

        response.sendRedirect("home-employee?success=true");
    }

    private List<ServiceEntity> findSelectedServices(HttpServletRequest request){
        int serviceId;
        List<ServiceEntity> chosenServices = new ArrayList<>();
        String[] selectedServices = request.getParameterValues("selected_services");

        if(selectedServices==null)
            return chosenServices;

        Optional<ServiceEntity> found;
        for(String service : selectedServices){
            serviceId = Integer.parseInt(service);
            found = employeeService.findServiceById(serviceId);
            found.ifPresent(chosenServices::add);
        }

        return chosenServices;
    }

    private List<ValidityPeriodEntity> findSelectedValidityPeriods(HttpServletRequest request) throws ValidityPeriodOverloadException {
        int validityPeriodId;
        Optional<ValidityPeriodEntity> found;
        ValidityPeriodEntity validityPeriod;
        List<ValidityPeriodEntity> chosenValidityPeriods = new ArrayList<>();
        String[] selectedValidityPeriods = request.getParameterValues("selected_validity_periods");

        if(selectedValidityPeriods==null)
            return chosenValidityPeriods;

        for(String validityPeriodString : selectedValidityPeriods){
            validityPeriodId = Integer.parseInt(validityPeriodString);
            found = employeeService.findValidityPeriodById(validityPeriodId);
            if(found.isPresent()) {
                validityPeriod = found.get();
                if(ValidityPeriodEntity.findSameNumberOfMonths(chosenValidityPeriods, validityPeriod))
                    throw new ValidityPeriodOverloadException();
                chosenValidityPeriods.add(validityPeriod);
            }
        }

        return chosenValidityPeriods;
    }

    private List<OptionalProductEntity> findSelectedOptionalProducts(HttpServletRequest request){
        Optional<OptionalProductEntity> found;
        List<OptionalProductEntity> chosenOptionalProducts = new ArrayList<>();
        String[] selectedOptionalProducts = request.getParameterValues("selected_optional_products");

        if(selectedOptionalProducts==null)
            return chosenOptionalProducts;

        for(String optionalProductName : selectedOptionalProducts){
            found = employeeService.findOptionalProductByName(optionalProductName);
            found.ifPresent(chosenOptionalProducts::add);
        }

        return chosenOptionalProducts;
    }
}

