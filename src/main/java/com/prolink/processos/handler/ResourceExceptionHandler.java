package com.prolink.processos.handler;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.prolink.processos.model.DetalhesErro;
import com.prolink.processos.services.exceptions.AppRegistroNaoEncontradoException;
import com.prolink.processos.services.exceptions.ContatoNaoEncontradoException;
import com.prolink.processos.services.exceptions.FranquiaNaoEncontradoException;
import com.prolink.processos.services.exceptions.FranquiaPacoteNaoEncontradoException;

@ControllerAdvice
public class ResourceExceptionHandler {

	@ExceptionHandler(ContatoNaoEncontradoException.class)
	public ResponseEntity<DetalhesErro> handleContatoNaoEncontradoException
	(ContatoNaoEncontradoException e, HttpServletRequest request){
		DetalhesErro erro = new DetalhesErro();
		erro.setStatus(404l);
		erro.setTitulo("O contato nao pode ser encontrado");
		//erro.setMensagemDesenvolvedor("http://erros.prolinkcontabil.com/404");
		erro.setTimestamp(System.currentTimeMillis());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(erro);
	}
	@ExceptionHandler(FranquiaNaoEncontradoException.class)
	public ResponseEntity<DetalhesErro> handleFranquiaNaoEncontradoException
	(FranquiaNaoEncontradoException e, HttpServletRequest request){
		DetalhesErro erro = new DetalhesErro();
		erro.setStatus(404l);
		erro.setTitulo("A franquia nao pode ser encontrada");
		//erro.setMensagemDesenvolvedor("http://erros.prolinkcontabil.com/404");
		erro.setTimestamp(System.currentTimeMillis());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(erro);
	}
	
	@ExceptionHandler(FranquiaPacoteNaoEncontradoException.class)
	public ResponseEntity<DetalhesErro> handleFranquiaPacoteNaoEncontradoException
	(FranquiaPacoteNaoEncontradoException e, HttpServletRequest request){
		DetalhesErro erro = new DetalhesErro();
		erro.setStatus(404l);
		erro.setTitulo("O pacote da franquia nao pode ser encontrada");
		//erro.setMensagemDesenvolvedor("http://erros.prolinkcontabil.com/404");
		erro.setTimestamp(System.currentTimeMillis());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(erro);
	}
	@ExceptionHandler(AppRegistroNaoEncontradoException.class)
	public ResponseEntity<DetalhesErro> handleAppRegistroNaoEncontradoException
	(AppRegistroNaoEncontradoException e, HttpServletRequest request){
		DetalhesErro erro = new DetalhesErro();
		erro.setStatus(404l);
		erro.setTitulo("O registro nao foi aceito");
		//erro.setMensagemDesenvolvedor("http://erros.prolinkcontabil.com/404");
		erro.setTimestamp(System.currentTimeMillis());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(erro);
	}
}
