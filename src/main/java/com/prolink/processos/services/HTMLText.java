package com.prolink.processos.services;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.ProtocoloItem;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.utils.HTMLEntities;

@Service
public class HTMLText extends HTMLEntities {

	@Autowired
	private ProtocolosServices protocolos;
	
	private SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	 
    //texto html para o cabeçalho do e-mail
    public String getCabecalho(String usuario) {
        StringBuilder builder = new StringBuilder();
        Calendar calendar = Calendar.getInstance();
        String inicio;
        int hour = calendar.get(Calendar.HOUR_OF_DAY);
        if(hour>=0 && hour<12){
            inicio = "Bom dia ";
        }
        else if(hour>=12 && hour<18){
            inicio = "Boa tarde ";
        }
        else
            inicio = "Boa noite ";
        //.append("             <span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">Ol&aacute; ")
        builder.append("<!DOCTYPE html>")
                .append("<html>")
                .append("   <head>")
                .append("       <title></title>")
                .append("   </head>")
                .append("   <body>")
                .append("       <div class=\"rcmBody\" id=\"cke_pastebin\" style=\"margin: 22px  10px  10px;\">")
                .append("           <div style=\"text-align: left;\">")
                .append("               <span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">")
                .append(inicio)
                .append(htmlentities(usuario))
                .append(";</span></span></div>");
        return builder.toString();
    }
 
    //rodape do email html
    public String getRodape() {
        StringBuilder builder = new StringBuilder();
        builder.append("<div style=\"text-align: left;\">")
                .append("               <span style=\"color: #d3d3d3;\"><span style=\"font-family: comic sans ms,cursive;\">***Esse aviso &eacute; gerado automaticamente, n&atilde;o &eacute; necess&aacute;rio que responda***</span></span></div>")
                .append("           <div style=\"text-align: left;\">")
                .append("               &nbsp;</div>")
                .append("           <div style=\"text-align: left;\">")
                .append("               <span style=\"color: #d3d3d3;\"><span style=\"font-family: comic sans ms,cursive;\"><img alt=\"\" src=\"http://prolinkvip.prolinkcontabil.com.br/uploadimages/prolinkvip.prolinkcontabil.com.br/assinatura_email_prolink%281%29.gif\" style=\"width: 365px; height: 123px; float: left;\" /></span></span></div>")
                .append("       </div>")
                .append("       <p>")
                .append("           &nbsp;</p>")
                .append("   </body>")
                .append("</html>");
        return builder.toString();
    }
 
    //processar documentos que foram recebidos mas não deram confirmação
    public String processarTabelaNaoRecebidos(List<ProtocoloEntrada> lista,boolean gestor) {
        StringBuilder builder = new StringBuilder();
        if (!lista.isEmpty()) {
            builder.append("<div style=\"text-align: left;\">")
                    .append("               &nbsp;</div>")
                    .append("           <div style=\"text-align: left;\">");
                    if(gestor) {
                        builder.append("               <span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">Existe(m) documento(s) dos colaboradores a ser(em) baixado(s).</span></span></div>")
                        .append("           <div style=\"text-align: left;\">")
	                    .append("               &nbsp;</div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               <span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">Abaixo uma visão geral.</span></span></div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               &nbsp;</div>");
                    }
                    else {
                    	builder.append("               <span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">Voc&ecirc; ainda tem documentos aguardando serem baixados.</span></span></div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               &nbsp;</div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               <span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">Agora &eacute; necess&aacute;rio que voc&ecirc; informe se os documentos devem ou n&atilde;o serem devolvidos atrav&eacute;s do protocolo de entrada.</span></span></div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               &nbsp;</div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               &nbsp;</div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               <span style=\"font-family: &quot;comic sans ms&quot;, cursive; font-size: 18px; text-align: left;\">Preciso que valide o recebimento pelo sistema Controle de Processos,</span></div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               <font face=\"comic sans ms, cursive\"><span style=\"font-size: 18px;\">se notar algo errado, use a op&ccedil;&atilde;o Contestar ou encaminhe para outra pessoa.</span></font></div>")
	                    .append("           <div style=\"text-align: left;\">")
	                    .append("               &nbsp;</div>");
        			}
                    builder.append("           <div style=\"text-align: center;\">")
                    .append("               <table align=\"left\" border=\"2\" cellpadding=\"2\" cellspacing=\"0\" style=\"width: 100%;\">")
                    .append("                   <thead>")
                    .append("                       <tr>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <font color=\"#a52a2a\" face=\"comic sans ms, cursive\">Protocolo de &nbsp;Entrada</font></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Data de Entrada</span></span></th>")
                    .append("                           <th colspan=\"2\" style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Refer&ecirc;ncia</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Tipo</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Qtde</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Descri&ccedil;&atilde;o</span></span></th>")
                    .append("                       </tr>")
                    .append("                   </thead>");
 
            Iterator<ProtocoloEntrada> iterator = lista.iterator();
            while (iterator.hasNext()) {
            	ProtocoloEntrada rel = iterator.next();
            	rel = protocolos.buscar(rel);
                builder.append("<tbody>")
                        .append("                       <tr>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(rel.getId())
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(rel.getDataEntrada()==null?"":sdf.format(rel.getDataEntrada().getTime()))
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\">")
                        .append(rel.getCliente().getId())
                        .append("                               </font></span></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 20%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\">")
                        .append(htmlentities(rel.getCliente().getNome()))
                        .append("                               </span></span></span></th>");
 
                StringBuilder builderTipo = new StringBuilder();
                StringBuilder builderQuant = new StringBuilder();
                StringBuilder builderDetalhes = new StringBuilder();
 
                Set<ProtocoloItem> items = rel.getItems();
                for (ProtocoloItem i : items) {
                    builderTipo.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(htmlentities(i.getNome()))
                            .append("                               </span></strong></span></span></p>");
                    builderQuant.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(i.getQuantidade())
                            .append("                               </span></strong></span></span></p>");
                    builderDetalhes.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(htmlentities(i.getDetalhes()))
                            .append("                               </span></strong></span></span></p>");
                }
                builder.append("                            <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append(builderTipo.toString())
                        .append("                           </th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append(builderQuant.toString())
                        .append("                           </th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 40%;\">")
                        .append(builderDetalhes.toString())
                        .append("                           </th>");
                builder.append("                        </tr>")
                        .append("                   </tbody>");
            }
            builder.append("                </table>")
                    .append("           </div>");
        }
        return builder.toString();
    }
 
    //processar documentos que foram recebidos mas não foram devolvidos
    public String processarTabelaNaoDevolvidos(List<ProtocoloEntrada> lista, boolean contemDevolucaoVencida, boolean documentoVenceHoje,
            Usuario usuario) {
        StringBuilder builder = new StringBuilder();
        if (!lista.isEmpty()) {
            builder.append("<div style=\"text-align: left;\">")
                    .append("               &nbsp;</div>");
 
            if (documentoVenceHoje) {
                builder.append("    <p><span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">")
                        .append(htmlentities("Você tem documento(s) que deveria(m) serem devolvidos hoje."))
                        .append("</span></span></p>");
            } else if (contemDevolucaoVencida) {
                builder.append("    <p><span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">Voc&ecirc; recebeu algum(ns) documentos lan&ccedil;ados pela recep&ccedil;&atilde;o mas ainda n&atilde;o realizou a devolu&ccedil;&atilde;o atrav&eacute;s do sistema Controle de Processos.</span></span></p>");
            } else {
                builder.append("    <p><span style=\"font-size: 18px;\"><span style=\"font-family: &quot;comic sans ms&quot;, cursive;\">")
                        .append(htmlentities("Segue relação de documentos com devolução agendada por você, acesse o Controle de Processos para Protocolar Entrega, adie se for necessário"))
                        .append("</span></span></p>");
            }
            builder.append("            <div>")
                    .append("               &nbsp;</div>")
                    .append("           <div style=\"text-align: center;\">")
                    .append("               <table align=\"left\" border=\"2\" cellpadding=\"2\" cellspacing=\"0\" style=\"width: 100%;\">")
                    .append("                   <thead>")
                    .append("                       <tr>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <font color=\"#a52a2a\" face=\"comic sans ms, cursive\">Protocolo de &nbsp;Entrada</font></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Data de Entrada</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Data devolu&ccedil;&atilde;o</span></span></th>")
                    .append("                           <th colspan=\"2\" style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Refer&ecirc;ncia</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Tipo</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Qtde</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Descri&ccedil;&atilde;o</span></span></th>")
                    .append("                       </tr>")
                    .append("                   </thead>");
 
            Iterator<ProtocoloEntrada> iterator = lista.iterator();
            while (iterator.hasNext()) {
            	ProtocoloEntrada rel = iterator.next();
            	rel = protocolos.buscar(rel);
                Calendar hoje = Calendar.getInstance();
                Calendar dataVencimento = Calendar.getInstance();
                dataVencimento.setTime(rel.getPrazo().getTime());
                String cor = hoje.after(dataVencimento) ? "#ff0000" : "#ff8c00";
                builder.append("<tbody>")
                        .append("                       <tr>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(rel.getId())
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(sdf.format(rel.getDataRecebimento().getTime()))
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: ")
                        .append(cor)
                        .append(";\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(sdf.format(rel.getPrazo().getTime()))
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\">")
                        .append(rel.getCliente().getId())
                        .append("                               </font></span></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 20%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\">")
                        .append(htmlentities(rel.getCliente().getNome()))
                        .append("                               </span></span></span></th>");
 
                StringBuilder builderTipo = new StringBuilder();
                StringBuilder builderQuant = new StringBuilder();
                StringBuilder builderDetalhes = new StringBuilder();
 
                Set<ProtocoloItem> items = rel.getItems();
                for (ProtocoloItem i : items) {
                    builderTipo.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(htmlentities(i.getNome()))
                            .append("                               </span></strong></span></span></p>");
                    builderQuant.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(i.getQuantidade())
                            .append("                               </span></strong></span></span></p>");
                    builderDetalhes.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(htmlentities(i.getDetalhes()))
                            .append("                               </span></strong></span></span></p>");
                }
                builder.append("                            <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append(builderTipo.toString())
                        .append("                           </th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append(builderQuant.toString())
                        .append("                           </th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 40%;\">")
                        .append(builderDetalhes.toString())
                        .append("                           </th>");
                builder.append("                        </tr>")
                        .append("                   </tbody>");
            }
            builder.append("                </table>")
                    .append("           </div>")
                    .append("           <div style=\"text-align: left;\">")
                    .append("               &nbsp;</div>");
        }
        return builder.toString();
    }
 
    public String processarTabelaVenceHoje(List<ProtocoloEntrada> lista, Usuario user) {
        return processarTabelaNaoDevolvidos(lista, true, true, user);
    }
 
    public String processarTabelaTodosVencidos(List<ProtocoloEntrada> lista) {
        StringBuilder builder = new StringBuilder();
         
        if (!lista.isEmpty()) {
            builder.append("<div style=\"text-align: left;\">")
                    .append("               &nbsp;</div>")
                    .append("<div style=\"text-align: left;\">")
                    .append("   <font face=\"comic sans ms, cursive\"><span style=\"font-size: 18px;\">Segue comparativo de documentos Prolink Entrada VS Sa&iacute;da,</span></font></div>")
                    .append("<div style=\"text-align: left;\">")
                    .append("   <font face=\"comic sans ms, cursive\"><span style=\"font-size: 18px;\">abaixo &eacute; possivel verificar por quanto tempo os documentos estar&atilde;o retidos</span></font></div>")
                    .append("           <div>")
                    .append("               &nbsp;</div>")
                    .append("           <div style=\"text-align: center;\">")
                    .append("               <table align=\"left\" border=\"2\" cellpadding=\"2\" cellspacing=\"0\" style=\"width: 100%;\">")
                    .append("                   <thead>")
                    .append("                       <tr>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <font color=\"#a52a2a\" face=\"comic sans ms, cursive\">Protocolo de &nbsp;Entrada</font></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Data de Entrada</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Data devolu&ccedil;&atilde;o</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Destino</span></span></th>")
                    .append("                           <th colspan=\"2\" style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Refer&ecirc;ncia</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Tipo</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Qtde</span></span></th>")
                    .append("                           <th style=\"background-color: rgb(255, 204, 153); width: 10%;\">")
                    .append("                               <span style=\"color: #a52a2a;\"><span style=\"font-family: comic sans ms,cursive;\">Descri&ccedil;&atilde;o</span></span></th>")
                    .append("                       </tr>")
                    .append("                   </thead>");
 
            Iterator<ProtocoloEntrada> iterator = lista.iterator();
            while (iterator.hasNext()) {
            	ProtocoloEntrada rel = iterator.next();
            	rel = protocolos.buscar(rel);
                Calendar hoje = Calendar.getInstance();
                Calendar dataVencimento = Calendar.getInstance();
                dataVencimento.setTime(rel.getPrazo().getTime());
                String cor = hoje.after(dataVencimento) ? "#ff0000" : "#ff8c00";
                builder.append("<tbody>")
                        .append("                       <tr>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(rel.getId())
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(sdf.format(rel.getDataRecebimento().getTime()))
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"color: ")
                        .append(cor)
                        .append(";\"><font face=\"comic sans ms, cursive\"><span style=\"font-size: 14px;\">")
                        .append(sdf.format(rel.getPrazo().getTime()))
                        .append("                               </span></font></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\">")
                        .append(rel.getQuemRecebeu())
                        .append("                               </font></span></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><font face=\"comic sans ms, cursive\">")
                        .append(rel.getCliente().getId())
                        .append("                               </font></span></span></th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 20%;\">")
                        .append("                               <span style=\"font-size: 14px;\"><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\">")
                        .append(htmlentities(rel.getCliente().getNome()))
                        .append("                               </span></span></span></th>");
 
                StringBuilder builderTipo = new StringBuilder();
                StringBuilder builderQuant = new StringBuilder();
                StringBuilder builderDetalhes = new StringBuilder();
 
                Set<ProtocoloItem> items = rel.getItems();
                for (ProtocoloItem i : items) {
                    builderTipo.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(htmlentities(i.getNome()))
                            .append("                               </span></strong></span></span></p>");
                    builderQuant.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(i.getQuantidade())
                            .append("                               </span></strong></span></span></p>");
                    builderDetalhes.append("<p><span style=\"color: #ff8c00;\"><span style=\"font-family: comic sans ms,cursive;\"><strong><span style=\"font-size: 14px;\">")
                            .append(htmlentities(i.getDetalhes()))
                            .append("                               </span></strong></span></span></p>");
                }
                builder.append("                            <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append(builderTipo.toString())
                        .append("                           </th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 10%;\">")
                        .append(builderQuant.toString())
                        .append("                           </th>")
                        .append("                           <th style=\"background-color: rgb(255, 255, 204); width: 40%;\">")
                        .append(builderDetalhes.toString())
                        .append("                           </th>");
                builder.append("                        </tr>")
                        .append("                   </tbody>");
            }
            builder.append("                </table>")
                    .append("           </div>")
                    .append("           <div style=\"text-align: left;\">")
                    .append("               &nbsp;</div>");
            }
        return builder.toString();
    }
}
