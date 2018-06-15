package com.prolink.processos.resources;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.prolink.processos.services.AppRegistroServices;

@RestController
@RequestMapping("/api/licencas")
public class AppRegisterResource {
	@Autowired
	private AppRegistroServices registros;
	
	@RequestMapping(value="/{nome}", method=RequestMethod.GET)
	public ResponseEntity<?> buscarPorNome(@PathVariable String nome) {
		registros.buscarPorNome(nome);
		return ResponseEntity.noContent().build();
	}
	
}
