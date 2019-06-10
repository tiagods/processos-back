package com.prolink.processos.services;

import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.Notificacao;
import com.prolink.processos.model.NotificacaoEnvio;
import com.prolink.processos.repository.Notificacoes;
import com.prolink.processos.repository.NotificacoesEnvios;

@Service
public class NotificacaoService {
	Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
	private Notificacoes notificacao;
	@Autowired
	private NotificacoesEnvios envios;
	@Transactional
	public void analisar() {
		List<Notificacao> result = notificacao.buscarHoje();
		for(Notificacao n : result) {
			if(!notificacao.verSeExiste(n)) {
				NotificacaoEnvio ne = new NotificacaoEnvio();
				ne.setNotificacao(n);
				ne.setStatus(false);
				envios.save(ne);
			}
		}
	}
	public List<NotificacaoEnvio> pendentes(){
		return notificacao.notificacoesPendentes();
	}
	@Transactional
	public void salvar(NotificacaoEnvio ne) {
		envios.save(ne);
	}
	public boolean verificarEnvio(NotificacaoEnvio ne) {
		Optional<NotificacaoEnvio> result = envios.findById(ne.getId());
		if(result.isPresent()) {
			NotificacaoEnvio n = result.get();
			return n.isStatus();
		}
		else return true;
	}
	
	
}
