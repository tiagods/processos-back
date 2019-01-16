package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NegocioOrigem;

@Repository
public interface NegociosOrigens extends JpaRepository<NegocioOrigem, Long>{
}
