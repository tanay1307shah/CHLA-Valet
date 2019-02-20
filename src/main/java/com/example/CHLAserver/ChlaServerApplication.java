package com.example.CHLAserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@ComponentScan({"com.example.CHLAserver.controller", "com.example.CHLAserver.Model","com.example.CHLAserver.Repositories","com.example.CHLAserver.Service"})
@SpringBootApplication
public class ChlaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChlaServerApplication.class, args);
	}

}
