package com.prolink.processos.utils;

import java.awt.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

public abstract class AlertaModel {

    protected void renderizar(String texto) throws IOException {
        File htmlFile = new File(System.getProperty("java.io.tmpdir")+"/index.html");
        FileWriter fileWriter = new FileWriter(htmlFile);
        fileWriter.write(texto);
        fileWriter.close();
    }

    protected String cabecalho(List<String> mensagens){
        StringBuilder builder = new StringBuilder();
        builder.append("<!DOCTYPE html>")
                .append("<html>")
                .append("<head>")
                .append("<title></title>")
                .append("<meta content=\"text/html; charset=utf-8\" http-equiv=\"content-type\" />")
                .append("</head>")
                .append("<body style=\"margin: 22px 10px 10px;\">")
                .append("<div style=\"text-align: center;\">");//div inicial
                mensagens.forEach(m->{
                    builder.append("<div style=\"text-align: left;\">")
                            .append("<span style=\"font-size: 18px; text-align: left;\">").append(m).append("</span></div>")
                            .append("<div>&nbsp;</div>");
                });
        return builder.toString();
    }
    protected String rodape(List<String> mensagens){
        StringBuilder builder = new StringBuilder();
        //inicio do rodape
        mensagens.forEach(m -> {
            builder.append("<div>&nbsp;</div>")
                    .append("<div style=\"text-align: left;\">")
                    .append("<span style=\"font-size: 18px; text-align: left;\">").append(m).append("</span></div>");
        });
        builder.append("</div>")
                .append("<p><span style=\"color:#d3d3d3;\">***Esse aviso &eacute; gerado automaticamente, n&atilde;o &eacute; necess&aacute;rio que responda***</span></p>")
                //.append("<p>&nbsp;</p>")
                //linha assinatura.append("<p><span style=\"color:#d3d3d3;\"><img alt=\"\" src=\"http://prolinkvip.prolinkcontabil.com.br/uploadimages/prolinkvip.prolinkcontabil.com.br/assinatura_email_prolink(1).gif\" style=\"width: 365px; height: 123px; float: left;\" /></span></p>")
                .append("</body>")
                .append("</html>");
        return builder.toString();
    }
}
