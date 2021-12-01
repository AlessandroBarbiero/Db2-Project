package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "validity_period", schema = "db2_database")
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

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable (name="possible_validity_period",
            joinColumns = @JoinColumn(name="validityPeriodId"),
            inverseJoinColumns= @JoinColumn (name="servicePackageId"))
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

}
