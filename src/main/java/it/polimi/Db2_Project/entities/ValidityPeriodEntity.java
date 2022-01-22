package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "validity_period", schema = "db2_database")
@NamedQueries({
        @NamedQuery(name = "ValidityPeriod.findAll", query =
                "select v from ValidityPeriodEntity v " +
                        "order by v.numberOfMonths"),
        @NamedQuery(name = "ValidityPeriod.findByPackage", query =
                "select v from ValidityPeriodEntity v join v.servicePackages sp " +
                        "where sp.id = :packId"),
        @NamedQuery(name = "ValidityPeriod.findById", query =
                "select v from ValidityPeriodEntity v " +
                        "where v.id = :id")
})

public class ValidityPeriodEntity implements Serializable {

    private static final long serialVersionUID = 1L;

//%%%%%%%%%%% ATTRIBUTES %%%%%%%%%%%%%%

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @Column(name = "monthlyFee", nullable=false)
    private float monthlyFee;

    @Column(name = "numberOfMonths", nullable=false)
    private int numberOfMonths;

//%%%%%%%%%%% RELATIONS %%%%%%%%%%%%%%

    @ManyToMany(mappedBy = "possibleValidityPeriods", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<ServicePackageEntity> servicePackages;

    @OneToMany(fetch = FetchType.LAZY, mappedBy="validityPeriod", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderEntity> orders;

//%%%%%%%%%%% CONSTRUCTORS %%%%%%%%%%%%%%

    public ValidityPeriodEntity() {

    }

    public ValidityPeriodEntity(float monthlyFee, int numberOfMonths) {
        this.monthlyFee = monthlyFee;
        this.numberOfMonths = numberOfMonths;
    }

//%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%

    public int getId() {
        return id;
    }

    public float getMonthlyFee() {
        return monthlyFee;
    }

    public int getNumberOfMonths() {
        return numberOfMonths;
    }

    public List<OrderEntity> getOrders()
    {
        return orders;
    }

    public List<ServicePackageEntity> getServicePackages()
    {
        return servicePackages;
    }

//%%%%%%%%%%% SETTERS %%%%%%%%%%%%%%

    public void setId(int id) {
        this.id = id;
    }

    public void setMonthlyFee(float monthlyFee) {
        this.monthlyFee = monthlyFee;
    }

    public void setNumberOfMonths(int numberOfMonths) {
        this.numberOfMonths = numberOfMonths;
    }

    public void setOrders(List<OrderEntity> orders)
    {
        this.orders = orders;
    }

    public void setServicePackages(List<ServicePackageEntity> servicePackages)
    {
        this.servicePackages = servicePackages;
    }

    public void addToServicePackage(ServicePackageEntity servicePackage){
        if(servicePackages == null)
            servicePackages = new ArrayList<>();
        servicePackages.add(servicePackage);
    }

    @Override
    public String toString() {
        return "Monthly fee = " + String.format("%.2f", monthlyFee) + "€, " +
                "Number of months = " + numberOfMonths;
    }

    public static boolean findSameNumberOfMonths(List<ValidityPeriodEntity> list, ValidityPeriodEntity el){
        int numOfMonths = el.getNumberOfMonths();
        for(ValidityPeriodEntity val : list){
            if(val.getNumberOfMonths() == numOfMonths)
                return true;
        }
        return false;
    }
}
