package com.prolink.processos.model;

import java.util.Calendar;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name="notificao_extra")
public class NotificacaoExtra {
	public enum NotificacaoResumo{
		PROTOCOLO_ENTRADA, PROCESSO_IMPLANTACAO
	}
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long id;
	private String titulo;
	@Temporal(TemporalType.DATE)
	private Calendar data;
	@Temporal(TemporalType.TIMESTAMP)
	private Calendar dataEnvio;
	private String destino;
	private String assunto;
	private String descricao;
	@Enumerated(EnumType.STRING)
	private NotificacaoResumo resumo;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTitulo() {
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	public Calendar getData() {
		return data;
	}
	public void setData(Calendar data) {
		this.data = data;
	}
	public Calendar getDataEnvio() {
		return dataEnvio;
	}
	public void setDataEnvio(Calendar dataEnvio) {
		this.dataEnvio = dataEnvio;
	}
	public String getDestino() {
		return destino;
	}
	public void setDestino(String destino) {
		this.destino = destino;
	}
	public String getAssunto() {
		return assunto;
	}
	public void setAssunto(String assunto) {
		this.assunto = assunto;
	}
	public String getDescricao() {
		return descricao;
	}
	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}
	public NotificacaoResumo getResumo() {
		return resumo;
	}
	public void setResumo(NotificacaoResumo resumo) {
		this.resumo = resumo;
	}
	
	
	
}
