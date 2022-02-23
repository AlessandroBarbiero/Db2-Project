package it.polimi.Db2_Project.web.user;
import it.polimi.Db2_Project.entities.OrderEntity;
import it.polimi.Db2_Project.entities.ScheduleActivationEntity;
import it.polimi.Db2_Project.entities.ServicePackageEntity;
import it.polimi.Db2_Project.entities.UserEntity;
import it.polimi.Db2_Project.services.OrderService;
import it.polimi.Db2_Project.services.ScheduleActivationService;
import it.polimi.Db2_Project.services.ServicePackageService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "userHomePageServlet", value = "/home-user")
public class UserHomePageServlet extends HttpServlet {

    @EJB
    private OrderService orderService;
    @EJB
    private ServicePackageService servicePackageService;
    @EJB
    private ScheduleActivationService scheduleActivationService;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ServicePackageEntity> packages = servicePackageService.findAllServicePackage();
        request.setAttribute("packages", packages);

        HttpSession session = request.getSession();
        UserEntity user = (UserEntity) session.getAttribute("user");

        if (user != null){
            List<OrderEntity> rejectedOrders = orderService.findRejectedOrders(user.getId());
            request.setAttribute("rejectedOrders", rejectedOrders);

            List<ScheduleActivationEntity> validOrders = scheduleActivationService.findValidOrders(user.getId());
            request.setAttribute("validOrders", validOrders);
        }

        request.getRequestDispatcher("/UserPages/home-page.jsp").forward(request, response);
    }
}