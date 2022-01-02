package it.polimi.Db2_Project.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "schedule_activation", schema = "db2_database")
@NamedQueries({ @NamedQuery(name = "Schedule.findValid", query = "select sa from ScheduleActivationEntity sa where sa.order.user.id = :userId")})
public class ScheduleActivationEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    //%%%%%%%%%%% ATTRIBUTES %%%%%%%%%%%%%%

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable=false)
    private int id;

    @Column(name = "startDate", nullable=false)
    private Date start;

    @Column(name = "endDate", nullable=false)
    private Date end;

    //%%%%%%%%%%% RELATIONS %%%%%%%%%%%%%%
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn (name = "orderId", referencedColumnName = "id")
    private OrderEntity order;

    //%%%%%%%%%%% CONSTRUCTORS %%%%%%%%%%%%%%

    public ScheduleActivationEntity(){
    }

    public ScheduleActivationEntity(int id, Date start, Date end)
    {
        this.id = id;
        this.start = start;
        this.end = end;
    }

    //%%%%%%%%%%% GETTERS %%%%%%%%%%%%%%

    public int getId()
    {
        return id;
    }

    public Date getStart()
    {
        return start;
    }

    public Date getEnd()
    {
        return end;
    }

    public OrderEntity getOrder()
    {
        return order;
    }


    //%%%%%%%%%%% SETTERS %%%%%%%%%%%%%%


    public void setId(int id)
    {
        this.id = id;
    }

    public void setStart(Date start)
    {
        this.start = start;
    }

    public void setEnd(Date end)
    {
        this.end = end;
    }

    public void setOrder(OrderEntity order)
    {
        this.order = order;
    }
}
