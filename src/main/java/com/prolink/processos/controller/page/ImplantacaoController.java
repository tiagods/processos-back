package com.prolink.processos.controller.page;

import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapaStatus;
import com.prolink.processos.services.ImplantacaoProcessoEtapaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value = "/implantacao")
public class ImplantacaoController {
    @Autowired
    private ImplantacaoProcessoEtapaService etapas;

    @RequestMapping
    ModelAndView view(){
        List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO).subList(0, 1);
        List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
                "Ol&aacute;;",
                "Segue relatorio das Etapas de Implanta&ccedil;&atilde;",
                "A rela&ccedil;&atilde;o abaixo trata-se de todos os departamentos com pendencias em aberto."
        );
        Comparator<ImplantacaoProcessoEtapa> comparator = Comparator.comparingLong(c -> c.getProcesso().getId());
        Collections.sort(lista, comparator
                .thenComparing(c -> c.getEtapa().getAtividade().getNome())
                .thenComparing(c -> c.getEtapa().getEtapa()));
        Map<ImplantacaoProcessoEtapa, List<ImplantacaoProcessoEtapaStatus>> map = processarHistorico(lista);

        ModelAndView mv = new ModelAndView("html/processos");
        mv.addObject("mensagens",cabecalho);
        mv.addObject("name","Tiago");
        mv.addObject("map",map);
        return mv;
    }

    private Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> processarHistorico(List<ImplantacaoProcessoEtapa> lista){
        Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> map = new HashMap<>();
        lista.forEach(v->{
            //fazendo um filtro para pegar status de todas as etapas anteriores
            List<ImplantacaoProcessoEtapa> newList= etapas.listarEtapasDaAtividade(v.getProcesso(),v.getEtapa().getAtividade());
            List<ImplantacaoProcessoEtapaStatus> result = organizarLista(newList);

            map.put(v,result);
        });
        return map;
    }
    private List<ImplantacaoProcessoEtapaStatus> organizarLista(List<ImplantacaoProcessoEtapa> list){
        //pegando sets dos objetos e reunindo em um unico list
        Set<ImplantacaoProcessoEtapaStatus> result = list.stream()
                .map(ImplantacaoProcessoEtapa::getHistorico)
                .flatMap(c -> c.stream()).collect(Collectors.toSet());
        List<ImplantacaoProcessoEtapaStatus> lista=new ArrayList<>();
        lista.addAll(result);
        Collections.sort(lista, Comparator.comparing(ImplantacaoProcessoEtapaStatus::getCriadoEm));
        return lista;
    }
}
