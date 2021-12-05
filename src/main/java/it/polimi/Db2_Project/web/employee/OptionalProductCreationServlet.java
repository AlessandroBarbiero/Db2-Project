package it.polimi.Db2_Project.web.employee;

import it.polimi.Db2_Project.services.EmployeeService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "optionalProductCreationServlet", value = "/optional-product-creation")
public class OptionalProductCreationServlet extends HttpServlet {

    @EJB
    private EmployeeService employeeService;

    private static final String EMPTY_FIELD_ERROR = "Please fill all the fields";
    private static final String ERROR_STRING = "errorStringOP";
    private static final String INVALID_NAME = "The name is already used by another optional product, please choose another one";

    public static String getErrorString() {
        return ERROR_STRING;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String name = request.getParameter("name");
        String monthlyFeeString = request.getParameter("monthlyFee");
        float monthlyFee;

        if(name.isEmpty() || monthlyFeeString.isEmpty()) {
            session.setAttribute(ERROR_STRING, EMPTY_FIELD_ERROR);
        }
        else {
            monthlyFee = new Float(monthlyFeeString);
            if(employeeService.findOptionalProductByName(name).isPresent())
                session.setAttribute(ERROR_STRING, INVALID_NAME);
            else
                employeeService.createOptionalProduct(name, monthlyFee);
        }
        response.sendRedirect("home-employee");
    }
}