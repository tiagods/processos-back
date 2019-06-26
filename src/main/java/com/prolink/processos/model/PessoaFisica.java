package com.prolink.processos.model;

import java.io.Serializable;
import java.util.Calendar;

import javax.persistence.Embeddable;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonInclude;


@Embeddable
public class PessoaFisica implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String rg;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String cpf;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String aniversario;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Temporal(TemporalType.DATE)
	private Calendar niver;
	/**
	 * @return the rg
	 */
	public String getRg() {
		return rg;
	}
	/**
	 * @param rg the rg to set
	 */
	public void setRg(String rg) {
		this.rg = rg;
	}
	/**
	 * @return the cpf
	 */
	public String getCpf() {
		return cpf;
	}
	/**
	 * @param cpf the cpf to set
	 */
	public void setCpf(String cpf) {
		this.cpf = cpf;
	}
	/**
	 * @return the aniversario
	 */
	public String getAniversario() {
		return aniversario;
	}
	/**
	 * @param aniversario the aniversario to set
	 */
	public void setAniversario(String aniversario) {
		this.aniversario = aniversario;
	}
	
	public Calendar getNiver() {
		return niver;
	}
	
	public void setNiver(Calendar niver) {
		this.niver = niver;
	}
}
