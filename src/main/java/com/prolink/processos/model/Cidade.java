package com.prolink.processos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Cidade implements Serializable{
	public enum Estado {
		AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT,
		PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO;
	}
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="CID_COD")
	private Long id;
	@Column(name="CID_NOME")
	private String nome;
	@Column(name="CID_ESTADO")
	@Enumerated(EnumType.STRING)
	private Estado estado;
	@Column(name="CID_COD_EXTRA")
	private String idExtra;
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
	 * @return the estado
	 */
	public Estado  getEstado() {
		return estado;
	}
	/**
	 * @param estado the estado to set
	 */
	public void setEstado(Estado estado) {
		this.estado = estado;
	}
	/**
	 * @return the idExtra
	 */
	public String getIdExtra() {
		return idExtra;
	}
	/**
	 * @param idExtra the idExtra to set
	 */
	public void setIdExtra(String idExtra) {
		this.idExtra = idExtra;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Cidade other = (Cidade) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return this.nome;
	}
}
