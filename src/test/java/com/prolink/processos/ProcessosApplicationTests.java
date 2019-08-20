package com.prolink.processos;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapaStatus;
import com.prolink.processos.repository.Departamentos;
import com.prolink.processos.repository.ImplantacaoProcessosEtapas;
import com.prolink.processos.services.ImplantacaoProcessoEtapaService;
import com.prolink.processos.services.NotificadorEmail;
import com.prolink.processos.utils.HTMLEntities;
import com.prolink.processos.utils.HTMLTextProcessoImplantacao;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
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
	private ImplantacaoProcessoEtapaService etapas;
	@Autowired
	private HTMLTextProcessoImplantacao implantacao;

	@Test
	public void contextLoads() {
		List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO).subList(0,1);
		List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
				"Ol&aacute;;",
				"Segue relatorio das Etapas de Implanta&ccedil;&atilde;",
				"A rela&ccedil;&atilde;o abaixo trata-se de todos os departamentos com pendencias em aberto."
		);
		Comparator<ImplantacaoProcessoEtapa> comparator = Comparator.comparingLong(c->c.getProcesso().getId());
		Collections.sort(lista,comparator
				.thenComparing(c->c.getEtapa().getAtividade().getNome())
				.thenComparing(c->c.getEtapa().getEtapa()));
		Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> map = processarHistorico(lista);
		String mensagem = implantacao.montarMensagem(map,cabecalho,new ArrayList<>());

		System.out.println(mensagem);
		Assert.assertTrue(lista.isEmpty());
	}

	private Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> processarHistorico(List<ImplantacaoProcessoEtapa> lista){
		Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> map = new HashMap<>();
		lista.forEach(v->{
			//fazendo um filtro para pegar status de todas as etapas anteriores
			List<ImplantacaoProcessoEtapa> newList= etapas.listarEtapasDaAtividade(v.getProcesso(),v.getEtapa().getAtividade());
			List<ImplantacaoProcessoEtapaStatus> result = organizarLista(newList);

			map.put(v,result);
		});
		return map;
	}
	private List<ImplantacaoProcessoEtapaStatus> organizarLista(List<ImplantacaoProcessoEtapa> list){
		//pegando sets dos objetos e reunindo em um unico list
		Set<ImplantacaoProcessoEtapaStatus> result = list.stream()
				.map(ImplantacaoProcessoEtapa::getHistorico)
				.flatMap(c -> c.stream()).collect(Collectors.toSet());
		List<ImplantacaoProcessoEtapaStatus> lista=new ArrayList<>();
		lista.addAll(result);
		Collections.sort(lista, Comparator.comparing(ImplantacaoProcessoEtapaStatus::getCriadoEm));
		return lista;
	}


}
