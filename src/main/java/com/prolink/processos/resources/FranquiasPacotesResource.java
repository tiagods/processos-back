package com.prolink.processos.resources;

import java.net.URI;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.prolink.processos.model.FranquiaPacote;
import com.prolink.processos.services.FranquiasPacotesServices;
import com.prolink.processos.services.FranquiasServices;

@RestController
@RequestMapping(value="/api/franquias-pacotes")
public class FranquiasPacotesResource {

	@Autowired
	private FranquiasPacotesServices pacotes;
	
	@Autowired
	private FranquiasServices franquias;
	
	@RequestMapping(method=RequestMethod.GET,produces= {MediaType.APPLICATION_JSON_VALUE,MediaType.APPLICATION_XML_VALUE})
	public ResponseEntity<List<FranquiaPacote>> listar() {
		return ResponseEntity.status(HttpStatus.OK).body(pacotes.listar());
	}
	
	@RequestMapping(value="/{id}",method= RequestMethod.POST)
	public ResponseEntity<Void> adicionar(@PathVariable("id") Long franquiaId,@RequestBody FranquiaPacote pacote) {
		pacotes.atualizar(franquiaId, pacote);
		URI uri = ServletUriComponentsBuilder.fromCurrentRequest().
				build().toUri();
		franquias.atualizar(franquiaId);
		return ResponseEntity.created(uri).build();
	}
	@RequestMapping(value="/{id}/{idFranquia}", method=RequestMethod.PUT)
	public ResponseEntity<Void> atualizar(@RequestBody FranquiaPacote pacote, @PathVariable Long id,@PathVariable Long idFranquia) {
		pacote.setId(id);
		pacotes.atualizar(pacote);
		franquias.atualizar(idFranquia);
		return ResponseEntity.noContent().build();
	}
	
	@RequestMapping(value="/{id}/franquia", method=RequestMethod.GET)
	public ResponseEntity<Set<FranquiaPacote>> buscarPorFranquia(@PathVariable Long id) {
		return ResponseEntity.status(HttpStatus.OK).body(pacotes.buscarPorFranquia(id));
	}
	
	@RequestMapping(value="/{id}/{idFranquia}", method=RequestMethod.DELETE)
	public ResponseEntity<Void> deletarPacote(@PathVariable Long id,@PathVariable Long idFranquia) {
		pacotes.remover(id);
		franquias.atualizar(idFranquia);
		return ResponseEntity.noContent().build();
	}
}
