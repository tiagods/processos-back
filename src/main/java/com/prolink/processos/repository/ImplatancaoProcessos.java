package com.prolink.processos.repository;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.model.implantacao.ImplantacaoProcesso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ImplatancaoProcessos extends JpaRepository<ImplantacaoProcesso,Long> {
    /*
    //enviar a cada 3 dias
    @Query("select p from ImplantacaoProcesso")
    public List<ImplantacaoProcesso> processosAbertos(Departamento departamento);
    //enviar toda segunda feira
    @Query("select p from ImplantacaoProcesso")
    public List<ImplantacaoProcesso> processosVencidos();
    //enviar todo dia
    @Query("select p from ImplantacaoProcesso")
    public List<ImplantacaoProcesso> processosVencidos(Usuario usuario);
    */
    //processos em aberto
    @Query(value = "select distinct(p.*) from imp_processo as p " +
            "inner join imp_pro_etapa as i " +
            "on p.id=i.processo_id " +
            "where i.status='ABERTO' and p.finalizado=false",nativeQuery = true)
    public List<ImplantacaoProcesso> processosAbertos();

    @Override
    @Query(value="select p from ImplantacaoProcesso as p LEFT JOIN FETCH p.etapas where p.id=:id")
    Optional<ImplantacaoProcesso> findById(@Param("id") Long id);
}
