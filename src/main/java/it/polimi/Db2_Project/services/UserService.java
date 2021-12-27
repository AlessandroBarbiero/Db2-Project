package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.*;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;

import java.util.List;
import java.util.Optional;

@Stateless
public class UserService {

    @PersistenceContext
    private EntityManager em;

    public Optional<UserEntity> findUserById(int userId) {
        UserEntity user = em.find(UserEntity.class, userId);

        return Optional.ofNullable(user);
    }

    public Optional<ValidityPeriodEntity> findValidityPeriodById(int id){
        return em.createNamedQuery("ValidityPeriod.findById", ValidityPeriodEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

    public Optional<ServicePackageEntity> findServicePackageById(int id){
        return em.createNamedQuery("ServicePackage.findById", ServicePackageEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

    public Optional<OptionalProductEntity> findOptionalProductById(int id){
        return em.createNamedQuery("OptionalProduct.findById", OptionalProductEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

    public Optional<UserEntity> createUser(String username, String password, String email) {
        UserEntity user = new UserEntity(username, email, password);

        try {
            em.persist(user);
            em.flush();
            return Optional.of(user);
        } catch (ConstraintViolationException e) {
            return Optional.empty();
        }
    }

    public Optional<UserEntity> findUserByUsername(String username) {
        return em.createNamedQuery("User.findByUsername", UserEntity.class)
                .setParameter("username", username)
                .getResultStream().findFirst();
    }

    public Optional<UserEntity> findUserByEmail(String email) {
        return em.createNamedQuery("User.findByEmail", UserEntity.class)
                .setParameter("email", email)
                .getResultStream().findFirst();
    }

    // if username and password are correct it returns the user, else it returns an empty object
    public Optional<UserEntity> checkCredentials(String username, String password) {
        Optional<UserEntity> user = findUserByUsername(username);

        // if username is not specified or the password is incorrect
        if(!user.isPresent() || !password.equals(user.get().getPassword())){
            return Optional.empty();
        }

        return user;
    }

    public List<ServicePackageEntity> findAllServicePackage(){
        return em.createNamedQuery("ServicePackage.findAll", ServicePackageEntity.class).getResultList();
    }

    public List<ValidityPeriodEntity> findValidityPeriodsOfPackage(Integer chosen){
        return em.createNamedQuery("ValidityPeriod.findByPackage", ValidityPeriodEntity.class).setParameter("packId", chosen).getResultList();
    }

    public List<OptionalProductEntity> findOptionalProductsOfPackage(Integer chosen) {
        return em.createNamedQuery("OptionalProduct.findByPackage", OptionalProductEntity.class).setParameter("packId", chosen).getResultList();
    }

    public Optional<OrderEntity> createOrder(OrderEntity order){
        try {
            em.merge(order);
            em.flush();
            return Optional.of(order);
        } catch (ConstraintViolationException e) {
            return Optional.empty();
        }
    }

    public List<OrderEntity> findRejectedOrders(int userId) {
        return em.createNamedQuery("Order.findRejected", OrderEntity.class).setParameter("userId", userId).getResultList();
    }

    public Optional <OrderEntity> findOrderById(int orderId){
        return em.createNamedQuery("Order.findById", OrderEntity.class)
                .setParameter("orderId", orderId)
                .getResultStream().findFirst();
    }
}