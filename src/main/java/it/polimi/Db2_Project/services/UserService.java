package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.UserEntity;
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

    // if username and password are correct it returns the user, else it returns an empty object
    public Optional<UserEntity> checkCredentials(String username, String password) {
        Optional<UserEntity> user = findUserByUsername(username);

        // if username is not specified or the password is incorrect
        if (!user.isPresent() || !password.equals(user.get().getPassword())) {
            return Optional.empty();
        }

        return user;
    }

    public List<UserEntity> findInsolventUsers(){
        String sql = "SELECT * " +
                "FROM insolvent_users ";

        return em.createNativeQuery(sql, UserEntity.class).getResultList();
    }
}