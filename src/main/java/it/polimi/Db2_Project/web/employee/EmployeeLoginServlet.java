package it.polimi.Db2_Project.web.employee;

import it.polimi.Db2_Project.entities.EmployeeEntity;
import it.polimi.Db2_Project.entities.UserEntity;
import it.polimi.Db2_Project.services.EmployeeService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "employeeLoginServlet", value = "/login-employee")
public class EmployeeLoginServlet extends HttpServlet {

    @EJB
    private EmployeeService employeeService;

    private static final String EMPTY_FIELD_ERROR = "Please fill all the fields";
    private static final String ERROR_STRING = "errorString";
    private static final String INVALID_CREDENTIALS = "Username and password are invalid";
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/EmployeePages/login-page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if(username.isEmpty() || password.isEmpty())
        {
            session.setAttribute(ERROR_STRING, EMPTY_FIELD_ERROR);
        }
        else
        {
            Optional<EmployeeEntity> employee = employeeService.checkCredentials(username, password);
            if(!employee.isPresent())
                session.setAttribute(ERROR_STRING, INVALID_CREDENTIALS);

            else {
                // for saving the entire employee in the session when we change page
                session.setAttribute("employee", employee.get());
            }
        }
        response.sendRedirect("home-employee");
    }

}
