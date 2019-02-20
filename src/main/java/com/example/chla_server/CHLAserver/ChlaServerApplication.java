package com.example.chla_server.CHLAserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@ComponentScan({"com.example.chla_server.CHLAserver.controller", "com.example.chla_server.CHLAserver.service", "com.example.chla_server.CHLAserver.model","com.example.chla_server.CHLAserver.repositories"})
public class ChlaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChlaServerApplication.class, args);
	}

}

