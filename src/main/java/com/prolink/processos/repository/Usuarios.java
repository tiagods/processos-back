package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Usuario;

@Repository
public interface Usuarios extends JpaRepository<Usuario, Long>{
}
