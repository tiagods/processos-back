package com.prolink.processos.model.negocio;

import java.io.Serializable;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.prolink.processos.model.Pessoa;
import com.prolink.processos.model.PessoaFisica;
import com.prolink.processos.model.PessoaJuridica;
import com.prolink.processos.model.Usuario;

@Entity
public class Contato extends Pessoa implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public enum PessoaTipo {
		EMPRESA("Empresa"),PESSOA("Pessoa");
		private String descricao;
		PessoaTipo(String descricao) {
			this.descricao=descricao;
		}
		public String getDescricao() {
			return descricao;
		}	
	}
	public enum ContatoTipo{
		PROSPECCAO("Prospecção"),SONDAGEM("Sondagem");
		private String descricao;
		private ContatoTipo(String descricao) {
			this.descricao=descricao;
		}
		public String getDescricao() {
			return descricao;
		}
	}
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long id;
	
	@Embedded
	private PessoaFisica fisico;
	@Embedded
	private PessoaJuridica juridico;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Enumerated(value = EnumType.STRING)
	@Column(name="pessoa_tipo")
	private PessoaTipo pessoaTipo = PessoaTipo.PESSOA;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Enumerated(value= EnumType.STRING)
	@Column(name="contato_tipo")
	private ContatoTipo contatoTipo = ContatoTipo.SONDAGEM;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToOne
	@JoinColumn(name = "origem_id")
	private NegocioOrigem origem;

	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToOne
	@JoinColumn(name = "atendente_id")
	private Usuario atendente;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@Column(name="detalhes_origem")
	private String detalhesOrigem;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String resumo;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private String apresentacao;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToOne
	@JoinColumn(name = "servico_id")
	private NegocioServico servico;

	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToOne
	@JoinColumn(name = "categoria_id")
	private NegocioCategoria categoria;

	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToOne
	@JoinColumn(name = "nivel_id")
	private NegocioNivel nivel;
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name="contato_lista",
            joinColumns = { @JoinColumn(name = "contato_id", referencedColumnName = "id") },
            inverseJoinColumns = { @JoinColumn(name = "lista_id", referencedColumnName = "id") })
	private Set<NegocioLista> listas = new HashSet<>();
	
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private boolean material = false;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private boolean convite = false;
	@JsonInclude(JsonInclude.Include.NON_NULL)
	private boolean newsletter = false;

	@JsonInclude(JsonInclude.Include.NON_NULL)
	@ManyToOne
	@JoinColumn(name="mala_direta_id")
	private NegocioMalaDireta malaDireta;
	
	/*
	@OneToMany(fetch=FetchType.LAZY,mappedBy="negocioContato",cascade=CascadeType.ALL)
	private Set<NegocioProposta> negocios = new LinkedHashSet<>();
	
	@OneToMany(fetch=FetchType.LAZY,mappedBy="contato",cascade=CascadeType.ALL)
	private Set<NegocioTarefaContato> tarefas = new LinkedHashSet<>();
	
	@ManyToOne
	@JoinColumn(name = "ultimo_negocio_id")
	private NegocioProposta ultimoNegocio;
	*/
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
	 * @return the fisico
	 */
	public PessoaFisica getFisico() {
		return fisico;
	}

	/**
	 * @param fisico the fisico to set
	 */
	public void setFisico(PessoaFisica fisico) {
		this.fisico = fisico;
	}

	/**
	 * @return the juridico
	 */
	public PessoaJuridica getJuridico() {
		return juridico;
	}

	/**
	 * @param juridico the juridico to set
	 */
	public void setJuridico(PessoaJuridica juridico) {
		this.juridico = juridico;
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
	 * @return the detalhesOrigem
	 */
	public String getDetalhesOrigem() {
		return detalhesOrigem;
	}

	/**
	 * @param detalhesOrigem the detalhesOrigem to set
	 */
	public void setDetalhesOrigem(String detalhesOrigem) {
		this.detalhesOrigem = detalhesOrigem;
	}

	/**
	 * @return the resumo
	 */
	public String getResumo() {
		return resumo;
	}

	/**
	 * @param resumo the resumo to set
	 */
	public void setResumo(String resumo) {
		this.resumo = resumo;
	}

	/**
	 * @return the apresentacao
	 */
	public String getApresentacao() {
		return apresentacao;
	}

	/**
	 * @param apresentacao the apresentacao to set
	 */
	public void setApresentacao(String apresentacao) {
		this.apresentacao = apresentacao;
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
	 * @return the listas
	 */
	public Set<NegocioLista> getListas() {
		return listas;
	}

	/**
	 * @param listas the listas to set
	 */
	public void setListas(Set<NegocioLista> listas) {
		this.listas = listas;
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
		Contato other = (Contato) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
}
