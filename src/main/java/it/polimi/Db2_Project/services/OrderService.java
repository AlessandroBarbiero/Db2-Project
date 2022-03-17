package it.polimi.Db2_Project.services;
import it.polimi.Db2_Project.entities.OrderEntity;
import it.polimi.Db2_Project.entities.ScheduleActivationEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;
import org.apache.commons.lang3.time.DateUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Stateless
public class OrderService {

    @PersistenceContext
    private EntityManager em;

    public Optional <OrderEntity> findOrderById(int orderId){
        return em.createNamedQuery("Order.findById", OrderEntity.class)
                .setParameter("orderId", orderId)
                .getResultStream().findFirst();
    }

    public List<OrderEntity> findRejectedOrders(int userId) {
        return em.createNamedQuery("Order.findRejected", OrderEntity.class).setParameter("userId", userId).getResultList();
    }

    public List<OrderEntity> findSuspendedOrders(){
        String sql = "SELECT id " +
                "FROM suspended_orders ";

        List<Integer> orders = em.createNativeQuery(sql, Integer.class).getResultList();

        if(orders.isEmpty())
            return new ArrayList<>();
        else
            return em.createNamedQuery("Order.findAmong", OrderEntity.class).setParameter("id", orders).getResultList();
    }

    public Optional<OrderEntity> createOrder(OrderEntity order){
        try {
            ScheduleActivationEntity schedule = new ScheduleActivationEntity();
            Optional<OrderEntity> result;
            result = Optional.of(em.merge(order));
            if (order.getValid())
            {
                schedule.setOrder(result.get());
                schedule.setStart(order.getStartDate());
                Date endDate = DateUtils.addMonths(order.getStartDate(), order.getValidityPeriod().getNumberOfMonths());
                schedule.setEnd(endDate);
                em.merge(schedule);
            }

            em.flush();
            return result;
        } catch (ConstraintViolationException e) {
            return Optional.empty();
        }
    }
}
