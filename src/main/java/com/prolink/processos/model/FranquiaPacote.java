package com.prolink.processos.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Calendar;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
	private BigDecimal custo = new BigDecimal(0.00);
	private BigDecimal investimento = new BigDecimal(0.00);
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String previsao;
	private BigDecimal faturamento = new BigDecimal(0.00);
	private double icms = 0.00;
	private BigDecimal proLabore = new BigDecimal(0.00);
	private BigDecimal baseIcms = new BigDecimal(0.00);
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Temporal(TemporalType.TIMESTAMP)
	private Calendar lastUpdate;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="criado_em")
	private Calendar criadoEm;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="franquia_id")
	@JsonIgnore
	private Franquia franquia;
	
	@PrePersist
	private void prePersist() {
		this.criadoEm = Calendar.getInstance();
		this.lastUpdate=this.criadoEm;
	}
	@PreUpdate
	private void preUpdate() {
		this.lastUpdate = Calendar.getInstance();
	}
	
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

	/**
	 * @return the lastUpdate
	 */
	public Calendar getLastUpdate() {
		return lastUpdate;
	}

	/**
	 * @param lastUpdate the lastUpdate to set
	 */
	public void setLastUpdate(Calendar lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	/**
	 * @return the proLabore
	 */
	public BigDecimal getProLabore() {
		return proLabore;
	}
	/**
	 * @param proLabore the proLabore to set
	 */
	public void setProLabore(BigDecimal proLabore) {
		this.proLabore = proLabore;
	}
	/**
	 * @return the baseIcms
	 */
	public BigDecimal getBaseIcms() {
		return baseIcms;
	}
	/**
	 * @param baseIcms the baseIcms to set
	 */
	public void setBaseIcms(BigDecimal baseIcms) {
		this.baseIcms = baseIcms;
	}
	/**
	 * @return the criadoEm
	 */
	public Calendar getCriadoEm() {
		return criadoEm;
	}
	/**
	 * @param criadoEm the criadoEm to set
	 */
	public void setCriadoEm(Calendar criadoEm) {
		this.criadoEm = criadoEm;
	}
	/**
	 * @return the franquia
	 */
	public Franquia getFranquia() {
		return franquia;
	}
	/**
	 * @param franquia the franquia to set
	 */
	public void setFranquia(Franquia franquia) {
		this.franquia = franquia;
	}
	
}
