package com.prolink.processos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class ProcessosApplication {
	public static void main(String[] args) {
		SpringApplication.run(ProcessosApplication.class, args);
	}
}

