package com.prolink.processos.model;

import javax.persistence.*;

//@Entity
//@Table(name="email_log")
public class EmailLog {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String de;
    private String resumo;
    private String assunto;

//    @Column(columnDefinition = "text")
    private String descricao;
    private String para;
    private String cc;
    private String cco;
    private String anexo;
    private boolean entregue=false;



}
