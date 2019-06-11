package com.prolink.processos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.prolink.processos.model.Usuario;

@Repository
public interface Usuarios extends JpaRepository<Usuario, Long>{
	
	@Query(value = "select distinct(u.*) from usuario as u 
		inner join protocolo_entrada as e 
		on e.para_id=u.id or e.recebido_id=u.id
		where e.recebido=false and u.ativo=1 or e.devolver=true 
		and e.devolvido=false u.ativo=1
		order by u.nome", 
	       nativeQuery = true)
    	public List<Usuario> listarUsuariosProtocolosPendentes();
}
