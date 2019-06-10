package com.prolink.processos.repository.helper.queries;

import java.util.List;

import com.prolink.processos.model.Notificacao;
import com.prolink.processos.model.NotificacaoEnvio;

public interface NotificacoesQueries {

	List<NotificacaoEnvio> notificacoesPendentes();

	List<Notificacao> buscarHoje();

	boolean verSeExiste(Notificacao notificacao);

}
