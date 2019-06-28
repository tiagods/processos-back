package com.prolink.processos;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.test.context.junit4.SpringRunner;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.Usuarios;
import com.prolink.processos.services.HTMLTextProtocoloEntradaService;
import com.prolink.processos.services.ProtocolosServices;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	@Autowired
	private Usuarios usuarios;
	
	@Autowired
	private ProtocolosServices pe;
	
	@Autowired
	private HTMLTextProtocoloEntradaService htmlText;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Value("${protocolos.email}")
	private String contasSuperior;
	
	@Test
	public void contextLoads() {
		/*
		List<Usuario> users = usuarios.listarUsuariosProtocolosPendentes();
		Calendar hoje = Calendar.getInstance();
		for(Usuario user : users) {
			StringBuilder builder = new StringBuilder();
			List<ProtocoloEntrada> naoRecebidos = pe.documentosNaoRecebidos(user);
			List<ProtocoloEntrada> naoDevolvidos = pe.documentosNaoDevolvidos(user);
			List<ProtocoloEntrada> venceHoje = pe.documentosVenceHoje(user);
			List<ProtocoloEntrada> devolucaoVencida = naoDevolvidos.stream().filter(c-> hoje.compareTo(c.getPrazo())==1).collect(Collectors.toList());
			
			if (!naoRecebidos.isEmpty()
	                || !devolucaoVencida.isEmpty()) {
	            builder = new StringBuilder();
	            builder.append(htmlText.getCabecalho(user.getLogin()));
	            builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos,false));
	            builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
	            builder.append(htmlText.getRodape());
	            sendMail(user.getEmail(), "Pendencia - Protocolo de Entrada/Saida de Documentos", builder.toString(), null,null);
	        }
			else if(!naoDevolvidos.isEmpty()
                    && venceHoje.isEmpty()
                    && hoje.get(Calendar.DAY_OF_WEEK)==Calendar.MONDAY){
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getLogin()));
                builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
                builder.append(htmlText.getRodape());
	            sendMail(user.getEmail(), "Pendencia - Protocolo de Saída de Documentos", builder.toString(), null,null);
            }
            if (!venceHoje.isEmpty()) {
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getNome()));
                builder.append(htmlText.processarTabelaVenceHoje(venceHoje,user));
                builder.append(htmlText.getRodape());
                sendMail(user.getEmail(), "Documento(s) de cliente(s) devem ser devolvidos hoje", builder.toString(), null, null);
            }
		}
		
		if (hoje.get(Calendar.DAY_OF_WEEK) == dayOfWeek) {
            List<ProtocoloEntrada> listaNaoDevolvidos = pe.documentosNaoDevolvidos(null);
            List<ProtocoloEntrada> naoRecebidos = pe.documentosNaoRecebidos(null);
            
            StringBuilder builder = new StringBuilder();
            builder.append(htmlText.getCabecalho(""));
            builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos,true));
            builder.append(htmlText.processarTabelaTodosVencidos(listaNaoDevolvidos));
            builder.append(htmlText.getRodape());
            //montar Planilha
            List<ProtocoloEntrada> lista = new ArrayList<>();
            lista.addAll(naoRecebidos);
            lista.addAll(listaNaoDevolvidos);
            File file = pe.montarDadosPlanilha(lista);
            if(file.exists()) sendMail(contasSuperior, "Relação de Documentos Retidos", builder.toString(), file, "Historico de documentos.xls");
        }
        */
	}
	
	void sendMail(String para, String assunto, String texto,File anexo,String nomeAnexo){
		if(para.trim().length()==0) return;
		try {
			MimeMessage mail = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(mail, anexo!=null);
			helper.setTo(para.replace(" ","").split(";"));
			helper.setSubject(assunto);
			helper.setText(texto,true);
			helper.setFrom("alertas@prolinkcontabil.com.br","Mensageria - Prolink Contabil");
			if(anexo!=null)
				helper.addAttachment(nomeAnexo, anexo);
			mailSender.send(mail);
		}catch(MessagingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
