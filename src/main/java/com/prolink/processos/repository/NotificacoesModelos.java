package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NotificacaoModelo;

@Repository
public interface NotificacoesModelos extends JpaRepository<NotificacaoModelo, Long>{
}
