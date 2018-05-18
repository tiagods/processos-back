package com.prolink.processos.resources;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.prolink.processos.model.Franquia;
import com.prolink.processos.services.FranquiasServices;

@RestController
@RequestMapping(value="/api/franquias")
public class FranquiasResources {
	
	@Autowired
	private FranquiasServices franquias;
	
	@RequestMapping(method=RequestMethod.GET)
	public List<Franquia> listar() {
		return franquias.listar();
	}
	@RequestMapping(method=RequestMethod.POST)
	public void novo(@RequestBody Franquia franquia) {
		franquias.salvar(franquia);
	}
	@RequestMapping(value="/{id}", method=RequestMethod.DELETE)
	public void deletar(@PathVariable Long id) {
		franquias.remover(id);
	}
	@RequestMapping(value="/{id}", method=RequestMethod.PUT)
	public void atualizar(@RequestBody Franquia franquia, @PathVariable Long id) {
		franquia.setId(id);
		franquias.atualizar(franquia);
	}
	@RequestMapping(value="/periodo/{lastUpdate}", method=RequestMethod.GET)
	public List<Franquia> deletar(@PathVariable String lastUpdate) {
		return franquias.filtrarPorPeriodo(lastUpdate);
	}
	
}
