package com.prolink.processos.services.exceptions;

public class AppRegistroNaoEncontradoException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	public AppRegistroNaoEncontradoException(String mensagem) {
		super(mensagem);
	}
	public AppRegistroNaoEncontradoException(String mensagem, Throwable causa) {
		super(mensagem,causa);
	}
}
