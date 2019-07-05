package com.prolink.processos;

import com.prolink.processos.model.Departamento;
import com.prolink.processos.model.implantacao.ImplantacaoProcesso;
import com.prolink.processos.model.implantacao.ImplantacaoProcessoEtapa;
import com.prolink.processos.repository.ImplantacaoProcessosEtapas;
import com.prolink.processos.repository.ImplatancaoProcessos;
import com.prolink.processos.repository.Departamentos;
import com.prolink.processos.utils.HTMLTextProtocoloEntradaService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	@Autowired
	private Departamentos departamentos;

	@Autowired
	private ImplatancaoProcessos processos;

	@Autowired
	private ImplantacaoProcessosEtapas etapas;

	@Autowired
	private HTMLTextProtocoloEntradaService htmlText;
	
	@Autowired
	private JavaMailSender mailSender;

	@Test
	public void contextLoads() {
		//para comercial
		List<ImplantacaoProcesso> processoList = processos.processosAbertos();
		//imprimir(processoList);

		List<Departamento> dep = departamentos.findAll();
		//dep.forEach(System.out::println);

	}
	void imprimir(List<ImplantacaoProcesso> lista){
		StringBuilder builder = new StringBuilder();
		lista.forEach(c->{
			builder.append(c.getCliente().toString())
					.append("\n");
			Optional<ImplantacaoProcesso> result = processos.findById(c.getId());
			List<ImplantacaoProcessoEtapa> list = new ArrayList<>();
			list.addAll(result.get().getEtapas());
			Comparator<ImplantacaoProcessoEtapa> comparator = Comparator.comparing(o -> o.getEtapa().getAtividade().toString());
			Collections.sort(list,comparator.thenComparing(t->t.getEtapa().getEtapa()));
			list.forEach(f->
					builder.append(f.getStatus())
							.append("\t")
							.append(f.getEtapa().getEtapa())
							.append("\t")
							.append(f.getPrazo()==null?"":new SimpleDateFormat("dd/MM/yyyy").format(f.getPrazo().getTime()))
							.append("\t")
							.append(f.getEtapa().getDepartamento())
							.append("\t")
							.append(f.getEtapa().getAtividade())
							.append("\t")
							.append(f.getEtapa().getDescricao())
							.append("\n")

			);
			builder.append("\n");
		});
		try {
			FileWriter writer = new FileWriter(
					new File(System.getProperty("user.dir") + "/arquivo.csv"));
			writer.write(builder.toString());
			writer.flush();
			writer.close();
		}catch (IOException e){
			e.printStackTrace();
		}
	}

}
