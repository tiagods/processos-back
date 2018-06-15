package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.AppRegistro;

@Repository
public interface AppRegistros extends JpaRepository<AppRegistro, Long>{
	AppRegistro findByNome(String nome);
}
