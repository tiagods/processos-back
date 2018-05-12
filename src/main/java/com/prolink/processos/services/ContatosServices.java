package com.prolink.processos.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.ContatosRepository;

@Service
public class ContatosServices {

	@Autowired
	private ContatosRepository contatos;
	
	public List<Contato> listar() {
		return contatos.findAll();
	}

	public void salvar(Contato contato) {
		contatos.save(contato);
	}

	public void remover(Long id) {
		contatos.delete(id);
		
	}

	public void atualizar(Contato contato) {
		contatos.save(contato);
	}

}
