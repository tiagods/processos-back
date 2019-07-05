package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.negocio.NegocioNivel;

@Repository
public interface NegociosNiveis extends JpaRepository<NegocioNivel, Long>{
}
