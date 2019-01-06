package com.prolink.processos.scheduler;

import java.time.LocalDateTime;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.prolink.processos.services.NotificacaoService;

@Component
public class NotificacaoJob {
	Logger logger = LoggerFactory.getLogger(getClass());
	@Autowired
	private NotificacaoService notificacao;
	@Scheduled(fixedRate = 3600000)//1800000
	public void scheduleFixedRateTask() {
	    notificacao.analisar();
	    logger.debug("Fixed rate task - " + LocalDateTime.now());
	    notificacao.enviarPendentes();
	    logger.debug("Send ok - " + LocalDateTime.now());
	}
}
