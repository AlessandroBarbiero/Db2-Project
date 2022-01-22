package it.polimi.Db2_Project.services;

import it.polimi.Db2_Project.entities.BlacklistEntity;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

@Stateless
public class BlackListService {

    @PersistenceContext
    private EntityManager em;

    public List<BlacklistEntity> findAllAlerts(){

        return em.createNamedQuery("Blacklist.findAll", BlacklistEntity.class).getResultList();
    }
}
