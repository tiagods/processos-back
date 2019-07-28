package com.prolink.processos.services;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class NotificadorEmail{
    @Autowired
    private JavaMailSender mailSender;

    Logger log = LoggerFactory.getLogger(getClass());
    
    public void sendMail(String para, String assunto, String texto, File anexo, String nomeAnexo){
        if(para.trim().length()==0) return;
        try {
            MimeMessage mail = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mail, anexo!=null);
            helper.setTo(para.replace(" ","").split(";"));
            //usar enquanto não é salvo um log
            helper.setBcc("webmaster@prolinkcontabil.com.br");
            helper.setSubject(assunto);
            helper.setText(texto,true);
            helper.setFrom("documentos@prolinkcontabil.com.br","Documentos \\ Prolink Contabil");
            if(anexo!=null) helper.addAttachment(nomeAnexo, anexo);
            mailSender.send(mail);
        }catch(MessagingException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

}
