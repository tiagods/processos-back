package com.prolink.processos.services.exceptions;

public class ProtocoloEntradaNaoEncontradoException extends RuntimeException{
	private static final long serialVersionUID = 1L;
	public ProtocoloEntradaNaoEncontradoException(String mensagem) {
		super(mensagem);
	}
	public ProtocoloEntradaNaoEncontradoException(String mensagem, Throwable causa) {
		super(mensagem,causa);
	}

}
