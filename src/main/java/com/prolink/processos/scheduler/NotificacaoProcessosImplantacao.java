package com.prolink.processos.scheduler;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapaStatus;
import com.prolink.processos.services.ImplantacaoProcessoEtapaService;
import com.prolink.processos.services.NotificadorEmail;
import com.prolink.processos.utils.HTMLEntities;
import com.prolink.processos.utils.HTMLTextProcessoImplantacao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@Component
@PropertySource("classpath:implantacao.properties")
public class NotificacaoProcessosImplantacao {

    private Logger logger = LoggerFactory.getLogger(getClass());

    private static final String TIME_ZONE = "America/Sao_Paulo";
    @Autowired
    private HTMLEntities entities;

    @Autowired
    private ImplantacaoProcessoEtapaService etapas;

    @Autowired
    private NotificadorEmail sender;

    @Autowired
    private HTMLTextProcessoImplantacao implantacao;

    @Value("${processos.gestao.email}")
    private String contaGestao;

    @Value("${processos.controlador.email}")
    private String contaControlador;

    //notificar uma vez por semana, mesmo não vencidos
    @Scheduled(cron = "${notificacao.processos.usuarios}",zone = TIME_ZONE)
    public void notificarUsuarios(){
        List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO);
        List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
                "Ol&aacute;;",
                "Voc&ecirc; foi designado a finalizar tarefas pendentes de implanta&ccedil;&atilde;o",
                "As etapas abaixo dever&atilde;o ser encerradas no Controles de Processos, na guia Processos.",
                "Fique atento aos prazos:"
        );
        Map<Departamento, List<ImplantacaoProcessoEtapa>> departamentoList = groupListByDepartamento(lista);
        departamentoList.entrySet().forEach(c->{
            iniciarEnvio(c.getKey().getEmail(),"Relatorio Semanal - Implantacao - Etapas Em Aberto",c.getValue(),cabecalho,true,true);
        });
    }

    @Scheduled(cron = "${notificacao.processos.vencidos}",zone = TIME_ZONE)
    public void notificarUsuariosVencidos(){
        List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapasVencidas();
        List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
                "Ol&aacute;;",
                "Voc&ecirc; foi designado a finalizar tarefas pendentes de implanta&ccedil;&atilde;o",
                "As etapas abaixo estão vencidas e dever&atilde;o ser encerradas no Controles de Processos, na guia Processos."
        );

        Map<Departamento, List<ImplantacaoProcessoEtapa>> departamentoList = groupListByDepartamento(lista);
        departamentoList.entrySet().forEach(c->{
            iniciarEnvio(c.getKey().getEmail(),"Relatorio de Implantacao - Etapas Vencidas",c.getValue(),cabecalho,true,true);
        });
    }

    @Scheduled(cron = "${notificacao.processos.vencehoje}",zone = TIME_ZONE)
    public void notificarVenceHoje(){
        List<ImplantacaoProcessoEtapa> lista = etapas.listarVenceHoje();
        List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
                "Ol&aacute;;",
                "Existem Etapas na implanta&ccedil;&atilde;o que vence hoje, fique atento aos prazos",
                "As etapas abaixo dever&atilde;o ser encerradas no Controles de Processos, na guia Processos."
        );
        Map<Departamento, List<ImplantacaoProcessoEtapa>> departamentoList = groupListByDepartamento(lista);
        departamentoList.entrySet().forEach(c->{
            iniciarEnvio(c.getKey().getEmail(),"Implantacao - Etapa(s) Vence(m) Hoje",c.getValue(),cabecalho,false,true);
        });
    }

    @Scheduled(cron = "${notificacao.processos.controlador}",zone = TIME_ZONE)
    public void notificarControlador(){
        List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO);
        notificacaoGeral(contaControlador,lista,true);
    }

    @Scheduled(cron= "${notificacao.processos.gestao}",zone = TIME_ZONE)
    public void notificarGestao(){
        List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapasVencidas();
        notificacaoGeral(contaGestao,lista,true);
    }

    private void notificacaoGeral(String destinatarios,
                                  List<ImplantacaoProcessoEtapa> lista, boolean exibirHistoricoAnterior){
        List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
                "Ol&aacute;;",
                "Segue relatorio das Etapas de Implanta&ccedil;&atilde;o",
                "A rela&ccedil;&atilde;o abaixo trata-se de todos os departamentos com pendencias em aberto."
        );
        iniciarEnvio(destinatarios,"Relatorio de Implantacao - Todos os Departamentos",lista,cabecalho,false,exibirHistoricoAnterior);
    }

    private void iniciarEnvio(
            String email, String assunto, List<ImplantacaoProcessoEtapa> lista,
            List<String> cabecalho, boolean fazerVerificacao,boolean exibirHistoricoAnterior){
        //nao ira enviar se vence hoje e total de vencidos ser igual ao tamanho da lista, outro metodo fará esse envio
        if(lista.isEmpty()) return;
        if(fazerVerificacao) {
            long total = lista.stream().filter(value -> value.getVencido() == ImplantacaoProcessoEtapa.Vencido.VENCE_HOJE).count();
            if (lista.size() == total) return;
        }
        Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> map = processarHistorico(lista,exibirHistoricoAnterior);
        String mensagem = implantacao.montarMensagem(map,cabecalho,new ArrayList<>());
        sender.sendMail(email,"Implantacao \\ Prolink Contabil",assunto,mensagem,null,null);
    }

    private Map<Departamento, List<ImplantacaoProcessoEtapa>> groupListByDepartamento(List<ImplantacaoProcessoEtapa> lista) {
        return lista
                .stream()
                .collect(Collectors.groupingBy(c -> c.getEtapa().getDepartamento()));
    }

    private List<ImplantacaoProcessoEtapaStatus> organizarLista(List<ImplantacaoProcessoEtapa> list){
        //pegando sets dos objetos e reunindo em um unico list
        return list.stream()
                .map(ImplantacaoProcessoEtapa::getHistorico)
                .flatMap(c -> c.stream()).collect(Collectors.toSet())
                .stream()
                .sorted(Comparator.comparing(ImplantacaoProcessoEtapaStatus::getCriadoEm)).collect(Collectors.toList());
    }

    private Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> processarHistorico(
            List<ImplantacaoProcessoEtapa> lista, boolean exibirHistoricoAnterior){

        Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> map = new LinkedHashMap<>();
        Comparator<ImplantacaoProcessoEtapa> comparator = Comparator.comparingLong(c->c.getProcesso().getCliente().getId());
        Collections.sort(lista,comparator
                .thenComparing(c->c.getEtapa().getAtividade().getNome())
                .thenComparing(c->c.getEtapa().getEtapa().getValor()));
        lista.forEach(v->{
            //fazendo um filtro para pegar status de todas as etapas anteriores
            List<ImplantacaoProcessoEtapa> newList= new ArrayList<>();
            if(exibirHistoricoAnterior)
                newList = etapas.listarEtapasDaAtividade(v.getProcesso(),v.getEtapa().getAtividade());
            else {
                ImplantacaoProcessoEtapa processoEtapa = etapas.buscar(v.getId());
                newList.add(processoEtapa);
            }
            List<ImplantacaoProcessoEtapaStatus> result = organizarLista(newList);
            map.put(v,result);
        });
        return map;
    }
}
