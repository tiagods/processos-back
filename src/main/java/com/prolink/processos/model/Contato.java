package com.prolink.processos.model;

import java.io.Serializable;
import java.util.Calendar;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonInclude;

@Entity
public class Contato extends Pessoa implements Serializable{
	public enum PessoaTipo {
		EMPRESA("Empresa"), PESSOA("Pessoa");
		private String descricao;
		PessoaTipo(String descricao) {
			this.descricao=descricao;
		}
		public String getDescricao() {
			return descricao;
		}
	}
	public enum ContatoTipo{
		GENERICO("Generico"),PROSPECCAO("Prospecção"),SONDAGEM("Sondagem");
		private String descricao;
		private ContatoTipo(String descricao) {
			this.descricao=descricao;
		}
		public String getDescricao() {
			return descricao;
		}
	}
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long id;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Enumerated(value= EnumType.STRING)
	@Column(name="pessoa_tipo")
	private PessoaTipo pessoaTipo = PessoaTipo.PESSOA;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Enumerated(value= EnumType.STRING)
	@Column(name="contato_tipo")
	private ContatoTipo contatoTipo = ContatoTipo.SONDAGEM;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Transient
	//@JoinColumn(name = "origem_id")
	private NegocioOrigem origem;
	
	private boolean material = false;
	private boolean convite = false;
	private boolean newsletter = false;
	/**
	 * @return the id
	 */
	@PrePersist
	private void setCriacao(){
		setCriadoEm(Calendar.getInstance());
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
	 * @return the material
	 */
	public boolean isMaterial() {
		return material;
	}
	/**
	 * @param material the material to set
	 */
	public void setMaterial(boolean material) {
		this.material = material;
	}
	/**
	 * @return the convite
	 */
	public boolean isConvite() {
		return convite;
	}
	/**
	 * @param convite the convite to set
	 */
	public void setConvite(boolean convite) {
		this.convite = convite;
	}
	/**
	 * @return the newsletter
	 */
	public boolean isNewsletter() {
		return newsletter;
	}
	/**
	 * @param newsletter the newsletter to set
	 */
	public void setNewsletter(boolean newsletter) {
		this.newsletter = newsletter;
	}
	
	
}
