package com.prolink.processos.model;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

public class ProtocoloSaida implements Serializable{
    private Long id;
    private String empresaNome;
    private int cliente;
    private int usuarioId;
    private String funcionarioPara;
    private String setorPara;
    private String observacao;
    private Date data;
    private String comprovante;
    private int protocoloEntradaId;
    private Set<ProtocoloItem> items = new HashSet();
    
    public Long getId() {
        return id;
    }
}
