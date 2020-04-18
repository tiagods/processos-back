package com.prolink.processos.resources;

import java.net.URI;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.prolink.processos.model.negocio.Contato;
import com.prolink.processos.services.ContatosServices;

@RestController
@RequestMapping(value="/api/contatos")
public class ContatosResources {
	@Autowired
	private ContatosServices contatos;

	@GetMapping
	public ResponseEntity<?> listar() {
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"message\":\"Registros não serao liberados por essa api, consulte desenvolvedor\"}");
	}
	
	@PostMapping
	public ResponseEntity<?> novo(@RequestBody Contato contato) {
		contato = contatos.salvar(contato);
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"message\":\"Registros não serao liberados por essa api, consulte desenvolvedor\"}");
//		URI uri = ServletUriComponentsBuilder.fromCurrentRequest().
//				path("/{id}").buildAndExpand(contato.getId()).toUri();
//		return ResponseEntity.created(uri).build();
	}

	@GetMapping(value ="/{id}")
	public ResponseEntity<?> buscar(@PathVariable Long id) {
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"message\":\"Registros não serao liberados por essa api, consulte desenvolvedor\"}");
	}

	@DeleteMapping(value="/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Long id) {
		contatos.remover(id);
		return ResponseEntity.noContent().build();
	}
	
	@PutMapping(value="/{id}")
	public ResponseEntity<?> atualizar(@RequestBody Contato contato, @PathVariable Long id) {
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"message\":\"Registros não serao liberados por essa api, consulte desenvolvedor\"}");
	}
}
