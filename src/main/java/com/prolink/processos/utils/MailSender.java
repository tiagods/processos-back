package com.prolink.processos.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.io.UnsupportedEncodingException;

@Component
public class MailSender {
    @Autowired
    private JavaMailSender mailSender;

    public void sendMail(String para, String assunto, String texto, File anexo, String nomeAnexo){
        if(para.trim().length()==0) return;
        try {
            MimeMessage mail = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mail, anexo!=null);
            helper.setTo(para.replace(" ","").split(";"));
            helper.setSubject(assunto);
            helper.setText(texto,true);
            helper.setFrom("webmaster@prolinkcontabil.com.br","Documentos \\ Prolink Contabil");
            if(anexo!=null)
                helper.addAttachment(nomeAnexo, anexo);
            mailSender.send(mail);
        }catch(MessagingException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

}
