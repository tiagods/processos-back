package com.prolink.processos.resources;

import java.net.URI;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.prolink.processos.model.negocio.FranquiaPacote;
import com.prolink.processos.services.FranquiasPacotesServices;
import com.prolink.processos.services.FranquiasServices;

@RestController
@RequestMapping(value="/api/franquias-pacotes")
public class FranquiasPacotesResource {

	@Autowired
	private FranquiasPacotesServices pacotes;
	
	@Autowired
	private FranquiasServices franquias;
	
	@GetMapping
	public ResponseEntity<List<FranquiaPacote>> listar() {
		return ResponseEntity.status(HttpStatus.OK).body(pacotes.listar());
	}
	
	@PostMapping(value="/{id}")
	public ResponseEntity<Void> adicionar(@PathVariable("id") Long franquiaId,@RequestBody FranquiaPacote pacote) {
		pacotes.atualizar(franquiaId, pacote);
		URI uri = ServletUriComponentsBuilder.fromCurrentRequest().
				build().toUri();
		franquias.atualizar(franquiaId);
		return ResponseEntity.created(uri).build();
	}
	@PutMapping(value="/{id}/{idFranquia}")
	public ResponseEntity<Void> atualizar(@RequestBody FranquiaPacote pacote, @PathVariable Long id,@PathVariable Long idFranquia) {
		pacote.setId(id);
		pacotes.atualizar(pacote);
		franquias.atualizar(idFranquia);
		return ResponseEntity.noContent().build();
	}
	
	@GetMapping(value="/{id}/franquia")
	public ResponseEntity<Set<FranquiaPacote>> buscarPorFranquia(@PathVariable Long id) {
		return ResponseEntity.status(HttpStatus.OK).body(pacotes.buscarPorFranquia(id));
	}
	
	@DeleteMapping(value="/{id}/{idFranquia}")
	public ResponseEntity<Void> deletarPacote(@PathVariable Long id,@PathVariable Long idFranquia) {
		pacotes.remover(id);
		franquias.atualizar(idFranquia);
		return ResponseEntity.noContent().build();
	}
}
