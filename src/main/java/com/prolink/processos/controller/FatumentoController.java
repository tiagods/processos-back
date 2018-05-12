package com.prolink.processos.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value="/faturamento")
public class FatumentoController {
	@RequestMapping
	public String index() {
		return "clientes/Faturamento";
	}
}
