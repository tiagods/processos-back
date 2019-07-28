package com.prolink.processos.scheduler;

import com.prolink.processos.model.Usuario;
import com.prolink.processos.model.protocolo.ProtocoloEntrada;
import com.prolink.processos.repository.Usuarios;
import com.prolink.processos.services.NotificadorEmail;
import com.prolink.processos.services.ProtocolosServices;
import com.prolink.processos.utils.HTMLTextProtocoloEntradaService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

@Component
@PropertySource("classpath:protocolo.properties")
public class ProtocoloJob {
    private Logger logger = LoggerFactory.getLogger(getClass());

    private static final String TIME_ZONE = "America/Sao_Paulo";

    @Autowired
    private Usuarios usuarios;

    @Autowired
    private ProtocolosServices pe;

    @Autowired
    private HTMLTextProtocoloEntradaService htmlText;

    @Value("${protocolos.email}")
    private String contasSuperior;

    @Autowired
    private NotificadorEmail sender;

    @Scheduled(cron="${notificacao.protocolo.job}", zone = TIME_ZONE)
    public void emailFuncionarios() {
        logger.info("Iniciando...->"+getClass().getSimpleName()+"->..."+ LocalDateTime.now());
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
                builder.append(htmlText.getCabecalho(user.getLogin()));
                builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos,false));
                builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
                builder.append(htmlText.getRodape());
                logger.info("Enviando email para...->"+user.getLogin()+"->"+user.getEmail());
                sender.sendMail(user.getEmail(), "Pendencia - Protocolo de Entrada/Saida de Documentos", builder.toString(), null,null);
            }
            else if(!naoDevolvidos.isEmpty()
                    && venceHoje.isEmpty()
                    && hoje.get(Calendar.DAY_OF_WEEK)==Calendar.MONDAY){
                builder.append(htmlText.getCabecalho(user.getLogin()));
                builder.append(htmlText.processarTabelaNaoDevolvidos(naoDevolvidos,!devolucaoVencida.isEmpty(),false,user));
                builder.append(htmlText.getRodape());
                logger.info("Enviando email para...->"+user.getLogin()+"->"+user.getEmail());
                sender.sendMail(user.getEmail(), "Pendencia - Protocolo de Saída de Documentos", builder.toString(), null,null);
            }
            if (!venceHoje.isEmpty()) {
                builder = new StringBuilder();
                builder.append(htmlText.getCabecalho(user.getNome()));
                builder.append(htmlText.processarTabelaVenceHoje(venceHoje,user));
                builder.append(htmlText.getRodape());
                logger.info("Enviando email para...->"+user.getLogin()+"->"+user.getEmail());
                sender.sendMail(user.getEmail(), "Documento(s) de cliente(s) devem ser devolvidos hoje", builder.toString(), null, null);
            }
        }
        logger.info("Concluindo...->"+getClass().getSimpleName()+"->..."+LocalDateTime.now());
    }
    @Scheduled(cron="${notificacao.protocolo.gestor}",zone = TIME_ZONE)
    public void emailDiretorAndGerente() {
        logger.info("Iniciando -> Diretor and Gerente...->" + getClass().getSimpleName() + "->..." + LocalDateTime.now());
        List<ProtocoloEntrada> listaNaoDevolvidos = pe.documentosNaoDevolvidos(null);
        List<ProtocoloEntrada> naoRecebidos = pe.documentosNaoRecebidos(null);
        StringBuilder builder = new StringBuilder();
        builder.append(htmlText.getCabecalho(""));
        builder.append(htmlText.processarTabelaNaoRecebidos(naoRecebidos, true));
        builder.append(htmlText.processarTabelaTodosVencidos(listaNaoDevolvidos));
        builder.append(htmlText.getRodape());
        //montar Planilha
        List<ProtocoloEntrada> lista = new ArrayList<>();
        lista.addAll(naoRecebidos);
        lista.addAll(listaNaoDevolvidos);
        File file = pe.montarDadosPlanilha(lista);
        if (file.exists())
            sender.sendMail(contasSuperior, "Relação de Documentos Retidos",
                    builder.toString(), file, "Historico de documentos.xls");
        logger.info("Concluindo -> Diretor and Gerente...->" + getClass().getSimpleName() + "->..." + LocalDateTime.now());
    }
}