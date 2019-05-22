package com.example.CHLAserver.Server.Model;

import org.hibernate.annotations.Type;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(updatable = false, nullable = false)
    private Long Id;

    @Column(name = "username",updatable = true,nullable = false)
    @NotNull
    private String username;

    @NotNull
    @Column(name = "password",updatable = true,nullable = false)
    private String password;

    @NotNull
    @Column(name = "enabled",updatable = true,nullable = false,columnDefinition = "TINYINT(1)")
    private boolean enabled;

    public Employee() {
    }

    public Employee(@NotNull String username, @NotNull String password, @NotNull boolean enabled) {
        this.username = username;
        this.password = password;
        this.enabled = enabled;
    }

    public Long getId() {
        return Id;
    }

    public void setId(Long id) {
        Id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }


}
