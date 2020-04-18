package com.prolink.processos.resources;

import java.net.URI;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.prolink.processos.model.negocio.Franquia;
import com.prolink.processos.services.FranquiasServices;

@RestController
@RequestMapping(value="/api/franquias")
public class FranquiasResources {
	
	@Autowired
	private FranquiasServices franquias;
	
	@GetMapping
	public ResponseEntity<List<Franquia>> listar() {
		return ResponseEntity.status(HttpStatus.OK).body(franquias.listar());
	}

	@PostMapping
	public ResponseEntity<Void> novo(@RequestBody Franquia franquia) {
		franquias.salvar(franquia);
		URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(franquia.getId()).toUri();
		return ResponseEntity.created(uri).build();
	}
	
	@DeleteMapping(value="/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Long id) {
		franquias.remover(id);
		return ResponseEntity.noContent().build();
	}
	
	@PutMapping(value="/{id}")
	public ResponseEntity<Void> atualizar(@RequestBody Franquia franquia, @PathVariable Long id) {
		franquia.setId(id);
		franquias.atualizar(franquia);
		return ResponseEntity.noContent().build();
	}

	@GetMapping(value="/{lastUpdate}/periodo")
	public ResponseEntity<List<Franquia>> buscarPorAtualizados(@PathVariable String lastUpdate) {
		return ResponseEntity.status(HttpStatus.OK).body(franquias.filtrarPorPeriodo(lastUpdate));
	}
	
}
