package com.prolink.processos.resources;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.prolink.processos.model.AppRegistro;
import com.prolink.processos.services.AppRegistroServices;

@RestController
@RequestMapping("/api/licencas")
public class AppRegisterResource {
	@Autowired
	private AppRegistroServices registros;
	
	@GetMapping(value="/{nome}")
	public ResponseEntity<?> buscarPorNome(@PathVariable String nome) {
		AppRegistro app = registros.buscarPorNome(nome);
		return ResponseEntity.status(HttpStatus.OK).body(app);
	}
	
}
