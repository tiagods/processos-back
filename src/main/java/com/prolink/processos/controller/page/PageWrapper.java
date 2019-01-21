package com.prolink.processos.controller.page;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.data.domain.Page;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.UriComponentsBuilder;

public class PageWrapper<T>{
	private Page<T> page;
	private UriComponentsBuilder uriBuilder;

	public PageWrapper(Page<T> page,HttpServletRequest request) {
		this.page = page;
		this.uriBuilder = ServletUriComponentsBuilder.fromRequest(request);
	}
	public List<T> getConteudo(){
		return this.page.getContent();
	}
	public boolean isPrimeira() {
		return this.page.isFirst();
	}
	public boolean isUltima() {
		return this.page.isLast();
	}
	public int getTotal() {
		return this.page.getTotalPages();
	}
	public int getAtual() {
		return this.page.getNumber();
	}
	public String urlParaPagina(int pagina) {
		return this.uriBuilder.replaceQueryParam("page",pagina).toUriString();
	}
}
