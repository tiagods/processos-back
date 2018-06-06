package com.prolink.processos.services.exceptions;

public class FranquiaNaoEncontradoException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	public FranquiaNaoEncontradoException(String mensagem) {
		super(mensagem);
	}
	public FranquiaNaoEncontradoException(String mensagem, Throwable causa) {
		super(mensagem,causa);
	}
}
