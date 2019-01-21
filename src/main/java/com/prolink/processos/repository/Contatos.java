package com.prolink.processos.repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.filter.ContatoFilter;

@Repository
public interface Contatos extends JpaRepository<Contato, Long>{
	Page<Contato> filtrar(ContatoFilter filter,Pageable pageable);
}
