package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "service_package", schema = "db2_database")
public class ServicePackageEntity implements Serializable {

    private static final long serialVersionUID = 1L;

//%%%%%%%%%%% ATTRIBUTES %%%%%%%%%%%%%%

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @Column(name = "name", nullable=false)
    private String name;

//%%%%%%%%%%% RELATIONS %%%%%%%%%%%%%%

    @ManyToMany
    @JoinTable (name="service_composition",
            joinColumns = @JoinColumn(name="servicePackageId"),
            inverseJoinColumns= @JoinColumn (name="serviceId"))
    private List<ServiceEntity> services;

    @ManyToMany
    @JoinTable (name="possible_validity_period",
            joinColumns = @JoinColumn(name="servicePackageId"),
            inverseJoinColumns= @JoinColumn (name="validityPeriodId"))
    private List<ValidityPeriodEntity> possibleValidityPeriods;

    @ManyToMany
    @JoinTable (name="possible_extensions",
            joinColumns = @JoinColumn(name="servicePackageId"),
            inverseJoinColumns= @JoinColumn (name="optionalProductName"))
    private List<OptionalProductEntity> possibleOptionalProducts;

    @OneToMany(fetch = FetchType.LAZY, mappedBy="servicePackage", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderEntity> orders;


//%%%%%%%%%%% CONSTRUCTORS %%%%%%%%%%%%%%

    public ServicePackageEntity() {
    }

    public ServicePackageEntity(String name) {
        this.name = name;
    }

//%%%%%%%%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%%%%%%%%%%%

    public int getId() {
    return id;
}

    public String getName() {
        return name;
    }

    public List<ServiceEntity> getServices()
    {
        return services;
    }

    public List<ValidityPeriodEntity> getPossibleValidityPeriods()
    {
        return possibleValidityPeriods;
    }

    public List<OptionalProductEntity> getPossibleOptionalProducts()
    {
        return possibleOptionalProducts;
    }

    public List<OrderEntity> getOrders()
    {
        return orders;
    }

//%%%%%%%%%%%%%%%%%% SETTERS %%%%%%%%%%%%%%%%%%%

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setServices(List<ServiceEntity> services)
    {
        this.services = services;
    }

    public void setPossibleValidityPeriods(List<ValidityPeriodEntity> possibleValidityPeriods)
    {
        this.possibleValidityPeriods = possibleValidityPeriods;
    }

    public void setPossibleOptionalProducts(List<OptionalProductEntity> possibleOptionalProducts)
    {
        this.possibleOptionalProducts = possibleOptionalProducts;
    }

    public void setOrders(List<OrderEntity> orders)
    {
        this.orders = orders;
    }

}