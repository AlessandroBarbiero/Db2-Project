package it.polimi.Db2_Project.entities;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "optional_product", schema = "db2_database")
@NamedQueries({
        @NamedQuery(name = "OptionalProduct.findAll", query = "select o from OptionalProductEntity o"),
        @NamedQuery(name = "OptionalProduct.findByName", query =
                "select o from OptionalProductEntity o " +
                        "where o.name = :name"),
        @NamedQuery(name = "OptionalProduct.findByPackage", query =
                "select op from ServicePackageEntity sp join sp.possibleOptionalProducts op " +
                        "where sp.id = :packId"),
        @NamedQuery(name = "OptionalProduct.findById", query =
                "select o from OptionalProductEntity o " +
                        "where o.id = :id")
})
public class OptionalProductEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Column(name = "name", nullable=false)
    private String name;

    @Column(name = "monthlyFee", nullable=false)
    private float monthlyFee;

    @ManyToMany(mappedBy = "possibleOptionalProducts", fetch = FetchType.LAZY,
            cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    private List<ServicePackageEntity> relatedServicePackages;

    @ManyToMany(mappedBy = "optionalProducts", fetch = FetchType.LAZY,
            cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    private List<OrderEntity> relatedOrders;

    public OptionalProductEntity() {
    }

    public OptionalProductEntity(String name, float monthlyFee) {
        this.name = name;
        this.monthlyFee = monthlyFee;
    }

//%%%%%%%%%%%%%% GETTER %%%%%%%%%%%%%%%%%%%%%%%

    public int getId() {
        return id;
    }

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

    public void setRelatedServicePackages(List<ServicePackageEntity> relatedServicePackages) {
        this.relatedServicePackages = relatedServicePackages;
    }

    public void setRelatedOrders(List<OrderEntity> relatedOrders)
    {
        this.relatedOrders = relatedOrders;
    }

    public void addToServicePackage(ServicePackageEntity servicePackage){
        if(relatedServicePackages == null)
            relatedServicePackages = new ArrayList<>();
        relatedServicePackages.add(servicePackage);
    }

    @Override
    public String toString() {
        return  name + " \u27A2 " +
                "Monthly fee = " + String.format("%.2f", monthlyFee) + "€";
    }
}
