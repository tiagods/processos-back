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

@RunWith(SpringRunner.class)
@SpringBootTest
public class ProcessosApplicationTests {

	//@Test
	public void contextLoads() {
	}
}
