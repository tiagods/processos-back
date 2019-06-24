package com.prolink.processos;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.ProtocoloItem;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.Usuarios;
import com.prolink.processos.services.HTMLText;
import com.prolink.processos.services.ProtocolosServices;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	@Autowired
	private Usuarios usuarios;
	
	@Autowired
	private ProtocolosServices pe;
	
	@Autowired
	private HTMLText htmlText;
	
	@Test
	public void contextLoads() {
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
	            builder.append(htmlText.getCabecalho(user.getNome()));
	            builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos));
	            builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
	            builder.append(htmlText.getRodape(true));
	            List<String> contas = new ArrayList<>();
	            contas.add(user.getEmail());
	            
	            invocarEnvioEmail(model, contas,"Pendencia - Protocolo de Entrada/Saida de Documentos", builder.toString(),null);
	            model.setMensagem("=Aguardando cronômetro para disparar o próximo aviso em " + time / 30 + " minutos!");
	        }
			else if(!naoDevolvidos.isEmpty()
                    && venceHoje.isEmpty()
                    && hoje.get(Calendar.DAY_OF_WEEK)==Calendar.MONDAY){
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getNome()));
                builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
                builder.append(htmlText.getRodape(true));
                List<String> contas = new ArrayList<>();
                contas.add(user.getEmail());
                
                invocarEnvioEmail(model, contas,"Pendencia - Protocolo de Saída de Documentos", builder.toString(),null);
                model.setMensagem("=Aguardando cronômetro para disparar o próximo aviso em " + time / 30 + " minutos!");    
            }
            if (!venceHoje.isEmpty()) {
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getNome()));
                builder.append(htmlText.processarTabelaVenceHoje(venceHoje,user));
                builder.append(htmlText.getRodape(true));
                List<String> conta = new ArrayList<>();
                conta.add(user.getEmail());
                
                invocarEnvioEmail(model, conta,"Documento(s) de cliente(s) devem ser devolvidos hoje", builder.toString(),null);
                model.setMensagem("=Aguardando cronômetro para disparar o próximo aviso em " + time / 30 + " minutos!");
            }
		}
		if (hoje.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
            List<ProtocoloEntrada> listaRelacao = dao.listaTodosNaoDevolvidos();

            StringBuilder builder = new StringBuilder();
            builder.append(htmlText.getCabecalho("Dr. Ricardo"));
            builder.append(htmlText.processarTabelaTodosVencidos(listaRelacao));
            builder.append(htmlText.getRodape(false));
            List<String> conta = new ArrayList<>();
            //conta.add("ricardo.moreira@prolinkcontabil.com.br");
            conta.add("tiago.dias@prolinkcontabil.com.br");
            //montar Planilha
            EmailAttachment atach = null;
            File file = montarDadosPlanilha(listaRelacao);
            if(file.exists()){
                atach = new EmailAttachment();
                atach.setPath(file.getAbsolutePath());
                atach.setDisposition(EmailAttachment.ATTACHMENT);
                atach.setDescription("Planilha de Documentos");
                atach.setName("Historico de documentos.xls");
            }
            invocarEnvioEmail(model, conta, "Relação de Documentos Retidos", builder.toString(),atach);
        }
	}
	private File montarDadosPlanilha(List<ProtocoloEntrada> lista){
        ArrayList<ArrayList<String>> listaImpressao = new ArrayList<>();
        Integer[] colunasLenght = new Integer[]{20,20,20,11,9,20,20,20,20};
        String[] cabecalho = new String[]{
            "Protocolo de Entrada", "Data de Entrada", "Data de Devolução", "Destino", "Cliente",
            "Cliente Nome", "Tipo", "Quantidade", "Descrição"};
        listaImpressao.add(new ArrayList<>());
        listaImpressao.get(0).addAll(Arrays.asList(cabecalho));
         
        Iterator<ProtocoloEntrada> iterator =  lista.iterator();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        while(iterator.hasNext()){
            String[] strings = new String[9];
            ProtocoloEntrada  mr = iterator.next();
            strings[0] = mr.getId()+"";
            strings[1] = mr.getDataRecebimento()==null?"":sdf.format(mr.getDataRecebimento().getTime());
            strings[2] = mr.getPrazo()==null?"":sdf.format(mr.getPrazo().getTime());
            strings[3] = mr.getQuemRecebeu()==null?"":mr.getQuemRecebeu().getNome();
            strings[4] = ""+mr.getCliente().getId();
            strings[5] = mr.getCliente().getNome();
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
            strings[6] = builderTipo.toString();
            strings[7] = builderQuant.toString();
            strings[8] = builderDetalhes.toString();
            listaImpressao.add(new ArrayList(Arrays.asList(strings)));
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
}
