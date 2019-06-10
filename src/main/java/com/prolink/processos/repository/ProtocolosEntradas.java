package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.ProtocoloEntrada;

@Repository
public interface ProtocolosEntradas extends JpaRepository<ProtocoloEntrada, Long>{
	
}
