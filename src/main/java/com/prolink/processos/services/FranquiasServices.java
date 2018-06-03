package com.prolink.processos.services;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.Franquia;
import com.prolink.processos.repository.Franquias;

@Service
public class FranquiasServices {

	@Autowired
	private Franquias franquias;
	
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

	public void salvar(Franquia franquia) {
		franquias.save(franquia);
	}

	public void remover(Long id) {
		franquias.delete(id);
		
	}

	public void atualizar(Franquia franquia) {
		franquias.save(franquia);
	}
	
}
