package com.prolink.processos.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonInclude;

@Entity
@Table(name="franquia_pacote")
public class FranquiaPacote implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long id;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String nome;
	private BigDecimal investimento = new BigDecimal(0.00);
	private BigDecimal custo = new BigDecimal(0.00);
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String previsao;
	private BigDecimal faturamento = new BigDecimal(0.00);
	private double icms = 0.00;
	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
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
	/**
	 * @return the investimento
	 */
	public BigDecimal getInvestimento() {
		return investimento;
	}
	/**
	 * @param investimento the investimento to set
	 */
	public void setInvestimento(BigDecimal investimento) {
		this.investimento = investimento;
	}
	/**
	 * @return the custo
	 */
	public BigDecimal getCusto() {
		return custo;
	}
	/**
	 * @param custo the custo to set
	 */
	public void setCusto(BigDecimal custo) {
		this.custo = custo;
	}
	/**
	 * @return the previsao
	 */
	public String getPrevisao() {
		return previsao;
	}
	/**
	 * @param previsao the previsao to set
	 */
	public void setPrevisao(String previsao) {
		this.previsao = previsao;
	}
	/**
	 * @return the faturamento
	 */
	public BigDecimal getFaturamento() {
		return faturamento;
	}
	/**
	 * @param faturamento the faturamento to set
	 */
	public void setFaturamento(BigDecimal faturamento) {
		this.faturamento = faturamento;
	}
	/**
	 * @return the icms
	 */
	public double getIcms() {
		return icms;
	}
	/**
	 * @param icms the icms to set
	 */
	public void setIcms(double icms) {
		this.icms = icms;
	}
	
}
