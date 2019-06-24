package com.prolink.processos.repository;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.Usuario;	

@Repository
public interface ProtocolosEntradas extends JpaRepository<ProtocoloEntrada, Long>{
	@Query(value = "select p from ProtocoloEntrada as p " +
			"INNER JOIN Usuario as u on u.id=p.quemRecebeu.id " +
			"where p.quemRecebeu=:user and p.devolvido=false and p.devolver=true and u.ativo=1")
	public List<ProtocoloEntrada> documentosNaoDevolvidos(Usuario user);
	//@Query(value = "select p from ProtocoloEntrada as p " +
	//		"INNER JOIN Usuario as u on u.id=p.para_quem_id " +
	//		"where p.paraQuem=:user and p.recebido=false and p.quemRecebeu is null and u.ativo=1")
	@Query(value = "select p from ProtocoloEntrada as p ")
	public List<ProtocoloEntrada> documentosNaoRecebidos(Usuario user);
	//@Query(value = "select p from ProtocoloEntrada as p " +
	//		"INNER JOIN Usuario as u on u.id=p.recebido_id " +
	//		"where p.quemRecebeu=:user and p.devolvido=false and p.devolver=true and u.ativo=1 and p.prazo=:date")
	@Query(value = "select p from ProtocoloEntrada as p ")
	public List<ProtocoloEntrada> documentosVenceHoje(Usuario usuario, Calendar date);
}
