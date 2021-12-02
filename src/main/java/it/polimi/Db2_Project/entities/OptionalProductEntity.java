package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "optional_product", schema = "db2_database")
public class OptionalProductEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "name", nullable=false)
    private String name;

    @Column(name = "monthlyFee", nullable=false)
    private float monthlyFee;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable (name="possible_extensions",
            joinColumns = @JoinColumn(name="optionalProductName"),
            inverseJoinColumns= @JoinColumn (name="servicePackageId"))
    private List<ServicePackageEntity> relatedServicePackages;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable (name="optional_product_choice",
            joinColumns = @JoinColumn(name="optionalProductName"),
            inverseJoinColumns= @JoinColumn (name="orderId"))
    private List<OrderEntity> relatedOrders;

    public OptionalProductEntity() {
    }

    public OptionalProductEntity(String name, float monthlyFee) {
        this.name = name;
        this.monthlyFee = monthlyFee;
    }

//%%%%%%%%%%%%%% GETTER %%%%%%%%%%%%%%%%%%%%%%%

    public String getName() {
        return name;
    }

    public float getMonthlyFee() {
        return monthlyFee;
    }

    public List<ServicePackageEntity> getRelatedServicePackages() {
        return relatedServicePackages;
    }

    public List<OrderEntity> getRelatedOrders() {
        return relatedOrders;
    }

//%%%%%%%%%%%%%%% SETTER %%%%%%%%%%%%%%%%%%%%%%%%%%

    public void setName(String name) {
        this.name = name;
    }

    public void setMonthlyFee(float monthlyFee) {
        this.monthlyFee = monthlyFee;
    }

    public void setRelatedServicePackages(List<ServicePackageEntity> relatedServicePackages)
    {
        this.relatedServicePackages = relatedServicePackages;
    }

    public void setRelatedOrders(List<OrderEntity> relatedOrders)
    {
        this.relatedOrders = relatedOrders;
    }

}
