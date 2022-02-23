package it.polimi.Db2_Project.web.employee;

import it.polimi.Db2_Project.dto.AverageBean;
import it.polimi.Db2_Project.dto.BestSellerOptProdBean;
import it.polimi.Db2_Project.dto.PurchasesBean;
import it.polimi.Db2_Project.dto.SalesBean;
import it.polimi.Db2_Project.entities.BlacklistEntity;
import it.polimi.Db2_Project.entities.OrderEntity;
import it.polimi.Db2_Project.entities.UserEntity;
import it.polimi.Db2_Project.services.*;
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
    @EJB
    private UserService userService;
    @EJB
    private OrderService orderService;
    @EJB
    private BlackListService blackListService;
    @EJB
    private ViewService viewService;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<PurchasesBean> purchasesPerPackage = viewService.totalPurchasesPerPackage();
        request.setAttribute("purchasesPerPackage", purchasesPerPackage);

        List<PurchasesBean> purchasesPerPackageAndVP = viewService.totalPurchasesPerPackageAndVP();
        request.setAttribute("purchasesPerPackageAndVP", purchasesPerPackageAndVP);

        List<UserEntity> insolventUsers = userService.findInsolventUsers();
        request.setAttribute("insolventUsers", insolventUsers);

        List<OrderEntity> suspendedOrders = orderService.findSuspendedOrders();
        request.setAttribute("suspendedOrders", suspendedOrders);

        List<BlacklistEntity> alerts = blackListService.findAllAlerts();
        request.setAttribute("alerts", alerts);

        List<AverageBean> avgPerPackage = viewService.avgOptProdPerPackage();
        request.setAttribute("avgPerPackage", avgPerPackage);

        List<BestSellerOptProdBean> bestSeller = viewService.bestSellerOptProduct();
        request.setAttribute("bestSeller", bestSeller);

        List<SalesBean> salesPerPackage = viewService.salesPerPackage();
        request.setAttribute("salesPerPackage", salesPerPackage);

        request.getRequestDispatcher("/EmployeePages/sales-report-page.jsp").forward(request, response);
    }
}
