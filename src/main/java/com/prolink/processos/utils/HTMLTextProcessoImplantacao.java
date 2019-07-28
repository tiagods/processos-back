package com.prolink.processos.utils;

import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapaStatus;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class HTMLTextProcessoImplantacao extends AlertaModel{

    private String cabecalhoFundoColor = "35, 14, 153";
    private String linhasTabelaFundoColor= "255, 255, 255";

    private String linhasTabelaFonteColorIdVencido= "255, 0, 0";
    private String linhasTabelaFonteColorIdNoPrazo= "35, 14, 153";
    private String linhasTabelaFonteColor= "0, 0 ,0";

    private SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    public String montarMensagem(Map<ImplantacaoProcessoEtapa, List<ImplantacaoProcessoEtapaStatus>> map, List<String> msgCabecalho, List<String> msgRodape) {
        StringBuilder builder = new StringBuilder();

        builder.append(cabecalho(msgCabecalho));

        builder.append("<div style=\"text-align: center;\">")
                .append("   <table align=\"left\" border=\"2\" cellpadding=\"2\" cellspacing=\"0\" style=\"width: 100%\">")
                .append("       <thead>")
                .append("           <tr>")

                .append("           <th scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Prazo</span></th>")

                .append("           <th scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Status</span></th>")

                .append("           <th colspan=\"2\" scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Cliente</span></th>")

                .append("           <th scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Departamento</span></th>")

                .append("           <th scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Etapa</span></th>")

                .append("           <th scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Atividade</span></th>")

                .append("           <th scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">O que fazer? (Sua tarefa)</span></th>")

                .append("           <th colspan=\"3\" scope=\"row\" style=\"background-color: rgb(").append(cabecalhoFundoColor).append(");\">")
                .append("               <span style=\"color:#ffffff;\">Historico das atividades anteriores</span></th>")
                .append("	        </tr>")
                .append("       </thead>")

                ///linhas da tabela
                .append("   <tbody>");

        for (Map.Entry<ImplantacaoProcessoEtapa, List<ImplantacaoProcessoEtapaStatus>> pe : map.entrySet()){
            ImplantacaoProcessoEtapa etapa = pe.getKey();
            List<ImplantacaoProcessoEtapaStatus> status = pe.getValue();

            Calendar prazo = etapa.getDataAtualizacao();
            if(prazo==null) prazo = Calendar.getInstance();
            prazo.add(Calendar.DAY_OF_MONTH, etapa.getEtapa().getTempo());

            ImplantacaoProcessoEtapa.Vencido vencido = etapa.getVencido();

            String corData = (vencido == ImplantacaoProcessoEtapa.Vencido.VENCIDO || vencido == ImplantacaoProcessoEtapa.Vencido.VENCE_HOJE) ? linhasTabelaFonteColorIdVencido : linhasTabelaFonteColorIdNoPrazo;

            builder.append("	    <tr>")
                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(corData).append("); font-size: 14px;\">")
                    .append(sdf.format(prazo.getTime())).append("</span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 14px;\">")
                    .append(etapa.getStatus())
                    .append("               </span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 12px;\">")
                    .append(etapa.getProcesso().getCliente().getIdFormatado())
                    .append("               </span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 12px;\">")
                    .append(etapa.getProcesso().getCliente().getNomeFormatado())
                    .append("               </span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 14px;\">")
                    .append(etapa.getEtapa().getDepartamento().getNome())
                    .append("               </span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 14px;\">")
                    .append(etapa.getEtapa().getEtapa())
                    .append("               </span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 14px;\">")
                    .append(etapa.getEtapa().getAtividade().getNome())
                    .append("               </span></th>")

                    .append("	        <th scope=\"row\" style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">")
                    .append("	            <span style=\"color:rgb(").append(linhasTabelaFonteColor).append("); font-size: 14px;\">")
                    .append(etapa.getEtapa().getDescricao())
                    .append("               </span></th>");
            builder.append("	        <th style=\"background-color: rgb(").append(linhasTabelaFundoColor).append("); \">");
            status.forEach(c -> {
                builder.append("       <p><span style=\"color:").append(linhasTabelaFonteColor).append(";font-size:12;\">").append(c.getCriadoEm() == null ? "" : sdf.format(c.getCriadoEm().getTime())).append("</span><p>");
            });
            builder.append("       </th>");

            builder.append("       <th style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">");
            status.forEach(c -> {
                builder.append("       <p><span style=\"color:").append(linhasTabelaFonteColor).append(";font-size:12px;\">").append(c.getCriadoPor().getLogin()).append("</span><p>");
            });
            builder.append("       </th>");

            builder.append("	        <th style=\"background-color: rgb(").append(linhasTabelaFundoColor).append(");\">");
            status.forEach(c -> {
                builder.append("       <p><span style=\"color:").append(linhasTabelaFonteColor).append(";font-size:12px;\">").append(c.getDescricao()).append("</span><p>");
            });
            builder.append("       </th>");

            builder.append("	</tr>");
        }

        builder.append("	</tbody>")
                .append("</table>")
                //fim da tabela
                .append("</div>");

        builder.append(rodape(msgRodape));
        return builder.toString();
    }
    public List<ImplantacaoProcessoEtapaStatus> organizarLista(List<ImplantacaoProcessoEtapa> list){
        //pegando sets dos objetos e reunindo em um unico list
        List<ImplantacaoProcessoEtapaStatus> result = list.stream()
                .map(ImplantacaoProcessoEtapa::getHistorico)
                .flatMap(c -> c.stream()).collect(Collectors.toList());

        Collections.sort(result, Comparator.comparing(ImplantacaoProcessoEtapaStatus::getCriadoEm));
        return result;
    }
}
