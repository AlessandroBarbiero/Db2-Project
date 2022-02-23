package it.polimi.Db2_Project.services;
import it.polimi.Db2_Project.entities.OptionalProductEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;
import java.util.List;
import java.util.Optional;

@Stateless
public class OptionalProductService {
    @PersistenceContext
    private EntityManager em;

    public Optional<OptionalProductEntity> findOptionalProductById(int id){
        return em.createNamedQuery("OptionalProduct.findById", OptionalProductEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

    public Optional<OptionalProductEntity> findOptionalProductByName(String name){
        return em.createNamedQuery("OptionalProduct.findByName", OptionalProductEntity.class)
                .setParameter("name", name)
                .getResultStream().findFirst();
    }

    public List<OptionalProductEntity> findAllOptionalProducts(){
        return em.createNamedQuery("OptionalProduct.findAll", OptionalProductEntity.class).getResultList();
    }

    public List<OptionalProductEntity> findOptionalProductsOfPackage(Integer chosen) {
        return em.createNamedQuery("OptionalProduct.findByPackage", OptionalProductEntity.class).setParameter("packId", chosen).getResultList();
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
}
