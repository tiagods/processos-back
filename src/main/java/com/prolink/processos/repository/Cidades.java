package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Cidade;

@Repository
public interface Cidades extends JpaRepository<Cidade, Long>{

}
