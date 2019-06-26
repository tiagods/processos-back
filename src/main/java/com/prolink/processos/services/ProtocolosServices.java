package com.prolink.processos.services;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

import jxl.write.WriteException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prolink.processos.model.ProtocoloEntrada;
import com.prolink.processos.model.ProtocoloItem;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.ProtocolosEntradas;
import com.prolink.processos.services.exceptions.ProtocoloEntradaNaoEncontradoException;

@Service
public class ProtocolosServices {

	@Autowired
	private ProtocolosEntradas entradas;
	
	public ProtocoloEntrada buscar(ProtocoloEntrada pe) {
		Optional<ProtocoloEntrada> result = entradas.findById(pe.getId());
		if(result.isPresent()) return result.get();
		else throw new ProtocoloEntradaNaoEncontradoException("Registro não encontrado");
	}
	
	public List<ProtocoloEntrada> documentosNaoDevolvidos(Usuario usuario){
		if(usuario!=null)
			return entradas.documentosNaoDevolvidos(usuario);
		else return entradas.documentosNaoDevolvidos(); 
	}
	public List<ProtocoloEntrada> documentosNaoRecebidos(Usuario usuario){
		if(usuario!=null)
			return entradas.documentosNaoRecebidos(usuario);
		else return entradas.documentosNaoRecebidos();
	}
	public List<ProtocoloEntrada> documentosVenceHoje(Usuario usuario){
		return entradas.documentosVenceHoje(usuario, Calendar.getInstance());
	}
	public File montarDadosPlanilha(List<ProtocoloEntrada> lista){
        ArrayList<ArrayList<String>> listaImpressao = new ArrayList<>();
        Integer[] colunasLenght = new Integer[]{10,20,20,20,11,11,9,20,20,20,20};
        String[] cabecalho = new String[]{
            "Cod", "Entrada","Recebido Em", "Data Devolução", "Para","Recebido Por", "Cliente",
            "Cliente Nome", "Tipo", "Quantidade", "Descrição"};
        listaImpressao.add(new ArrayList<>());
        listaImpressao.get(0).addAll(Arrays.asList(cabecalho));
         
        Iterator<ProtocoloEntrada> iterator =  lista.iterator();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        while(iterator.hasNext()){
            String[] strings = new String[11];
            ProtocoloEntrada  mr = iterator.next();
            mr = buscar(mr);
            strings[0] = mr.getId()+"";
            strings[1] = mr.getDataEntrada()==null?"":sdf.format(mr.getDataEntrada().getTime());
            strings[2] = mr.getDataRecebimento()==null?"":sdf.format(mr.getDataRecebimento().getTime());
            strings[3] = mr.getPrazo()==null?"":sdf.format(mr.getPrazo().getTime());
            strings[4] = mr.getParaQuem()==null?"":mr.getParaQuem().getLogin();
            strings[5] = mr.getQuemRecebeu()==null?"":mr.getQuemRecebeu().getLogin();
            strings[6] = ""+mr.getCliente().getId();
            strings[7] = mr.getCliente().getNome();
            StringBuilder builderTipo = new StringBuilder();
            StringBuilder builderQuant = new StringBuilder();
            StringBuilder builderDetalhes = new StringBuilder();
            Iterator<ProtocoloItem> items = mr.getItems().iterator();
            int i = 1;
            while(items.hasNext()){
                String split = mr.getItems().size()>i?";":"";
                ProtocoloItem item = items.next();
                builderTipo.append(item.getNome()).append(split);
                builderQuant.append(item.getQuantidade()).append(split);
                builderDetalhes.append(item.getDetalhes()).append(split);
                i++;
            }
            strings[8] = builderTipo.toString();
            strings[9] = builderQuant.toString();
            strings[10] = builderDetalhes.toString();
            listaImpressao.add(new ArrayList<String>(Arrays.asList(strings)));
        }
        LocalDateTime localDate = LocalDateTime.now();
        File file = new File(
                System.getProperty("java.io.tmpdir")+"\\document"+
                        localDate.format(DateTimeFormatter.ofPattern("ddMMyyyyHHmmss"))+".xls");
        ExcelGenerico excel = new ExcelGenerico(file.getAbsolutePath(), listaImpressao, colunasLenght);
        try {
            excel.gerarExcel();
        } catch (NullPointerException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        } catch (WriteException ex) {
            ex.printStackTrace();
        }
        return file;
    }
	
}
