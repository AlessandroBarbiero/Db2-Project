package it.polimi.Db2_Project.web.user;

import it.polimi.Db2_Project.entities.OrderEntity;
import it.polimi.Db2_Project.entities.ServiceEntity;
import it.polimi.Db2_Project.entities.ServicePackageEntity;
import it.polimi.Db2_Project.services.EmployeeService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "userHomePageServlet", value = "/home-user")
public class UserHomePageServlet extends HttpServlet {

    @EJB
    private EmployeeService employeeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ServicePackageEntity> packages = employeeService.findAllServicePackage();
        request.setAttribute("packages", packages);



        request.getRequestDispatcher("/UserPages/home-page.jsp").forward(request, response);
    }

}