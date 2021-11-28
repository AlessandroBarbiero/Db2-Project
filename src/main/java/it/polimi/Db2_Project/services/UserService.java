package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.UserEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolationException;

import java.util.Optional;

@Stateless
public class UserService {

    @PersistenceContext
    private EntityManager em;

    public Optional<UserEntity> findUserById(int userId) {
        UserEntity user = em.find(UserEntity.class, userId);

        return Optional.ofNullable(user);
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
}