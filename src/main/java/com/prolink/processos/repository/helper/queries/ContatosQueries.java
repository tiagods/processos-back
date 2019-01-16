package com.prolink.processos.repository.helper.queries;

import java.util.List;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.filter.ContatoFilter;

public interface ContatosQueries {
	List<Contato> filtrar(ContatoFilter filter);
}
