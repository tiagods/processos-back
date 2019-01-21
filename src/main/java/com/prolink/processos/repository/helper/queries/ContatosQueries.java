package com.prolink.processos.repository.helper.queries;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.filter.ContatoFilter;

public interface ContatosQueries {
	Page<Contato> filtrar(ContatoFilter filter,Pageable pageable);
}
