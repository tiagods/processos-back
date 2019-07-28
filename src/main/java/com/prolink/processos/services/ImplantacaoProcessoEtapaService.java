package com.prolink.processos.services;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoAtividade;
import com.prolink.processos.model.implantacao.ImplantacaoProcesso;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapaStatus;
import com.prolink.processos.repository.ImplantacaoProcessosEtapas;
import com.prolink.processos.utils.HTMLTextProcessoImplantacao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ImplantacaoProcessoEtapaService {


    @Autowired
    private ImplantacaoProcessosEtapas etapas;

    public List<ImplantacaoProcessoEtapa> listarEtapasVencidas() {
        return etapas.listarEtapasVencidas();
    }

    public List<ImplantacaoProcessoEtapa> listarEtapas(ImplantacaoProcessoEtapa.Status status) {
        return etapas.listarEtapas(status);
    }

    public List<ImplantacaoProcessoEtapa> listarVenceHoje() {
        return etapas.listarVenceHoje();
    }

    public List<ImplantacaoProcessoEtapa> listarEtapasDaAtividade(ImplantacaoProcesso processo, ImplantacaoAtividade atividade) {
        return etapas.listarEtapasDaAtividade(processo,atividade);
    }
}
