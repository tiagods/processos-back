package com.prolink.processos.scheduler.job;

import java.io.UnsupportedEncodingException;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMailMessage;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import com.prolink.processos.services.CadastrosServices;

@Component
public class MensageiroJob implements Job {

    Logger logger = LoggerFactory.getLogger(getClass());
    
	@Autowired 
	private JavaMailSender mailSender;
    
    public void execute(JobExecutionContext context) throws JobExecutionException {

        logger.info("Job ** {} ** fired @ {}", context.getJobDetail().getKey().getName(), context.getFireTime());

        logger.info("Hello");
        
        try {
        	MimeMessage mail = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(mail);
			helper.setTo(new String[] {"tiago.dias@prolinkcontabil.com.br","suporte.ti@prolinkcontabil.com.br"});
			helper.setSubject("Testando envio pelo spring");
			helper.setText("<html><head></head><body><p>Hello from Spring Boot Application</p><h1>Teste</h1></body></html>",true);
			helper.setFrom("comunicadoprolink@prolinkcontabil.com.br","Prolink Contabil");
			mailSender.send(mail);
		} catch (MailException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
        
        logger.info("Next job scheduled @ {}", context.getNextFireTime());
        
    }
}
