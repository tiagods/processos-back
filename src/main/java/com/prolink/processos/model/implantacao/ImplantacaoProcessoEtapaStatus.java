package com.prolink.processos.model.implantacao;

import com.prolink.processos.model.Usuario;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Calendar;
import java.util.Objects;

@Entity
@Table(name = "imp_pro_eta_status")
public class ImplantacaoProcessoEtapaStatus implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "processo_etapa_id")
    private ImplantacaoProcessoEtapa processoEtapa;
    @ManyToOne
    @JoinColumn(name = "criado_por_id")
    private Usuario criadoPor;
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "criado_em")
    private Calendar criadoEm;
    private boolean finalizado = true;
    @Column(columnDefinition = "text")
    private String descricao;

    @PrePersist
    void prePersist(){
        setCriadoEm(Calendar.getInstance());
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ImplantacaoProcessoEtapa getProcessoEtapa() {
        return processoEtapa;
    }

    public void setProcessoEtapa(ImplantacaoProcessoEtapa processoEtapa) {
        this.processoEtapa = processoEtapa;
    }

    public Usuario getCriadoPor() {
        return criadoPor;
    }

    public void setCriadoPor(Usuario criadoPor) {
        this.criadoPor = criadoPor;
    }

    public Calendar getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(Calendar criadoEm) {
        this.criadoEm = criadoEm;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ImplantacaoProcessoEtapaStatus that = (ImplantacaoProcessoEtapaStatus) o;
        return Objects.equals(id, that.id);
    }

    public void setFinalizado(boolean finalizado) {
        this.finalizado = finalizado;
    }

    public boolean isFinalizado() {
        return finalizado;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    @Override
    public int hashCode() {

        return Objects.hash(id);
    }
}
