package com.prolink.processos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@SpringBootApplication
public class ProcessosApplication {

	public static void main(String[] args) {
		SpringApplication.run(ProcessosApplication.class, args);
	}
	
	@RequestMapping("/")
	public String index1() {
		return "startPage";
	}
}

