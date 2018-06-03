package com.prolink.processos.services.exceptions;

public class ContatoNaoEncontradoException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	public ContatoNaoEncontradoException(String mensagem) {
		super(mensagem);
	}
	public ContatoNaoEncontradoException(String mensagem, Throwable causa) {
		super(mensagem,causa);
	}
}
