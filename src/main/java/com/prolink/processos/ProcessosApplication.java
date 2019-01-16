package com.prolink.processos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@SpringBootApplication
public class ProcessosApplication extends SpringBootServletInitializer {
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(ProcessosApplication.class);
	}
	public static void main(String[] args) {
		SpringApplication.run(ProcessosApplication.class, args);
	}
	@RequestMapping(value="/")
	public String index1() {
		return "startPage";
	}
	@RequestMapping(value="/teste")
	public String teste() {
		return "index";
	}
	@RequestMapping(value="/conteudo")
	public String teste2() {
		return "conteudo";
	}
}

