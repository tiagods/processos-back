package com.prolink.processos.repository.filter;

import java.util.Calendar;

import com.prolink.processos.model.Contato.ContatoTipo;
import com.prolink.processos.model.Contato.PessoaTipo;
import com.prolink.processos.model.NegocioCategoria;
import com.prolink.processos.model.NegocioLista;
import com.prolink.processos.model.NegocioMalaDireta;
import com.prolink.processos.model.NegocioNivel;
import com.prolink.processos.model.NegocioOrigem;
import com.prolink.processos.model.NegocioServico;
import com.prolink.processos.model.Usuario;

public class ContatoFilter {
	private PessoaTipo pessoaTipo;
	private ContatoTipo contatoTipo;
	private NegocioLista lista;
	private NegocioCategoria categoria;
	private NegocioMalaDireta malaDireta;
	private NegocioNivel nivel;
	private NegocioOrigem origem;
	private NegocioServico servico;
	private Usuario atendente;
	private Calendar dataInicial;
	private Calendar dataFinal;
	private String nome;
	/**
	 * @return the pessoaTipo
	 */
	public PessoaTipo getPessoaTipo() {
		return pessoaTipo;
	}
	/**
	 * @param pessoaTipo the pessoaTipo to set
	 */
	public void setPessoaTipo(PessoaTipo pessoaTipo) {
		this.pessoaTipo = pessoaTipo;
	}
	/**
	 * @return the contatoTipo
	 */
	public ContatoTipo getContatoTipo() {
		return contatoTipo;
	}
	/**
	 * @param contatoTipo the contatoTipo to set
	 */
	public void setContatoTipo(ContatoTipo contatoTipo) {
		this.contatoTipo = contatoTipo;
	}
	/**
	 * @return the lista
	 */
	public NegocioLista getLista() {
		return lista;
	}
	/**
	 * @param lista the lista to set
	 */
	public void setLista(NegocioLista lista) {
		this.lista = lista;
	}
	/**
	 * @return the categoria
	 */
	public NegocioCategoria getCategoria() {
		return categoria;
	}
	/**
	 * @param categoria the categoria to set
	 */
	public void setCategoria(NegocioCategoria categoria) {
		this.categoria = categoria;
	}
	/**
	 * @return the malaDireta
	 */
	public NegocioMalaDireta getMalaDireta() {
		return malaDireta;
	}
	/**
	 * @param malaDireta the malaDireta to set
	 */
	public void setMalaDireta(NegocioMalaDireta malaDireta) {
		this.malaDireta = malaDireta;
	}
	/**
	 * @return the nivel
	 */
	public NegocioNivel getNivel() {
		return nivel;
	}
	/**
	 * @param nivel the nivel to set
	 */
	public void setNivel(NegocioNivel nivel) {
		this.nivel = nivel;
	}
	/**
	 * @return the origem
	 */
	public NegocioOrigem getOrigem() {
		return origem;
	}
	/**
	 * @param origem the origem to set
	 */
	public void setOrigem(NegocioOrigem origem) {
		this.origem = origem;
	}
	/**
	 * @return the servico
	 */
	public NegocioServico getServico() {
		return servico;
	}
	/**
	 * @param servico the servico to set
	 */
	public void setServico(NegocioServico servico) {
		this.servico = servico;
	}
	/**
	 * @return the atendente
	 */
	public Usuario getAtendente() {
		return atendente;
	}
	/**
	 * @param atendente the atendente to set
	 */
	public void setAtendente(Usuario atendente) {
		this.atendente = atendente;
	}
	/**
	 * @return the dataInicial
	 */
	public Calendar getDataInicial() {
		return dataInicial;
	}
	/**
	 * @param dataInicial the dataInicial to set
	 */
	public void setDataInicial(Calendar dataInicial) {
		this.dataInicial = dataInicial;
	}
	/**
	 * @return the dataFinal
	 */
	public Calendar getDataFinal() {
		return dataFinal;
	}
	/**
	 * @param dataFinal the dataFinal to set
	 */
	public void setDataFinal(Calendar dataFinal) {
		this.dataFinal = dataFinal;
	}
	/**
	 * @return the nome
	 */
	public String getNome() {
		return nome;
	}
	/**
	 * @param nome the nome to set
	 */
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	
}
