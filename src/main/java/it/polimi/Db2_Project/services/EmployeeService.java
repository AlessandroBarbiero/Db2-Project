package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.EmployeeEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.Optional;

@Stateless
public class EmployeeService {

    @PersistenceContext
    private EntityManager em;

    private Optional<EmployeeEntity> findEmployeeByUsername(String username) {
        return em.createNamedQuery("Employee.findByUsername", EmployeeEntity.class)
                .setParameter("username", username)
                .getResultStream().findFirst();
    }

    // if username and password are correct it returns the user, else it returns an empty object
    public Optional<EmployeeEntity> checkCredentials(String username, String password) {
        Optional<EmployeeEntity> employee = findEmployeeByUsername(username);

        // if username is not specified or the password is incorrect
        if(!employee.isPresent() || !password.equals(employee.get().getPassword())){
            return Optional.empty();
        }

        return employee;
    }
}
