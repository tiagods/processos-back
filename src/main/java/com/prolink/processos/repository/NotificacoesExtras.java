package com.prolink.processos.repository;

import java.util.Calendar;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.NotificacaoExtra;
import com.prolink.processos.model.NotificacaoExtra.NotificacaoResumo;

@Repository
public interface NotificacoesExtras extends JpaRepository<NotificacaoExtra, Long>{

	NotificacaoExtra findByDataAndDestinoAndResumo(Calendar data, String destino, NotificacaoResumo resumo);
}
