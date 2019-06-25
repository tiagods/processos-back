package com.prolink.processos.services;

import java.util.Calendar;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.ProtocolosEntradas;
import com.prolink.processos.services.exceptions.ProtocoloEntradaNaoEncontradoException;

@Service
public class ProtocolosServices {

	@Autowired
	private ProtocolosEntradas entradas;
	
	public ProtocoloEntrada buscar(ProtocoloEntrada pe) {
		Optional<ProtocoloEntrada> result = entradas.findById(pe.getId());
		if(result.isPresent()) return result.get();
		else throw new ProtocoloEntradaNaoEncontradoException("Registro não encontrado");
	}
	
	public List<ProtocoloEntrada> documentosNaoDevolvidos(Usuario usuario){
		if(usuario!=null)
			return entradas.documentosNaoDevolvidos(usuario);
		else return entradas.documentosNaoDevolvidos(); 
	}
	public List<ProtocoloEntrada> documentosNaoRecebidos(Usuario usuario){
		if(usuario!=null)
			return entradas.documentosNaoRecebidos(usuario);
		else return entradas.documentosNaoRecebidos();
	}
	public List<ProtocoloEntrada> documentosVenceHoje(Usuario usuario){
		return entradas.documentosVenceHoje(usuario, Calendar.getInstance());
	}
	
}
