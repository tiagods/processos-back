package com.prolink.processos.model.implantacao;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
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
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PostLoad;
import javax.persistence.PrePersist;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

@Entity
@Table(name = "imp_pro_etapa")
public class ImplantacaoProcessoEtapa implements Serializable{

    public enum Status{
        ABERTO("Pendente"),
        CONCLUIDO("Concluido"),
        AGUARDANDO_ANTERIOR("Aguardando Liberação");
        private String descricao;
        Status(String descricao){
            this.descricao = descricao;
        }
        @Override
        public String toString() {
            return this.descricao;
        }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToMany(mappedBy="processoEtapa",cascade=CascadeType.ALL,fetch=FetchType.LAZY,orphanRemoval=true)
    private Set<ImplantacaoProcessoEtapaStatus> historico = new HashSet<>();

    @ManyToOne
    @JoinColumn(name = "processo_id")
    private ImplantacaoProcesso processo;

    @Embedded
    private ImplantacaoEtapa etapa = new ImplantacaoEtapa();

    @Enumerated(EnumType.STRING)
    private Status status = Status.AGUARDANDO_ANTERIOR;

    @Temporal(TemporalType.DATE)
    @Column(name = "data_liberacao")
    private Calendar dataLiberacao;

    @Temporal(TemporalType.DATE)
    @Column(name = "data_atualizacao")
    private Calendar dataAtualizacao;

    @Transient
    private Calendar prazo;

    @Transient
    private Vencido vencido = Vencido.NO_PRAZO; //base de visualização para tabelas

    @Transient
    private boolean venceu = false;
    
    @Transient
    private String statusVencimento="";

    @Transient
    private boolean acionarChamada = false; //enviar mensagem para responsavel da primeira etapa

    public enum Vencido{
        PENDENTE,NO_PRAZO,VENCIDO,VENCE_HOJE
    }

    public ImplantacaoProcessoEtapa(){}

    public ImplantacaoProcessoEtapa(ImplantacaoEtapa implantacaoEtapa,ImplantacaoProcesso processo){
        this.processo=processo;
        this.etapa=implantacaoEtapa;
    }

    @PrePersist
    void prePersist(){
        if(dataLiberacao!=null && dataAtualizacao!=null){
            prazo = dataAtualizacao;
            prazo.add(Calendar.DAY_OF_MONTH,getEtapa().getTempo());
        }
        if(etapa.getEtapa().equals(ImplantacaoEtapa.Etapa.PRIMEIRA)) {
            status = Status.ABERTO;
            setDataLiberacao(Calendar.getInstance());
            setDataAtualizacao(Calendar.getInstance());
            acionarChamada=true;
        }
        etapa.setCriadoEm(Calendar.getInstance());
        //etapa.setCriadoPor(UsuarioLogado.getInstance().getUsuario());
    }
    @PostLoad
    void load(){
        if(getDataAtualizacao()==null) {
            vencido = Vencido.PENDENTE;
            setDataAtualizacao(Calendar.getInstance());
            return;
        }
        LocalDate dataAtualizacao = getDataAtualizacao().getTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate dataFim = dataAtualizacao.plusDays(getEtapa().getTempo());
        
        LocalDate dataAgora = LocalDate.now();
        Period period = Period.between(dataAgora, dataFim);
        long p2 = ChronoUnit.DAYS.between(dataAgora, dataFim);
        if(period.isZero()){
            setStatusVencimento("Vence Hoje");
            vencido = Vencido.VENCE_HOJE;
            this.venceu=true;
        }
        else if(period.isNegative()){
            //setStatusVencimento(periodo.getValue(CalculoDePeriodo.Tipo.DIA, -1*p2));
            vencido = Vencido.VENCIDO;
            this.venceu=true;
        }
        else{
            setStatusVencimento("No prazo ( "+dataFim.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))+" )");
            vencido = Vencido.NO_PRAZO;
        }
        prazo = getDataAtualizacao();
        if(prazo==null) prazo = Calendar.getInstance();
        prazo.add(Calendar.DAY_OF_MONTH, getEtapa().getTempo());
    }

    public Calendar getPrazo() {
        return prazo;
    }

    public void setPrazo(Calendar prazo) {
        this.prazo = prazo;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ImplantacaoEtapa getEtapa() {
        return etapa;
    }

    public void setEtapa(ImplantacaoEtapa etapa) {
        this.etapa = etapa;
    }

    public Set<ImplantacaoProcessoEtapaStatus> getHistorico() { return historico; }

    public void setHistorico(Set<ImplantacaoProcessoEtapaStatus> historico) { this.historico = historico; }

    public ImplantacaoProcesso getProcesso() {
        return processo;
    }

    public void setProcesso(ImplantacaoProcesso processo) {
        this.processo = processo;
    }

    public void setStatus(Status status) { this.status = status; }

    public Status getStatus() { return status; }

    public Calendar getDataLiberacao() {
        return dataLiberacao;
    }

    public void setDataLiberacao(Calendar dataLiberacao) {
        this.dataLiberacao = dataLiberacao;
    }

    public Calendar getDataAtualizacao() { return dataAtualizacao; }

    public void setDataAtualizacao(Calendar dataAtualizacao) { this.dataAtualizacao = dataAtualizacao; }

    public void setStatusVencimento(String statusVencimento) {
        this.statusVencimento = statusVencimento;
    }

    public String getStatusVencimento() {
        return statusVencimento;
    }

    public Vencido getVencido() {
        return vencido;
    }
    public boolean isVenceu() {
		return venceu;
	}
    public void setVenceu(boolean venceu) {
		this.venceu = venceu;
	}
}
