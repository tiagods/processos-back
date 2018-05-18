package com.prolink.processos.model;

import java.io.Serializable;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

@Entity
public class Franquia implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long id;
	private String nome;
	@Transient
	private Set<FranquiaPacote> pacotes= new HashSet<>();
	@Temporal(TemporalType.TIMESTAMP)
	private Calendar lastUpdate;
	/**
	 * @return the id
	 */
	@PrePersist @PreUpdate
	private void atualizar() {
		lastUpdate = Calendar.getInstance();
	}
	
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
	 * @return the pacotes
	 */
	public Set<FranquiaPacote> getPacotes() {
		return pacotes;
	}
	/**
	 * @param pacotes the pacotes to set
	 */
	public void setPacotes(Set<FranquiaPacote> pacotes) {
		this.pacotes = pacotes;
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
	
	
}
