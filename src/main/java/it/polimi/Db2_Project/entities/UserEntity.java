package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "user", schema = "db2_database")
public class UserEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @Column(name = "username", unique=true, nullable=false)
    private String username;

    @Column(name = "password", nullable=false)
    private String password;

    @Column(name = "email", unique=true, nullable=false)
    private String email;

    @OneToMany(fetch = FetchType.LAZY, mappedBy="userId", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderEntity> orders;


    public UserEntity() {
    }

    public UserEntity(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
    }

//%%%%%%%%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%%%%%%%%%%%

    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public List<OrderEntity> getOrders() {
        return orders;
    }

//%%%%%%%%%%%%%%%%%% SETTERS %%%%%%%%%%%%%%%%%%%

    public void setId(int user_id) {
        this.id = user_id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setOrders(List<OrderEntity> orders) {
        this.orders = orders;
    }
}