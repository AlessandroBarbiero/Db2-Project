package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.*;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;

import java.util.List;
import java.util.Optional;

@Stateless
public class EmployeeService {

    @PersistenceContext
    private EntityManager em;

    public List<ServiceEntity> findAllServices(){
        return em.createNamedQuery("Service.findAll", ServiceEntity.class).getResultList();
    }

    public List<ValidityPeriodEntity> findAllValidityPeriods(){
        return em.createNamedQuery("ValidityPeriod.findAll", ValidityPeriodEntity.class).getResultList();
    }

    public List<OptionalProductEntity> findAllOptionalProducts(){
        return em.createNamedQuery("OptionalProduct.findAll", OptionalProductEntity.class).getResultList();
    }

    public Optional<OptionalProductEntity> findOptionalProductByName(String name){
        return em.createNamedQuery("OptionalProduct.findByName", OptionalProductEntity.class)
                .setParameter("name", name)
                .getResultStream().findFirst();
    }

    public Optional<ServicePackageEntity> findServicePackageByName(String name){
        return em.createNamedQuery("ServicePackage.findByName", ServicePackageEntity.class)
                .setParameter("name", name)
                .getResultStream().findFirst();
    }

    public Optional<OptionalProductEntity> createOptionalProduct(String name, float monthlyFee) {
        OptionalProductEntity optionalProduct = new OptionalProductEntity(name, monthlyFee);

        try {
            em.persist(optionalProduct);
            em.flush();
            return Optional.of(optionalProduct);
        } catch (ConstraintViolationException e) {
            return Optional.empty();
        }
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
