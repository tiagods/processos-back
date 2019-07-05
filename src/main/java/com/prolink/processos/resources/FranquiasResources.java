package com.prolink.processos.resources;

import java.net.URI;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.prolink.processos.model.negocio.Franquia;
import com.prolink.processos.services.FranquiasServices;

@RestController
@RequestMapping(value="/api/franquias")
public class FranquiasResources {
	
	@Autowired
	private FranquiasServices franquias;
	
	@RequestMapping(method=RequestMethod.GET)
	public ResponseEntity<List<Franquia>> listar() {
		return ResponseEntity.status(HttpStatus.OK).body(franquias.listar());
	}
	@RequestMapping(method=RequestMethod.POST)
	public ResponseEntity<Void> novo(@RequestBody Franquia franquia) {
		franquias.salvar(franquia);
		URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(franquia.getId()).toUri();
		return ResponseEntity.created(uri).build();
	}
	
	@RequestMapping(value="/{id}", method=RequestMethod.DELETE)
	public ResponseEntity<Void> deletar(@PathVariable Long id) {
		franquias.remover(id);
		return ResponseEntity.noContent().build();
	}
	
	@RequestMapping(value="/{id}", method=RequestMethod.PUT)
	public ResponseEntity<Void> atualizar(@RequestBody Franquia franquia, @PathVariable Long id) {
		franquia.setId(id);
		franquias.atualizar(franquia);
		return ResponseEntity.noContent().build();
	}
	@RequestMapping(value="/{lastUpdate}/periodo", method=RequestMethod.GET)
	public ResponseEntity<List<Franquia>> buscarPorAtualizados(@PathVariable String lastUpdate) {
		return ResponseEntity.status(HttpStatus.OK).body(franquias.filtrarPorPeriodo(lastUpdate));
	}
	
}
