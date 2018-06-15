package com.prolink.processos.services;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.Franquia;
import com.prolink.processos.model.FranquiaPacote;
import com.prolink.processos.repository.FranquiasPacotes;
import com.prolink.processos.services.exceptions.FranquiaPacoteNaoEncontradoException;

@Service
public class FranquiasPacotesServices {
	
	@Autowired
	private FranquiasPacotes pacotes;
	
	@Autowired
	private FranquiasServices franquias;
	
	public void atualizar(FranquiaPacote pacote) {
		verificarExistencia(pacote);
		pacotes.save(pacote);
	}
	
	public FranquiaPacote buscar(Long id) {
		FranquiaPacote pacote = pacotes.findOne(id);
		if(pacote == null) {
			throw new FranquiaPacoteNaoEncontradoException("O pacote da franquia nao pode ser encontrado.");
		}
		return pacote;
	}
	
	public List<FranquiaPacote> listar() {
		return pacotes.findAll();
	}
	public void remover(Long id) {
		try {
			pacotes.delete(id);
		} catch (EmptyResultDataAccessException e) {
			throw new FranquiaPacoteNaoEncontradoException("O pacote da franquia nao pode ser encontrado.");
		}
	}
	public FranquiaPacote salvar(FranquiaPacote pacote) {
		pacote.setId(null);
		return pacotes.save(pacote);
	}
	
	public FranquiaPacote atualizar(Long franquiaId, FranquiaPacote pacote) {
		Franquia franquia = franquias.buscar(franquiaId);
		pacote.setFranquia(franquia);
		pacote =  pacotes.save(pacote);
		return pacote;
	}
	private void verificarExistencia(FranquiaPacote pacote) {
		buscar(pacote.getId());
	}

	public Set<FranquiaPacote> buscarPorFranquia(Long id) {
		Franquia franquia = franquias.buscar(id);
		return franquia.getPacotes();
	}
}
