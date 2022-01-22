package it.polimi.Db2_Project.web.user;

import it.polimi.Db2_Project.entities.*;
import it.polimi.Db2_Project.services.OrderService;
import it.polimi.Db2_Project.services.ScheduleActivationService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.lang3.time.DateUtils;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Date;
import java.util.Optional;

@WebServlet(name = "orderConfirmationServlet", value = "/confirmation")
public class OrderConfirmationServlet extends HttpServlet {
    @EJB
    private OrderService orderService;
    @EJB
    private ScheduleActivationService scheduleActivationService;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if(session.getAttribute("pendingOrder") == null) {
            response.sendRedirect("home-user");
            return;
        }

        OrderEntity order = (OrderEntity) session.getAttribute("pendingOrder");
        ValidityPeriodEntity validityPeriod = order.getValidityPeriod();
        float totalCost;
        totalCost = validityPeriod.getMonthlyFee() * validityPeriod.getNumberOfMonths();
        for(OptionalProductEntity op : order.getOptionalProducts())
            totalCost+=op.getMonthlyFee() * validityPeriod.getNumberOfMonths();

        request.setAttribute("totalCost", totalCost);

        request.getRequestDispatcher("/UserPages/confirmation-page.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        OrderEntity order = (OrderEntity) session.getAttribute("pendingOrder");
        ScheduleActivationEntity schedule = new ScheduleActivationEntity();

        order.setValid(isValidPayment(req));
        order.setCreation(Timestamp.from(Instant.now()));
        UserEntity user = (UserEntity) session.getAttribute("user");
        order.setUser(user);

        float totalCost = Float.parseFloat(req.getParameter("totalCost"));

        order.setTotalPrice(totalCost);

        Optional<OrderEntity> attachedOrder;
        attachedOrder = orderService.createOrder(order);
        if (order.getValid() && attachedOrder.isPresent())
        {
            schedule.setOrder(attachedOrder.get());
            schedule.setStart(order.getStartDate());
            Date endDate = DateUtils.addMonths(order.getStartDate(), order.getValidityPeriod().getNumberOfMonths());
            schedule.setEnd(endDate);
            scheduleActivationService.createScheduleActivation(schedule);
        }
        session.removeAttribute("pendingOrder");

        resp.sendRedirect("home-user");

    }

    private boolean isValidPayment(HttpServletRequest request){
        return "true".equals(request.getParameter("buy"));
    }
}
