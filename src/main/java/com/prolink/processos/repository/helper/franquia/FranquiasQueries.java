package com.prolink.processos.repository.helper.franquia;

import java.util.Calendar;
import java.util.List;

import com.prolink.processos.model.Franquia;

public interface FranquiasQueries {
	public List<Franquia> filtrarPorPeriodo(Calendar lastUpdate);
}
