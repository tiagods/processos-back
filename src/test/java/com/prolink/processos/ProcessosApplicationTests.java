package com.prolink.processos;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.Usuarios;
import com.prolink.processos.services.ProtocolosServices;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	@Autowired
	private Usuarios usuarios;
	
	@Autowired
	private ProtocolosServices pe;
	
	@Test
	public void contextLoads() {
		List<Usuario> users = usuarios.listarUsuariosProtocolosPendentes();
		System.out.println("Documentos nao devolvidos");
		users.forEach(c->System.out.println(c.getId()+"-"+c.getNome()));
		for(Usuario u :users)
			pe.documentosNaoRecebidos(u).forEach(c->System.out.println(c.getId()+" = "+c.getParaQuem()));
		//System.out.println("Documentos nao recebidos");
		
		//or(Usuario u :users)
		//	pe.documentosNaoRecebidos(u).forEach(c->System.out.println(c.getId()+" = "+c.getParaQuem()));
	}
}
