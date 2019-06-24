package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.ProtocoloItem;

@Repository
public interface ProtocolosItems extends JpaRepository<ProtocoloItem, Long>{
	
}
