package it.polimi.Db2_Project.services;
import it.polimi.Db2_Project.entities.ScheduleActivationEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;
import java.util.List;
import java.util.Optional;

@Stateless
public class ScheduleActivationService {

    @PersistenceContext
    private EntityManager em;

    public List<ScheduleActivationEntity> findValidOrders(int userId){
        return em.createNamedQuery("Schedule.findValid", ScheduleActivationEntity.class).setParameter("userId", userId).getResultList();
    }
}
