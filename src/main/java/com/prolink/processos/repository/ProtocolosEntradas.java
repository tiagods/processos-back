package com.prolink.processos.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.Usuario;	

@Repository
public interface ProtocolosEntradas extends JpaRepository<ProtocoloEntrada, Long>{
	@Query("select p from ProtocoloEntrada as p where p.quemRecebeu=:user INNER JOIN Usuario as u on u.id=p.recebido_id and p.devolvido=false and p.devolver=true and u.ativo=1")
	public List<ProtocoloEntrada> documentosNaoDevolvidos(Usuario user);
	@Query("select p from ProtocoloEntrada as p where p.paraQuem=:user INNER JOIN Usuario as u on u.id=p.para_quem.id and p.recebido=false and p.quemRecebeu is null and u.ativo=1")
	public List<ProtocoloEntrada> documentosNaoRecebidos(Usuario usuario);
//	public List<ProtocoloEntrada> documentosVenceHoje(Usuario usuario);
}
