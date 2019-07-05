package com.prolink.processos.repository;

import com.prolink.processos.model.Departamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Departamentos extends JpaRepository<Departamento,Long> {
}
