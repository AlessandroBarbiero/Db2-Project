package it.polimi.Db2_Project.entities;
import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "employee", schema = "db2_database")
@NamedQueries(
        {
                @NamedQuery(
                        name = "Employee.findByUsername",
                        query = "SELECT e " +
                                "FROM EmployeeEntity e " +
                                "WHERE e.username = :username"
                )

        }
)

public class EmployeeEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    //%%%%%%%%%%% ATTRIBUTES %%%%%%%%%%%%%%

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @Column(name = "username", unique=true, nullable=false)
    private String username;

    @Column(name = "password", nullable=false)
    private String password;

    //%%%%%%%%%%% CONSTRUCTORS %%%%%%%%%%%%%%

    public EmployeeEntity(){
    }

    public EmployeeEntity(String username, String password){
        this.username = username;
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

}
