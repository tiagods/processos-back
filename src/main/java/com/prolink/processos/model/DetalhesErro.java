package com.prolink.processos.model;

public class DetalhesErro {
	private String titulo;
	private Long status;
	private Long timestamp;
	private String mensagemDesenvolvedor;
	/**
	 * @return the titulo
	 */
	public String getTitulo() {
		return titulo;
	}
	/**
	 * @param titulo the titulo to set
	 */
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	/**
	 * @return the status
	 */
	public Long getStatus() {
		return status;
	}
	/**
	 * @param status the status to set
	 */
	public void setStatus(Long status) {
		this.status = status;
	}
	/**
	 * @return the timestamp
	 */
	public Long getTimestamp() {
		return timestamp;
	}
	/**
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	/**
	 * @return the mensagemDesenvolvedor
	 */
	public String getMensagemDesenvolvedor() {
		return mensagemDesenvolvedor;
	}
	/**
	 * @param mensagemDesenvolvedor the mensagemDesenvolvedor to set
	 */
	public void setMensagemDesenvolvedor(String mensagemDesenvolvedor) {
		this.mensagemDesenvolvedor = mensagemDesenvolvedor;
	}
}
