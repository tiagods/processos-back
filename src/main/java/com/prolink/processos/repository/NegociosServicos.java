package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NegocioServico;

@Repository
public interface NegociosServicos extends JpaRepository<NegocioServico, Long>{
}