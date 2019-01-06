package com.prolink.processos.services;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.Notificacao;
import com.prolink.processos.model.NotificacaoEnvio;
import com.prolink.processos.repository.Notificacoes;
import com.prolink.processos.repository.NotificacoesEnvios;

@Service
public class NotificacaoService {
	Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired 
	private JavaMailSender mailSender;
	@Autowired
	private Notificacoes notificacao;
	@Autowired
	private NotificacoesEnvios envios;
	@Transactional
	public void analisar() {
		List<Notificacao> result = notificacao.buscarHoje();
		List<NotificacaoEnvio> notEnvios = new ArrayList<>();
		for(Notificacao n : result) {
			if(!notificacao.verSeExiste(n)) {
				NotificacaoEnvio ne = new NotificacaoEnvio();
				ne.setNotificacao(n);
				ne.setStatus(false);
				notEnvios.add(ne);
			}
		}
		if(!notEnvios.isEmpty()) envios.saveAll(notEnvios);
	}
	@Transactional
	public void enviarPendentes() {
		List<NotificacaoEnvio> ne = notificacao.notificacoesPendentes();
		List<NotificacaoEnvio> nList = new ArrayList<>();
		for (NotificacaoEnvio n : ne) {
			try {
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
				nList.add(n);
			} catch (NullPointerException | MailException | MessagingException | UnsupportedEncodingException e) {
				logger.error(e.getMessage());
			}
		}
		if(!nList.isEmpty()) envios.saveAll(nList);
	}
}
