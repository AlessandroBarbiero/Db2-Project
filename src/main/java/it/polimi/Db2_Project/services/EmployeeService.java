package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.*;
import it.polimi.Db2_Project.utility.PurchasesBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.*;
import jakarta.validation.ConstraintViolationException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Stateless
public class EmployeeService {

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

    public List<ValidityPeriodEntity> findAllValidityPeriods(){
        return em.createNamedQuery("ValidityPeriod.findAll", ValidityPeriodEntity.class).getResultList();
    }

    public Optional<ValidityPeriodEntity> findValidityPeriodById(int id){
        return em.createNamedQuery("ValidityPeriod.findById", ValidityPeriodEntity.class)
                .setParameter("id", id)
                .getResultStream().findFirst();
    }

    public List<ValidityPeriodEntity> findValidityPeriodsOfPackage(Integer chosen){
        return em.createNamedQuery("ValidityPeriod.findByPackage", ValidityPeriodEntity.class).setParameter("packId", chosen).getResultList();
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

    public List<ServicePackageEntity> findAllServicePackage(){
        return em.createNamedQuery("ServicePackage.findAll", ServicePackageEntity.class).getResultList();
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

    // if username and password are correct it returns the user, else it returns an empty object
    public Optional<EmployeeEntity> checkCredentials(String username, String password) {
        Optional<EmployeeEntity> employee = findEmployeeByUsername(username);

        // if username is not specified or the password is incorrect
        if(!employee.isPresent() || !password.equals(employee.get().getPassword())){
            return Optional.empty();
        }

        return employee;

    }

    private Optional<EmployeeEntity> findEmployeeByUsername(String username) {
        return em.createNamedQuery("Employee.findByUsername", EmployeeEntity.class)
                .setParameter("username", username)
                .getResultStream().findFirst();
    }

    public List<OptionalProductEntity> findOptionalProductsOfPackage(Integer chosen) {
        return em.createNamedQuery("OptionalProduct.findByPackage", OptionalProductEntity.class).setParameter("packId", chosen).getResultList();
    }

//%%%%%%%%%%%%%%%%%%% SALES REPORT %%%%%%%%%%%%%%

    @SuppressWarnings("unchecked")
    public Map<String, Integer> totalPurchasesPerPackage(){
        Map<String, Integer> resultMap = new HashMap<>();

        String sql = "SELECT s.name, p.totalPurchases " +
                "FROM purchases_per_package p, service_package s " +
                "WHERE p.servicePackageId = s.id";

        List<Object[]> result = em.createNativeQuery(sql, Object[].class).getResultList();

        for(Object[] tuple : result ){
            resultMap.put((String) tuple[0], (Integer) tuple[1]);
        }

        return resultMap;
    }

    @SuppressWarnings("unchecked")
    public List<PurchasesBean> totalPurchasesPerPackageAndVP(){
        String sql = "SELECT s.name as servicePackageName, vp.numberOfMonths as numberOfMonths, vp.monthlyFee as monthlyFee, p.totalPurchases as totalPurchases " +
                "FROM purchases_per_package_and_vp p, service_package s , validity_period vp " +
                "WHERE p.servicePackageId = s.id AND p.validityPeriodId = vp.id ";

        return  em.createNativeQuery(sql, PurchasesBean.class).getResultList();

    }

}
