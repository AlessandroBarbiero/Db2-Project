package it.polimi.Db2_Project.services;
import it.polimi.Db2_Project.entities.OptionalProductEntity;
import it.polimi.Db2_Project.entities.ServiceEntity;
import it.polimi.Db2_Project.entities.ServicePackageEntity;
import it.polimi.Db2_Project.entities.ValidityPeriodEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;
import java.util.List;
import java.util.Optional;

@Stateless
public class ServicePackageService {
    @PersistenceContext
    private EntityManager em;

    public Optional<ServicePackageEntity> findServicePackageById(int id){
        return em.createNamedQuery("ServicePackage.findById", ServicePackageEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

    public Optional<ServicePackageEntity> findServicePackageByName(String name){
        return em.createNamedQuery("ServicePackage.findByName", ServicePackageEntity.class)
                .setParameter("name", name)
                .getResultStream().findFirst();
    }

    public List<ServicePackageEntity> findAllServicePackage(){
        return em.createNamedQuery("ServicePackage.findAll", ServicePackageEntity.class).getResultList();
    }

    public  Optional<ServicePackageEntity> createServicePackage(String name, List<ServiceEntity> services,
                                                                List<ValidityPeriodEntity> possibleValidityPeriods,
                                                                List<OptionalProductEntity> possibleOptionalProducts) {

        ServicePackageEntity servicePackage = new ServicePackageEntity(name, services, possibleValidityPeriods, possibleOptionalProducts);
        try {
            //If your entity is new, it's the same as a persist(). But if your entity already exists, it will update it.
            //So it persists the new SP and updates the other entities
            em.merge(servicePackage);
            em.flush();
            return Optional.of(servicePackage);
        } catch (ConstraintViolationException e) {
            return Optional.empty();
        }
    }
}
