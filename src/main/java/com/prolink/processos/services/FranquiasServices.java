package com.prolink.processos.services;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.negocio.Franquia;
import com.prolink.processos.repository.Franquias;
import com.prolink.processos.services.exceptions.FranquiaNaoEncontradoException;

@Service
public class FranquiasServices {

	@Autowired
	private Franquias franquias;
	
	public void atualizar(Franquia franquia) {
		verificarExistencia(franquia);
		franquias.save(franquia);
	}

	public void atualizar(Long idFranquia) {
		Franquia franquia = buscar(idFranquia);
		franquia.setLastUpdate(Calendar.getInstance());
		franquias.save(franquia);
	}
	public Franquia buscar(Long id) {
		Optional<Franquia> franquia = franquias.findById(id);
		if(!franquia.isPresent()) {
			throw new FranquiaNaoEncontradoException("A franquia nao pode ser encontrada.");
		}
		return franquia.get();
	}
	
	public List<Franquia> filtrarPorPeriodo(String lastUpdate) {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat format = new SimpleDateFormat("ddMMyyyyHHmmss");
		try {
			calendar.setTime(format.parse(lastUpdate));
		} catch (ParseException e) {
			return new ArrayList<Franquia>();
		}
		return franquias.filtrarPorPeriodo(calendar);
	}
	public List<Franquia> listar() {
		return franquias.findAll();
	}

	public void remover(Long id) {
		try {
			franquias.deleteById(id);
		} catch (EmptyResultDataAccessException e) {
			throw new FranquiaNaoEncontradoException("A franquia nao pode ser encontrada.");
		}
	}
	public Franquia salvar(Franquia franquia) {
		franquia.setId(null);
		return franquias.save(franquia);
	}
	private void verificarExistencia(Franquia franquia) {
		buscar(franquia.getId());
	}
}
