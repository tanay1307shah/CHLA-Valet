package com.example.CHLAserver.Model;

import javax.persistence.*;

@Entity
@Table(name = "Requests")
public class Requests {


    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String ticketNumber;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
    }
}
