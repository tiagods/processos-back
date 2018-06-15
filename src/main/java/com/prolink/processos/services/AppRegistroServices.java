package com.prolink.processos.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.AppRegistro;
import com.prolink.processos.repository.AppRegistros;
import com.prolink.processos.services.exceptions.AppRegistroNaoEncontradoException;

@Service
public class AppRegistroServices {
	@Autowired
	private AppRegistros registros;

	public AppRegistro buscarPorNome(String nome) {
		AppRegistro app = registros.findByNome(nome);
		if(app==null) {
			throw new AppRegistroNaoEncontradoException("Aplicativo nao registrado");
		}
		return app;
	}
	
}
