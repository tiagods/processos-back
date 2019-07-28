package com.prolink.processos;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapaStatus;
import com.prolink.processos.repository.Departamentos;
import com.prolink.processos.repository.ImplantacaoProcessosEtapas;
import com.prolink.processos.services.NotificadorEmail;
import com.prolink.processos.utils.HTMLEntities;
import com.prolink.processos.utils.HTMLTextProcessoImplantacao;
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
	private ImplantacaoProcessosEtapas etapas;

	@Autowired
	private HTMLTextProcessoImplantacao implantacao;

	@Autowired
	private NotificadorEmail sender;

	@Autowired
	private HTMLEntities entities;


	@Test
	public void contextLoads() {
		List<ImplantacaoProcessoEtapa> listaTodos = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO);
		notificarUsuariosVencidos();

		Assert.assertTrue(listaTodos.size()>0);

	}
	//notificar uma vez por semana, mesmo não vencidos
	//@Schedules(value = "* * 8 ? * MON")
	public void notificarUsuarios(){
		List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO);
		List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
				"Ol&aacute;;",
				"Voc&ecirc; foi designado a finalizar tarefas pendentes de implanta&ccedil;&atilde;o",
				"As etapas abaixo dever&atilde;o ser encerradas no Controles de Processos, na guia Processos.",
				"Fique atento aos prazos:"
		);
		Map<Departamento, List<ImplantacaoProcessoEtapa>> departamentoList = groupListByDepartamento(lista);
		departamentoList.entrySet().forEach(c->{
			iniciarEnvio(c.getKey().getEmail(),"Relatorio Semanal - Implantacao - Etapas Em Aberto",c.getValue(),cabecalho,true);
		});
	}

	//@Schedules(value = "* * 8 ? * TUE,THU")
	public void notificarUsuariosVencidos(){
		List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapasVencidas();
		List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
				"Ol&aacute;;",
				"Voc&ecirc; foi designado a finalizar tarefas pendentes de implanta&ccedil;&atilde;o",
				"As etapas abaixo estão vencidas e dever&atilde;o ser encerradas no Controles de Processos, na guia Processos."
		);

		Map<Departamento, List<ImplantacaoProcessoEtapa>> departamentoList = groupListByDepartamento(lista);
		departamentoList.entrySet().forEach(c->{
			iniciarEnvio(c.getKey().getEmail(),"Relatorio de Implantacao - Etapas Vencidas",c.getValue(),cabecalho,true);
		});
	}

	//@Schedules(value = "* * 8 ? * MON-FRI")
	public void notificarVenceHoje(){
		List<ImplantacaoProcessoEtapa> lista = etapas.listarVenceHoje();
		List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
				"Ol&aacute;;",
				"Existem Etapas na implanta&ccedil;&atilde;o que vence hoje, fique atento aos prazos",
				"As etapas abaixo dever&atilde;o ser encerradas no Controles de Processos, na guia Processos."
		);
		Map<Departamento, List<ImplantacaoProcessoEtapa>> departamentoList = groupListByDepartamento(lista);
		departamentoList.entrySet().forEach(c->{
			iniciarEnvio(c.getKey().getEmail(),"Implantacao - Etapa(s) Vence(m) Hoje",c.getValue(),cabecalho,false);
		});
	}

	//@Schedules(value = "* * 8 ? * FRI")
	public void notificarControlador(){


		List<String> cabecalho = Arrays.asList("Sistema Controle de Processos/Implanta&ccedil;&atilde;o",
				"Ol&aacute;;",
				"Existem Etapas na implanta&ccedil;&atilde;o que vence hoje, fique atento aos prazos",
				"As etapas abaixo dever&atilde;o ser encerradas no Controles de Processos, na guia Processos."
		);


	}

	//@Schedules(value = "* * 8 ? * FRI")
	public void notificarGestao(){

	}











	private void notificacaoGeral(String[] destinatarios, List<String> cabecalho){
		List<ImplantacaoProcessoEtapa> lista = etapas.listarEtapas(ImplantacaoProcessoEtapa.Status.ABERTO);

		Comparator<ImplantacaoProcessoEtapa> comparator = Comparator.comparingLong(c->c.getProcesso().getId());
		Collections.sort(lista,comparator
				.thenComparing(c->c.getEtapa().getAtividade().getNome())
				.thenComparing(c->c.getEtapa().getEtapa()));

		iniciarEnvio("webmaster@prolinkcontabil.com.br","Relatorio de Implantacao - Todos os Departamentos",lista,cabecalho,false);

	}


	private void iniciarEnvio(String email, String assunto, List<ImplantacaoProcessoEtapa> lista,List<String> cabecalho,boolean fazerVerificacao){
		//nao ira enviar se vence hoje e total de vencidos ser igual ao tamanho da lista, outro metodo fará esse envio
		if(fazerVerificacao) {
			long total = lista.stream().filter(value -> value.getVencido() == ImplantacaoProcessoEtapa.Vencido.VENCE_HOJE).count();
			if (lista.size() == total) return;
		}
		Map<ImplantacaoProcessoEtapa,List<ImplantacaoProcessoEtapaStatus>> map = processarHistorico(lista);
		String mensagem = implantacao.montarMensagem(map,cabecalho,new ArrayList<>());
		sender.sendMail(email,assunto,mensagem,null,null);
	}

	private Map<Departamento, List<ImplantacaoProcessoEtapa>> groupListByDepartamento(List<ImplantacaoProcessoEtapa> lista) {
		return lista
				.stream()
				.collect(Collectors.groupingBy(c -> c.getEtapa().getDepartamento()));
	}
	public List<ImplantacaoProcessoEtapaStatus> organizarLista(List<ImplantacaoProcessoEtapa> list){
		//pegando sets dos objetos e reunindo em um unico list
		List<ImplantacaoProcessoEtapaStatus> result = list.stream()
				.map(ImplantacaoProcessoEtapa::getHistorico)
				.flatMap(c -> c.stream()).collect(Collectors.toList());
		Collections.sort(result, Comparator.comparing(ImplantacaoProcessoEtapaStatus::getCriadoEm));
		return result;
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

}
