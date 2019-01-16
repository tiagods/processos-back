package com.prolink.processos.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.prolink.processos.model.Contato;
import com.prolink.processos.model.NegocioCategoria;
import com.prolink.processos.model.NegocioLista;
import com.prolink.processos.model.NegocioMalaDireta;
import com.prolink.processos.model.NegocioNivel;
import com.prolink.processos.model.NegocioOrigem;
import com.prolink.processos.model.NegocioServico;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.NegociosCategorias;
import com.prolink.processos.repository.NegociosListas;
import com.prolink.processos.repository.NegociosMalaDireta;
import com.prolink.processos.repository.NegociosNiveis;
import com.prolink.processos.repository.NegociosOrigens;
import com.prolink.processos.repository.NegociosServicos;
import com.prolink.processos.repository.Usuarios;
import com.prolink.processos.repository.filter.ContatoFilter;
import com.prolink.processos.services.ContatosServices;

@Controller
@RequestMapping(value="/contatos")
public class ContatoController {

	@Autowired
	private ContatosServices contatos;
	@Autowired
	private NegociosListas listas;
	@Autowired
	private NegociosCategorias categorias;
	@Autowired
	private NegociosMalaDireta malaDireta;
	@Autowired
	private NegociosNiveis niveis;
	@Autowired
	private NegociosOrigens origens;
	@Autowired
	private NegociosServicos servicos;
	@Autowired
	private Usuarios usuarios;
	
	private static final String CONTATO_PESQUISA = "contatos/ContatoPesquisa";
	private static final String CONTATO_CADASTRO = "contatos/ContatoCadastro";
	
	@RequestMapping(value="{id}",method=RequestMethod.DELETE)
	public String excluir(@PathVariable Long id) {
		contatos.remover(id);
		return "redirect:/contatos";
	}
	
	@RequestMapping(value="/novo")
	public ModelAndView novo() {
		ModelAndView mv = new ModelAndView(CONTATO_CADASTRO);
		mv.addObject(new Contato());
		return mv;
	}
	@RequestMapping(value="/novo/{aba}")
	public ModelAndView mudarAba(Contato contato, @PathVariable String aba) {
		ModelAndView mv = new ModelAndView(CONTATO_CADASTRO);
		mv.addObject(contato);
		mv.addObject("aba", aba);
		return mv;
	}
	
	@RequestMapping
	public ModelAndView pesquisar(@ModelAttribute("filtro") ContatoFilter filter) {
		ModelAndView mv = new ModelAndView(CONTATO_PESQUISA);
		List<Contato> lista = contatos.filtrar(filter);
		mv.addObject("contatos", lista);
		return mv;
	}
	
	@ModelAttribute("listas")
	public List<NegocioLista> listas(){
		return listas.findAll();
	}
	@ModelAttribute("categorias")
	public List<NegocioCategoria> categorias(){
		return categorias.findAll();
	}
	@ModelAttribute("malaDireta")
	public List<NegocioMalaDireta> malaDireta(){
		return malaDireta.findAll();
	}
	@ModelAttribute("niveis")
	public List<NegocioNivel> niveis(){
		return niveis.findAll();
	}
	@ModelAttribute("origens")
	public List<NegocioOrigem> origem(){
		return origens.findAll();
	}
	@ModelAttribute("servicos")
	public List<NegocioServico> servicos(){
		return servicos.findAll();
	}
	@ModelAttribute("atendentes")
	public List<Usuario> atendentes(){
		return usuarios.findAll();
	}
}
