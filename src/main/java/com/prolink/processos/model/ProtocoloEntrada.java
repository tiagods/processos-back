package com.prolink.processos.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;

@Entity
@Table(name="protocolo_entrada")
public class ProtocoloEntrada implements Serializable {

    public enum StatusRecebimento{
        STATUS("Status do Recebimento"),ABERTO("Não Recebido"),FECHADO("Entregue");
        private String descricao;
        StatusRecebimento(String descricao){
            this.descricao=descricao;
        }
        public String getDescricao() {
            return descricao;
        }
        @Override
        public String toString() {
            return getDescricao();
        }
    }
    public enum StatusDevolucao{
        DEVOLVIDO("Saida do Documento"),NAOSEENQUADA("Desnecessario"),SIM("Devolvido"),NAO("Pendente");
        private String descricao;
        StatusDevolucao(String descricao){
            this.descricao=descricao;
        }
        public String getDescricao() {
            return descricao;
        }
        @Override
        public String toString() {
            return getDescricao();
        }
    }
    public enum Classificacao{
        USUARIO("Usuario"),CLIENTE("Apelido do Cliente"),PROTOCOLO("Nº do Protocolo");
        private String descricao;
        Classificacao(String descricao){
            this.descricao=descricao;
        }
        public String getDescricao() {
            return descricao;
        }
        @Override
        public String toString() {
            return getDescricao();
        }
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "data_entrada")
    @Temporal(TemporalType.TIMESTAMP)
    private Calendar dataEntrada;
    @Column(name = "quem_entregou")
    private String quemEntregou;
    @ManyToOne
    @JoinColumn(name = "cliente_id")
    private Cliente cliente;
    @Column(columnDefinition = "text")
    private String historico;
    @Column(name = "data_recebimento")
    @Temporal(TemporalType.DATE)
    private Calendar dataRecebimento;
    private String observacao;
    private boolean alerta=false;
    private boolean recebido=false;
    private boolean devolver=false;
    private boolean devolvido=false;
    @Temporal(TemporalType.DATE)
    private Calendar prazo;
    private boolean adiado=false;
    private String motivo;

    @ManyToOne
    @JoinColumn(name = "para_id")
    private Usuario paraQuem;
    @ManyToOne
    @JoinColumn(name = "recebido_id")
    private Usuario quemRecebeu;

    @OneToMany(mappedBy = "entrada",fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    private Set<ProtocoloItem> items = new HashSet<>();

    @PrePersist
    void prePersist(){
        setDataEntrada(Calendar.getInstance());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProtocoloEntrada that = (ProtocoloEntrada) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Calendar getDataEntrada() {
        return dataEntrada;
    }

    public void setDataEntrada(Calendar dataEntrada) {
        this.dataEntrada = dataEntrada;
    }

    public String getQuemEntregou() {
        return quemEntregou;
    }

    public void setQuemEntregou(String quemEntregou) {
        this.quemEntregou = quemEntregou;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public String getHistorico() {
        return historico;
    }

    public void setHistorico(String historico) {
        this.historico = historico;
    }

    public Calendar getDataRecebimento() {
        return dataRecebimento;
    }

    public void setDataRecebimento(Calendar dataRecebimento) {
        this.dataRecebimento = dataRecebimento;
    }

    public String getObservacao() {
        return observacao;
    }

    public void setObservacao(String observacao) {
        this.observacao = observacao;
    }

    public boolean isAlerta() {
        return alerta;
    }

    public void setAlerta(boolean alerta) {
        this.alerta = alerta;
    }

    public boolean isRecebido() {
        return recebido;
    }

    public void setRecebido(boolean recebido) {
        this.recebido = recebido;
    }

    public boolean isDevolver() {
        return devolver;
    }

    public void setDevolver(boolean devolver) {
        this.devolver = devolver;
    }

    public boolean isDevolvido() {
        return devolvido;
    }

    public void setDevolvido(boolean devolvido) {
        this.devolvido = devolvido;
    }

    public Calendar getPrazo() {
        return prazo;
    }

    public void setPrazo(Calendar prazo) {
        this.prazo = prazo;
    }

    public boolean isAdiado() {
        return adiado;
    }

    public void setAdiado(boolean adiado) {
        this.adiado = adiado;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public Usuario getParaQuem() {
        return paraQuem;
    }

    public void setParaQuem(Usuario paraQuem) {
        this.paraQuem = paraQuem;
    }

    public Usuario getQuemRecebeu() {
        return quemRecebeu;
    }

    public void setQuemRecebeu(Usuario quemRecebeu) {
        this.quemRecebeu = quemRecebeu;
    }

    public Set<ProtocoloItem> getItems() {
        return items;
    }

    public void setItems(Set<ProtocoloItem> items) {
        this.items = items;
    }
}
