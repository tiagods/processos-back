package com.prolink.processos.repository.helper.queries;

import java.util.Calendar;
import java.util.List;

import com.prolink.processos.model.Franquia;

public interface FranquiasQueries {
	public List<Franquia> filtrarPorPeriodo(Calendar lastUpdate);
}
