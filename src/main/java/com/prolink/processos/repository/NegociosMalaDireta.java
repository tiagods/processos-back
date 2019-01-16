package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NegocioMalaDireta;

@Repository
public interface NegociosMalaDireta extends JpaRepository<NegocioMalaDireta, Long>{
}
