package com.prolink.processos.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.ProtocolosEntradas;
import com.prolink.processos.repository.Usuarios;

@Service
public class ProtocolosServices {

	@Autowired
	private Usuarios usuarios;
	@Autowired
	private ProtocolosEntradas entradas;
	
	public List<ProtocoloEntrada> documentosNaoDevolvidos(Usuario usuario){
		return entradas.documentosNaoDevolvidos(usuario);
	}
	public List<ProtocoloEntrada> documentosNaoRecebidos(Usuario usuario){
		return entradas.documentosNaoRecebidos(usuario);
	}
	public List<ProtocoloEntrada> documentosVenceHoje(Usuario usuario){
		return null;
	}
	
}
