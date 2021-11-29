package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "service_package", schema = "db2_database")
public class ServicePackageEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @ManyToMany
    @JoinTable (name="service_composition",
            joinColumns = @JoinColumn(name="servicePackageId"),
            inverseJoinColumns= @JoinColumn (name="serviceId"))
    private List<ServiceEntity> services;

    @ManyToMany
    @JoinTable (name="possible_extensions",
            joinColumns = @JoinColumn(name="servicePackageId"),
            inverseJoinColumns= @JoinColumn (name="optionalProductName"))
    private List<OptionalProductEntity> possibleOptionalProducts;
}
