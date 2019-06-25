package com.prolink.processos.repository;

import java.util.Calendar;
import java.util.List;
import java.util.Optional;

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
	@Query(value = "select p from ProtocoloEntrada as p " +
			"INNER JOIN Usuario as u on u.id=p.paraQuem.id " +
			"where p.paraQuem=:user and p.recebido=false and p.quemRecebeu is null and u.ativo=1")
	public List<ProtocoloEntrada> documentosNaoRecebidos(Usuario user);
	@Query(value = "select p from ProtocoloEntrada as p where p.paraQuem=:user and p.prazo=:date")
	public List<ProtocoloEntrada> documentosVenceHoje(Usuario user, Calendar date);
	
	@Query(value = "select p from ProtocoloEntrada as p " +
			"INNER JOIN Usuario as u on u.id=p.quemRecebeu.id " +
			"where p.devolvido=false and p.devolver=true and u.ativo=1")
	public List<ProtocoloEntrada> documentosNaoDevolvidos();
	@Query(value = "select p from ProtocoloEntrada as p " +
			"INNER JOIN Usuario as u on u.id=p.paraQuem.id " +
			"where p.recebido=false and p.quemRecebeu is null and u.ativo=1")
	public List<ProtocoloEntrada> documentosNaoRecebidos();
	@Query(value = "select p from ProtocoloEntrada as p "+
			"INNER JOIN Usuario as u on u.id=p.quemRecebeu.id " +
			"where p.prazo<:date and u.ativo=1")
	public List<ProtocoloEntrada> documentosVencidos(Calendar date);
	
	@Override
	@Query(value="select p from ProtocoloEntrada as p LEFT JOIN FETCH p.items where p.id=:id")
	public Optional<ProtocoloEntrada> findById(Long id);
}
