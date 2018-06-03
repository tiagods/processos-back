package com.prolink.processos.resources;

import java.net.URI;
import java.util.List;

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

import com.prolink.processos.model.Contato;
import com.prolink.processos.services.ContatosServices;

@RestController
@RequestMapping(value="/api/contatos")
public class ContatosResources {
	@Autowired
	private ContatosServices contatos;
	
	@RequestMapping(method=RequestMethod.GET,produces={MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	public ResponseEntity<List<Contato>> listar() {
		return ResponseEntity.status(HttpStatus.OK).body(contatos.listar());
	}
	
	@RequestMapping(method=RequestMethod.POST)
	public ResponseEntity<Void> novo(@RequestBody Contato contato) {
		contato = contatos.salvar(contato);
		//ao salvar um objeto informarei para o cliente onde ele vai localizar o recurso com codigo httpstatus 201
		URI uri = ServletUriComponentsBuilder.fromCurrentRequest().
				path("/{id}").buildAndExpand(contato.getId()).toUri();
		return ResponseEntity.created(uri).build();
	}
	
	@RequestMapping(value ="/{id}", method=RequestMethod.GET)
	public ResponseEntity<?> buscar(@PathVariable Long id) {
		Contato contato = contatos.buscar(id);
		return ResponseEntity.status(HttpStatus.OK).body(contato);			
	}
	@RequestMapping(value="/{id}", method=RequestMethod.DELETE)
	public ResponseEntity<Void> deletar(@PathVariable Long id) {
		contatos.remover(id);
		return ResponseEntity.noContent().build();
	}
	
	@RequestMapping(value="/{id}", method=RequestMethod.PUT)
	public ResponseEntity<Void> atualizar(@RequestBody Contato contato, @PathVariable Long id) {
		contato.setId(id);
		contatos.atualizar(contato);
		return ResponseEntity.noContent().build();
	}
}
