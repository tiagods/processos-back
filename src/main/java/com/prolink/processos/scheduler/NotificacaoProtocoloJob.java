package com.prolink.processos.scheduler;

import java.time.LocalDateTime;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.prolink.processos.services.NotificacaoService;

@Component
@EnableScheduling
public class NotificacaoProtocoloJob {
	Logger logger = LoggerFactory.getLogger(getClass());
	@Autowired
	private NotificacaoService notificacao;
	@Autowired 
	private JavaMailSender mailSender;
	
	@Scheduled(fixedDelay=1000)
	public void execute() {
		logger.debug("Iniciando...->"+getClass().getSimpleName()+"->..."+LocalDateTime.now());
	}
	
	
}
