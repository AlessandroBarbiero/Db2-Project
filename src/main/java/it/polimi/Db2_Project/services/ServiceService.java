package it.polimi.Db2_Project.services;
import it.polimi.Db2_Project.entities.ServiceEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;

@Stateless
public class ServiceService {
    @PersistenceContext
    private EntityManager em;

    public List<ServiceEntity> findAllServices(){
        return em.createNamedQuery("Service.findAll", ServiceEntity.class).getResultList();
    }

    public Optional<ServiceEntity> findServiceById(int id){
        return em.createNamedQuery("Service.findById", ServiceEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

}
