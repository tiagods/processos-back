/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prolink.processos.model;

import java.io.Serializable;
import java.text.Normalizer;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 *
 * @author Tiago
 */
@Entity
public class Cliente implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="cod")
    private Long id;
    @Column(name="empresa")
    private String nome;
    private String status;
    private String cnpj;

    public Cliente(){}
    public Cliente(Long id){
        this.id=id;
    }

    public String getIdFormatado(){
        String valor = String.valueOf(id);
        String newValor = valor.length()==1?"000"+valor:
                (valor.length()==2?"00"+valor:
                        (valor.length()==3?"0"+valor:valor));
        return newValor;
    }
    public String getNomeFormatado(){
        String[] newValue = nome.split(" ");
        String novoNome = newValue.length>3? newValue[0]+" "+newValue[1]+" "+newValue[2]:nome;
        return Normalizer
                .normalize(novoNome, Normalizer.Form.NFD)
                .replaceAll("[^\\p{ASCII}]", "");
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
     * @return the nome
     */
    public String getNome() {
        return nome;
    }

    /**
     * @param nome the nome to set
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
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

    @Override
    public String toString() {
        return id+"-"+nome;
    }
}
