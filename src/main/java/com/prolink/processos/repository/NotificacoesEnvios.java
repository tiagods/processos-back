package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NotificacaoEnvio;

@Repository
public interface NotificacoesEnvios extends JpaRepository<NotificacaoEnvio, Long>{
}
