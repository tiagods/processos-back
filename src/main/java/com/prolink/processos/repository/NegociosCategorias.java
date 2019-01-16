package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NegocioCategoria;

@Repository
public interface NegociosCategorias extends JpaRepository<NegocioCategoria, Long>{

}
