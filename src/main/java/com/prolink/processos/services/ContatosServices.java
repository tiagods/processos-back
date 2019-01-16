package com.prolink.processos.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.Contatos;
import com.prolink.processos.repository.filter.ContatoFilter;
import com.prolink.processos.services.exceptions.ContatoNaoEncontradoException;

@Service
public class ContatosServices {

	@Autowired
	private Contatos contatos;
	
	public List<Contato> filtrar(ContatoFilter filter){
		return contatos.filtrar(filter);
	}
	
	public Contato buscar(Long id) {
		Optional<Contato> contato = contatos.findById(id);
		if(!contato.isPresent()) {
			throw new ContatoNaoEncontradoException("O contato nao pode ser encontrado");
		}
		return contato.get();
	}	

	public List<Contato> listar() {
		return contatos.findAll();
	}
	
	
	public Contato salvar(Contato contato) {
		contato.setId(null);
		return contatos.save(contato);
	}

	public void remover(Long id) {
		try{
			contatos.deleteById(id);
		}catch (EmptyResultDataAccessException e) {
			throw new ContatoNaoEncontradoException("O contato nao pode ser encontrado");
		}
	}
	public void atualizar(Contato contato) {
		verificarExistencia(contato);
		contatos.save(contato);
	}
	public void verificarExistencia(Contato contato) {
		buscar(contato.getId());
	}

}
