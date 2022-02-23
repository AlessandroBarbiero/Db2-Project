package it.polimi.Db2_Project.entities;
import jakarta.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Table(name = "blacklist", schema = "db2_database")
@NamedQueries({
        @NamedQuery(name = "Blacklist.findAll",
                query = "select b from BlacklistEntity b")
})
public class BlacklistEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "userId", nullable=false)
    private int userId;

    @Column(name = "username", nullable = false)
    private String username;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "lastRejection", nullable = false)
    private Timestamp lastRejection;

    @Column(name = "amount", nullable = false)
    private float amount;

//%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%

    public BlacklistEntity() {
    }

    public BlacklistEntity(int userId, String username, String email, Timestamp lastRejection, float amount) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.lastRejection = lastRejection;
        this.amount = amount;
    }

//%%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%%

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public float getAmount() {
        return amount;
    }

    public Timestamp getLastRejection() {
        return lastRejection;
    }

//%%%%%%%%%%% SETTERS %%%%%%%%%%%

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public void setLastRejection(Timestamp lastRejection) {
        this.lastRejection = lastRejection;
    }

}
