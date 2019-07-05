package com.prolink.processos.repository;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoProcesso;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ImplantacaoProcessosEtapas extends JpaRepository<ImplantacaoProcessoEtapa,Long> {
    @Query("select count(p) from ImplantacaoProcessoEtapa as p " +
            "where p.processo=:processo and p.etapa.departamento=:departamento and p.status='ABERTO'")
    long contarAbertosPorDepartamento(ImplantacaoProcesso processo, Departamento departamento);

}
