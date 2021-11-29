package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "order", schema = "db2_database")
public class OrderEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @ManyToOne
    @JoinColumn (name = "userId")
    private UserEntity user;

    @ManyToMany
    @JoinTable (name="optional_product_choice",
            joinColumns = @JoinColumn(name="orderId"),
            inverseJoinColumns= @JoinColumn (name="optionalProductName"))
    private List<OptionalProductEntity> optionalProducts;

    public OrderEntity() {
    }

//%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%

    public int getId() {
        return id;
    }

    public UserEntity getUser() {
        return user;
    }

//%%%%%%%%%%% SETTERS %%%%%%%%%%%%%%

    public void setUser(UserEntity user) {
        this.user = user;
        //todo: probably there is something to add for database updating
    }

    public void setId(int id) {
        this.id = id;
    }
}
