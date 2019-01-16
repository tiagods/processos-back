package com.prolink.processos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;

import com.fasterxml.jackson.annotation.JsonInclude;

@Embeddable
public class PessoaJuridica implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String razao;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String cnpj;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String im;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String ie;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String responsavel;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String apelido;
	/**
	 * @return the razao
	 */
	public String getRazao() {
		return razao;
	}
	/**
	 * @param razao the razao to set
	 */
	public void setRazao(String razao) {
		this.razao = razao;
	}
	/**
	 * @return the cnpj
	 */
	public String getCnpj() {
		return cnpj;
	}
	/**
	 * @param cnpj the cnpj to set
	 */
	public void setCnpj(String cnpj) {
		this.cnpj = cnpj;
	}
	/**
	 * @return the im
	 */
	public String getIm() {
		return im;
	}
	/**
	 * @param im the im to set
	 */
	public void setIm(String im) {
		this.im = im;
	}
	/**
	 * @return the ie
	 */
	public String getIe() {
		return ie;
	}
	/**
	 * @param ie the ie to set
	 */
	public void setIe(String ie) {
		this.ie = ie;
	}
	public String getResponsavel() {
		return responsavel;
	}
	public void setResponsavel(String responsavel) {
		this.responsavel = responsavel;
	}
	/**
	 * @return the apelido
	 */
	public String getApelido() {
		return apelido;
	}
	/**
	 * @param apelido the apelido to set
	 */
	public void setApelido(String apelido) {
		this.apelido = apelido;
	}

	
}
