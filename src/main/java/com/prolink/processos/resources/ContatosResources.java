package com.prolink.processos.resources;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.prolink.processos.model.Contato;
import com.prolink.processos.services.ContatosServices;

@RestController
@RequestMapping(value="/api/contatos")
public class ContatosResources {
	@Autowired
	private ContatosServices contatos;
	
	@RequestMapping(method=RequestMethod.GET)
	public List<Contato> listar() {
		return contatos.listar();
	}
	@RequestMapping(method=RequestMethod.POST)
	public void novo(@RequestBody Contato contato) {
		contatos.salvar(contato);
	}
	@RequestMapping(value="/{id}", method=RequestMethod.DELETE)
	public void deletar(@PathVariable Long id) {
		contatos.remover(id);
	}
	@RequestMapping(value="/{id}", method=RequestMethod.PUT)
	public void atualizar(@RequestBody Contato contato, @PathVariable Long id) {
		contato.setId(id);
		contatos.atualizar(contato);
	}
	
}
