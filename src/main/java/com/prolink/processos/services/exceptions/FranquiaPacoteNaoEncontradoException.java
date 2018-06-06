package com.prolink.processos.services.exceptions;

public class FranquiaPacoteNaoEncontradoException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	public FranquiaPacoteNaoEncontradoException(String mensagem) {
		super(mensagem);
	}
	public FranquiaPacoteNaoEncontradoException(String mensagem, Throwable causa) {
		super(mensagem,causa);
	}
}
