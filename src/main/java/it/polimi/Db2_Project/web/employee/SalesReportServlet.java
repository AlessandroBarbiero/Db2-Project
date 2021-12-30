package it.polimi.Db2_Project.web.employee;

import it.polimi.Db2_Project.entities.BlacklistEntity;
import it.polimi.Db2_Project.entities.OrderEntity;
import it.polimi.Db2_Project.entities.UserEntity;
import it.polimi.Db2_Project.services.EmployeeService;
import it.polimi.Db2_Project.dto.PurchasesBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SalesReportServlet", value = "/sales-report")
public class SalesReportServlet extends HttpServlet {

    @EJB
    private EmployeeService employeeService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<PurchasesBean> purchasesPerPackage = employeeService.totalPurchasesPerPackage();
        request.setAttribute("purchasesPerPackage", purchasesPerPackage);

        List<PurchasesBean> purchasesPerPackageAndVP = employeeService.totalPurchasesPerPackageAndVP();
        request.setAttribute("purchasesPerPackageAndVP", purchasesPerPackageAndVP);

        List<UserEntity> insolventUsers = employeeService.findInsolventUsers();
        request.setAttribute("insolventUsers", insolventUsers);

        List<OrderEntity> suspendedOrders = employeeService.findSuspendedOrders();
        request.setAttribute("suspendedOrders", suspendedOrders);

        List<BlacklistEntity> alerts = employeeService.findAllAlerts();
        request.setAttribute("alerts", alerts);

        request.getRequestDispatcher("/EmployeePages/sales-report-page.jsp").forward(request, response);
    }

}
