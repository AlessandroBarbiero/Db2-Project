package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "order", schema = "db2_database")
public class OrderEntity implements Serializable {

    private static final long serialVersionUID = 1L;

//%%%%%%%%%%% ATTRIBUTES %%%%%%%%%%%%%%

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @Column(name = "valid", nullable=false)
    private boolean valid;

    @Column(name = "startDate", nullable=false)
    private Date startDate;

    @Column(name = "creation", nullable=false)
    private Timestamp creation;

    @Column(name = "totalPrice", nullable=false)
    private float totalPrice;

//%%%%%%%%%%% RELATIONS %%%%%%%%%%%%%%

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinColumn (name = "userId")
    private UserEntity user;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinColumn (name = "validityPeriodId")
    private ValidityPeriodEntity validityPeriod;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinColumn (name = "servicePackageId")
    private ServicePackageEntity servicePackage;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable (name="optional_product_choice",
            joinColumns = @JoinColumn(name="orderId"),
            inverseJoinColumns= @JoinColumn (name="optionalProductId"))
    private List<OptionalProductEntity> optionalProducts;


//%%%%%%%%%%% CONSTRUCTORS %%%%%%%%%%%%%%

    public OrderEntity() {
    }

    public OrderEntity(Boolean valid, Date startDate, Timestamp creation) {
        this.valid = valid;
        this.startDate = startDate;
        this.creation = creation;
    }

//%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%

    public int getId() {
        return id;
    }

    public Boolean getValid() {
        return valid;
    }

    public Date getStartDate() {
        return startDate;
    }

    public Timestamp getCreation() {
        return creation;
    }

    public float getTotalPrice() {
        return totalPrice;
    }

    public UserEntity getUser() {
        return user;
    }

    public ValidityPeriodEntity getValidityPeriod() {
        return validityPeriod;
    }

    public ServicePackageEntity getServicePackage() {
        return servicePackage;
    }

    public List<OptionalProductEntity> getOptionalProducts() {
        return optionalProducts;
    }

//%%%%%%%%%%% SETTERS %%%%%%%%%%%%%%

    public void setId(int id) {
    this.id = id;
}

    public void setValid(Boolean valid) {
        this.valid = valid;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public void setCreation(Timestamp creation) {
        this.creation = creation;
    }

    public void setTotalPrice(float totalPrice) {
        this.totalPrice = totalPrice;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public void setValidityPeriod(ValidityPeriodEntity validityPeriod) {
        this.validityPeriod = validityPeriod;
    }

    public void setServicePackage(ServicePackageEntity servicePackage) {
        this.servicePackage = servicePackage;
    }

    public void setOptionalProducts(List<OptionalProductEntity> optionalProducts) {
        this.optionalProducts = optionalProducts;
    }
}
