package com.prolink.processos.scheduler;

import java.time.LocalDateTime;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.prolink.processos.services.NotificacaoService;

@Component
public class NotificacaoProtocoloJob {
	//@Value(value="${value.from}")
	//private String saudacao;

	private static final String TIME_ZONE = "America/Sao_Paulo";

	Logger logger = LoggerFactory.getLogger(getClass());
	@Autowired
	private JavaMailSender mailSender;
	
	@Scheduled(fixedRate=10000,zone = TIME_ZONE)
	//cron ira rodar todos os dias de segunda a sexta as 8:00
	//@Scheduled(cron = "0 0 8 ? * MON-FRI",zone = TIME_ZONE)
	public void emailFuncionarios() {
		logger.debug("Iniciando...->"+getClass().getSimpleName()+"->..."+LocalDateTime.now());
		System.out.println("Iniciando job ");
	}
	
	@Scheduled(cron = "0 0 8 ? * FRI",zone = TIME_ZONE)
	public void emailDiretorAndGerente(){
		
	}
}
