package it.polimi.Db2_Project.web.user;
import it.polimi.Db2_Project.entities.OrderEntity;
import it.polimi.Db2_Project.services.OrderService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "retrieveOrderServlet", value = "/retrieve-order")
public class RetrieveOrderServlet extends HttpServlet {

    @EJB
    private OrderService orderService;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        if (request.getParameter("orderId") == null){
            response.sendRedirect("home-user");
            return;
        }
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Optional <OrderEntity> order = orderService.findOrderById(orderId);
        if (order.isPresent() && !order.get().getValid()){
            session.setAttribute("pendingOrder",order.get());

            response.sendRedirect("confirmation");
        } else {
            response.sendRedirect("home-user");
        }
    }
}
