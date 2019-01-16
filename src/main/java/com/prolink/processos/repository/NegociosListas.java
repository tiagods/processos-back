package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NegocioLista;

@Repository
public interface NegociosListas extends JpaRepository<NegocioLista, Long>{
}
