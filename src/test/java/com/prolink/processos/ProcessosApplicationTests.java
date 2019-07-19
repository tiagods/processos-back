package com.prolink.processos;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.repository.Departamentos;
import com.prolink.processos.repository.ImplantacaoProcessosEtapas;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	@Autowired
	private Departamentos departamentos;

	@Autowired
	private ImplantacaoProcessosEtapas etapas;

	@Test
	public void contextLoads() {
		List<ImplantacaoProcessoEtapa> listaTodos = etapas.listarEtapas();

		Map<Departamento,List<ImplantacaoProcessoEtapa>> listaOrdenada = listaTodos
				.stream()
				.collect(Collectors.groupingBy(c-> c.getEtapa().getDepartamento()));


		//listar pendencias por departamento
		System.out.println("Qtde Registros: "+listaOrdenada.size());
		listaOrdenada.entrySet().forEach(c->System.out.println("Dep: "+ c.getKey().getNome()+" -> "+c.getValue().size()));

		//listar vence hoje
		Map<Departamento,List<ImplantacaoProcessoEtapa>> venceHoje = listaTodos
				.stream()
				.filter(f->f.getVencido().equals(ImplantacaoProcessoEtapa.Vencido.VENCE_HOJE))
				.collect(Collectors.groupingBy(c->c.getEtapa().getDepartamento()));

		System.out.println("Qtde Registros Vence Hoje: "+venceHoje.size());
		venceHoje.entrySet()
				.forEach(c->System.out.println("Dep: "+ c.getKey().getNome()+" -> "+c.getValue()
						.stream()
						.map(n->n.getId().toString())
						.collect(Collectors.joining(","))));

		//dep.forEach(c->listarPendentesPorDepartamento(c));
		Assert.assertTrue(departamentos.findAll().size()>0);
	}
	public void listarVenceHoje(){

	}
	public void listarPendentesPorDepartamento(Departamento departamento){
		List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas();
		lista.forEach(c->System.out.printf("Id: %d ; Etapa: %s; Status: %s; Departamento: %s \n",c.getId(),c.getEtapa().getEtapa(),c.getStatus(),c.getEtapa().getDepartamento()));
	}
}
