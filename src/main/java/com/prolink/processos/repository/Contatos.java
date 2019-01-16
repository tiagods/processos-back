package com.prolink.processos.repository;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.filter.ContatoFilter;

@Repository
public interface Contatos extends JpaRepository<Contato, Long>{
	List<Contato> filtrar(ContatoFilter filter);
}
