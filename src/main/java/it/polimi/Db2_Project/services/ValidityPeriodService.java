package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.ValidityPeriodEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;
import java.util.Optional;

@Stateless
public class ValidityPeriodService {
    @PersistenceContext
    private EntityManager em;

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

}
