package com.prolink.processos.model;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

@Entity
@Table(name="protocolo_item")
public class ProtocoloItem implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private int quantidade=0;
    @Column(columnDefinition = "text")
    private String detalhes;
    @Column(name = "data_entrada")
    @Temporal(TemporalType.DATE)
    private Calendar dataEntrada;
    @Column(name = "data_saida")
    @Temporal(TemporalType.DATE)
    private Calendar dataSaida;
    @ManyToOne
    @JoinColumn(name = "cliente_id")
    private Cliente cliente;
    @ManyToOne
    @JoinColumn(name = "entrada_id")
    private ProtocoloEntrada entrada;
    /*
    @ManyToOne
    @JoinColumn(name = "saida_id")
    */
    @Transient
    private ProtocoloSaida saida;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public String getDetalhes() {
        return detalhes;
    }

    public void setDetalhes(String detalhes) {
        this.detalhes = detalhes;
    }

    public Calendar getDataEntrada() {
        return dataEntrada;
    }

    public void setDataEntrada(Calendar dataEntrada) {
        this.dataEntrada = dataEntrada;
    }

    public Calendar getDataSaida() {
        return dataSaida;
    }

    public void setDataSaida(Calendar dataSaida) {
        this.dataSaida = dataSaida;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public ProtocoloEntrada getEntrada() {
        return entrada;
    }

    public void setEntrada(ProtocoloEntrada entrada) {
        this.entrada = entrada;
    }

    public ProtocoloSaida getSaida() {
        return saida;
    }

    public void setSaida(ProtocoloSaida saida) {
        this.saida = saida;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProtocoloItem item = (ProtocoloItem) o;
        return quantidade == item.quantidade &&
                Objects.equals(id, item.id) &&
                Objects.equals(nome, item.nome) &&
                Objects.equals(detalhes, item.detalhes) &&
                Objects.equals(dataEntrada, item.dataEntrada) &&
                Objects.equals(dataSaida, item.dataSaida) &&
                Objects.equals(cliente, item.cliente) &&
                Objects.equals(entrada, item.entrada) &&
                Objects.equals(saida, item.saida);
    }

    @Override
    public int hashCode() {

        return Objects.hash(id, nome, quantidade, detalhes, dataEntrada, dataSaida, cliente, entrada, saida);
    }
}
