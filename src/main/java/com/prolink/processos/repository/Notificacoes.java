package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Notificacao;
import com.prolink.processos.repository.helper.queries.NotificacoesQueries;

@Repository
public interface Notificacoes extends JpaRepository<Notificacao, Long>,NotificacoesQueries {

}
