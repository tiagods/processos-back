package com.prolink.processos;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Iterator;
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
import com.prolink.processos.model.ProtocoloItem;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.Usuarios;
import com.prolink.processos.services.ExcelGenerico;
import com.prolink.processos.services.HTMLText;
import com.prolink.processos.services.ProtocolosServices;

import jxl.write.WriteException;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	@Autowired
	private Usuarios usuarios;
	
	@Autowired
	private ProtocolosServices pe;
	
	@Autowired
	private HTMLText htmlText;
	
	@Autowired
	private JavaMailSender mailSender;
	
	//private int dayOfWeek = Calendar.FRIDAY;
	private int dayOfWeek = Calendar.TUESDAY;
	
	@Value(value="protocolos.email")
	private String[] contasSuperior;
	
	@Test
	public void contextLoads() {
		List<Usuario> users = usuarios.listarUsuariosProtocolosPendentes();
		Calendar hoje = Calendar.getInstance();
		/*
		for(Usuario user : users) {
			StringBuilder builder = new StringBuilder();
			List<ProtocoloEntrada> naoRecebidos = pe.documentosNaoRecebidos(user);
			List<ProtocoloEntrada> naoDevolvidos = pe.documentosNaoDevolvidos(user);
			List<ProtocoloEntrada> venceHoje = pe.documentosVenceHoje(user);
			List<ProtocoloEntrada> devolucaoVencida = naoDevolvidos.stream().filter(c-> hoje.compareTo(c.getPrazo())==1).collect(Collectors.toList());
			
			if (!naoRecebidos.isEmpty()
	                || !devolucaoVencida.isEmpty()) {
	            builder = new StringBuilder();
	            builder.append(htmlText.getCabecalho(user.getNome()));
	            builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos));
	            builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
	            builder.append(htmlText.getRodape());
	            sendMail(new String[] {user.getEmail()}, "Pendencia - Protocolo de Entrada/Saida de Documentos", builder.toString(), null,null);
	        }
			else if(!naoDevolvidos.isEmpty()
                    && venceHoje.isEmpty()
                    && hoje.get(Calendar.DAY_OF_WEEK)==Calendar.MONDAY){
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getNome()));
                builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
                builder.append(htmlText.getRodape());
	            sendMail(new String[] {user.getEmail()}, "Pendencia - Protocolo de Saída de Documentos", builder.toString(), null,null);
            }
            if (!venceHoje.isEmpty()) {
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getNome()));
                builder.append(htmlText.processarTabelaVenceHoje(venceHoje,user));
                builder.append(htmlText.getRodape());
                sendMail(new String[] {user.getEmail()}, "Documento(s) de cliente(s) devem ser devolvidos hoje", builder.toString(), null, null);
            }
		}
		*/
		if (hoje.get(Calendar.DAY_OF_WEEK) == dayOfWeek) {
            List<ProtocoloEntrada> listaNaoDevolvidos = pe.documentosNaoDevolvidos(null);
            List<ProtocoloEntrada> naoRecebidos = pe.documentosNaoRecebidos(null);
            
            StringBuilder builder = new StringBuilder();
            builder.append(htmlText.getCabecalho("Dr. Ricardo"));
            builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos));
            builder.append(htmlText.processarTabelaTodosVencidos(listaNaoDevolvidos));
            builder.append(htmlText.getRodape());
            //montar Planilha
            List<ProtocoloEntrada> lista = new ArrayList<>();
            lista.addAll(naoRecebidos);
            lista.addAll(listaNaoDevolvidos);
            File file = montarDadosPlanilha(lista);
            if(file.exists())
                sendMail(contasSuperior, "Relação de Documentos Retidos", builder.toString(), file, "Historico de documentos.xls");
        }
	}
	private File montarDadosPlanilha(List<ProtocoloEntrada> lista){
        ArrayList<ArrayList<String>> listaImpressao = new ArrayList<>();
        Integer[] colunasLenght = new Integer[]{20,20,20,20,11,11,9,20,20,20,20};
        String[] cabecalho = new String[]{
            "Protocolo de Entrada", "Data de Entrada","Data de Recebimento", "Data de Devolução", "Para","Recebido Por", "Cliente",
            "Cliente Nome", "Tipo", "Quantidade", "Descrição"};
        listaImpressao.add(new ArrayList<>());
        listaImpressao.get(0).addAll(Arrays.asList(cabecalho));
         
        Iterator<ProtocoloEntrada> iterator =  lista.iterator();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        while(iterator.hasNext()){
            String[] strings = new String[11];
            ProtocoloEntrada  mr = iterator.next();
            mr = pe.buscar(mr);
            strings[0] = mr.getId()+"";
            strings[1] = mr.getDataEntrada()==null?"":sdf.format(mr.getDataEntrada().getTime());
            strings[2] = mr.getDataRecebimento()==null?"":sdf.format(mr.getDataRecebimento().getTime());
            strings[3] = mr.getPrazo()==null?"":sdf.format(mr.getPrazo().getTime());
            strings[4] = mr.getParaQuem()==null?"":mr.getParaQuem().getNome();
            strings[5] = mr.getQuemRecebeu()==null?"":mr.getQuemRecebeu().getNome();
            strings[6] = ""+mr.getCliente().getId();
            strings[7] = mr.getCliente().getNome();
            StringBuilder builderTipo = new StringBuilder();
            StringBuilder builderQuant = new StringBuilder();
            StringBuilder builderDetalhes = new StringBuilder();
            Iterator<ProtocoloItem> items = mr.getItems().iterator();
            int i = 1;
            while(items.hasNext()){
                String split = mr.getItems().size()>i?";":"";
                ProtocoloItem item = items.next();
                builderTipo.append(item.getNome()).append(split);
                builderQuant.append(item.getQuantidade()).append(split);
                builderDetalhes.append(item.getDetalhes()).append(split);
                i++;
            }
            strings[8] = builderTipo.toString();
            strings[9] = builderQuant.toString();
            strings[10] = builderDetalhes.toString();
            listaImpressao.add(new ArrayList<String>(Arrays.asList(strings)));
        }
        LocalDateTime localDate = LocalDateTime.now();
        File file = new File(
                System.getProperty("java.io.tmpdir")+"\\document"+
                        localDate.format(DateTimeFormatter.ofPattern("ddMMyyyyHHmmss"))+".xls");
        ExcelGenerico excel = new ExcelGenerico(file.getAbsolutePath(), listaImpressao, colunasLenght);
        try {
            excel.gerarExcel();
        } catch (NullPointerException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        } catch (WriteException ex) {
            ex.printStackTrace();
        }
        return file;
    }
	void sendMail(String[] para, String assunto, String texto,File anexo,String nomeAnexo){
		try {
			MimeMessage mail = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(mail, anexo!=null);
			helper.setTo("webmaster@prolinkcontabil.com.br");
			helper.setSubject(assunto);
			helper.setText(texto,true);
			helper.setFrom("alerta@prolinkcontabil.com.br","Mensageria - Prolink Contabil");
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
