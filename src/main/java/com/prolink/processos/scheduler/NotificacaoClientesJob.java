package com.prolink.processos.scheduler;

import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.prolink.processos.model.NotificacaoEnvio;
import com.prolink.processos.services.NotificacaoService;


@Component
@PropertySource("classpath:clientes.properties")
public class NotificacaoClientesJob{
	private Logger logger = LoggerFactory.getLogger(getClass());
	@Autowired
	private NotificacaoService notificacao;
	@Autowired
	private JavaMailSender mailSender;

	private static final String TIME_ZONE = "America/Sao_Paulo";

	@Scheduled(cron="${notificacao.cliente.job}", zone = TIME_ZONE)
	public void execute() {
		logger.info("Iniciando...->"+getClass().getSimpleName()+"->..."+LocalDateTime.now());
		
		notificacao.analisar();
	    List<NotificacaoEnvio> ne = notificacao.pendentes();
	    for(NotificacaoEnvio n : ne) {
	    	try {
				if(notificacao.verificarEnvio(n)) continue;
				MimeMessage mail = mailSender.createMimeMessage();
				MimeMessageHelper helper = new MimeMessageHelper(mail);
				helper.setTo(n.getNotificacao().getPara().replace(" ", "").split(";"));
				if(!n.getNotificacao().getCc().trim().equals(""))
					helper.setCc(n.getNotificacao().getCc().replace(" ", "").split(";"));
				if(!n.getNotificacao().getCo().trim().equals(""))
					helper.setBcc(n.getNotificacao().getCo().replace(" ", "").split(";"));
				helper.setSubject(n.getNotificacao().getAssunto());
				helper.setText(n.getNotificacao().getModelo().getTexto(),true);
				helper.setFrom(n.getNotificacao().getDe(),n.getNotificacao().getAutor());
				mailSender.send(mail);
				n.setDataEnvio(Calendar.getInstance());
				n.setStatus(true);
				notificacao.salvar(n);
				logger.debug("Send ok - "+n.getId()+" - "+LocalDateTime.now());
			} catch (NullPointerException | MailException | MessagingException | UnsupportedEncodingException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			}
	    }
	    logger.info("Fim da execucao: "+LocalDateTime.now());
	}
}
