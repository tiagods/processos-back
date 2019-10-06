package com.prolink.processos.repository;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoAtividade;
import com.prolink.processos.model.implantacao.ImplantacaoProcesso;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ImplantacaoProcessosEtapas extends JpaRepository<ImplantacaoProcessoEtapa,Long> {
    @Query("select p from ImplantacaoProcessoEtapa as p LEFT JOIN FETCH p.historico " +
            "where p.id=:id")
    Optional<ImplantacaoProcessoEtapa> findById(Long id);

    @Query("select count(p) from ImplantacaoProcessoEtapa as p " +
            "where p.processo=:processo and p.etapa.departamento=:departamento " +
            "and p.status='ABERTO' and p.processo.finalizado=false")
    long contarAbertosPorDepartamento(ImplantacaoProcesso processo, Departamento departamento);

    @Query("SELECT a FROM ImplantacaoProcessoEtapa AS a " +
            "WHERE a.processo.finalizado=FALSE AND a.status=:status")
    List<ImplantacaoProcessoEtapa> listarEtapas(ImplantacaoProcessoEtapa.Status status);

    @Query("SELECT a FROM ImplantacaoProcessoEtapa AS a " +
            "WHERE a.processo.finalizado=FALSE AND a.status='ABERTO' " +
            "and a.dataAtualizacao+a.etapa.tempo=date(NOW()) ")
    List<ImplantacaoProcessoEtapa> listarVenceHoje();

    @Query("SELECT a FROM ImplantacaoProcessoEtapa AS a " +
            "WHERE a.processo.finalizado=FALSE AND a.status='ABERTO' " +
            "and a.dataAtualizacao+a.etapa.tempo<date(now())")
    List<ImplantacaoProcessoEtapa> listarEtapasVencidas();


    @Query("select p from ImplantacaoProcessoEtapa as p LEFT JOIN FETCH p.historico " +
            "where p.processo=:processo and p.etapa.atividade=:atividade")
    List<ImplantacaoProcessoEtapa> listarEtapasDaAtividade(ImplantacaoProcesso processo, ImplantacaoAtividade atividade);
}
