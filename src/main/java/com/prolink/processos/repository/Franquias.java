package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Franquia;
import com.prolink.processos.repository.helper.queries.FranquiasQueries;

@Repository
public interface Franquias extends JpaRepository<Franquia, Long>,FranquiasQueries{
	
}
