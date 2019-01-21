package com.prolink.processos.controller;

import java.beans.PropertyEditorSupport;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.prolink.processos.controller.page.PageWrapper;
import com.prolink.processos.model.Cidade;
import com.prolink.processos.model.Contato;
import com.prolink.processos.model.Contato.ContatoTipo;
import com.prolink.processos.model.Contato.PessoaTipo;
import com.prolink.processos.model.NegocioCategoria;
import com.prolink.processos.model.NegocioLista;
import com.prolink.processos.model.NegocioMalaDireta;
import com.prolink.processos.model.NegocioNivel;
import com.prolink.processos.model.NegocioOrigem;
import com.prolink.processos.model.NegocioServico;
import com.prolink.processos.model.PessoaFisica;
import com.prolink.processos.model.PessoaJuridica;
import com.prolink.processos.model.Usuario;
import com.prolink.processos.repository.Cidades;
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
	@Autowired
	private Cidades cidades;

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
		mv = baseMAV(mv);
		Contato contato = new Contato();
		contato.setFisico(new PessoaFisica());
		contato.setJuridico(new PessoaJuridica());
		mv.addObject(contato);
		return mv;
	}
	// requisicao passando id como parametro e recuperando objeto
	@RequestMapping("{id}")
	public ModelAndView edicao(@PathVariable("id") Long id) {
		ModelAndView mv = new ModelAndView(CONTATO_CADASTRO);
		Contato c = contatos.buscar(id);
		mv = baseMAV(mv);
		mv.addObject(c);
		return mv;
	}
	@GetMapping
	public ModelAndView pesquisar(@ModelAttribute("filtro") ContatoFilter filter, BindingResult result, 
			@PageableDefault(size=100) Pageable pageable, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView(CONTATO_PESQUISA);
		PageWrapper<Contato> lista = new PageWrapper<>(contatos.filtrar(filter,pageable),request);
		mv = baseMAV(mv);
		mv.addObject("pagina", lista);
		return mv;
	}
	@RequestMapping(method=RequestMethod.POST)
	public ModelAndView salvar(@Valid Contato contato, BindingResult result, RedirectAttributes attributes) {
		if(result.hasErrors()) {
			ModelAndView mv = new ModelAndView(CONTATO_CADASTRO);
			mv = baseMAV(mv);
			return mv;
		}
		System.out.println(">>>"+contato.getCriadoEm());
		contatos.salvar(contato);
		attributes.addFlashAttribute("mensagem", "Registro salvo com sucesso!");
		return new ModelAndView("redirect:/contatos/novo");
	}
	
	
	private ModelAndView baseMAV(ModelAndView mv) {
		mv.addObject("pessoasTipos",PessoaTipo.values());
		mv.addObject("contatosTipos",ContatoTipo.values());
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
	@ModelAttribute("cidades")
	public List<Cidade> cidades(){
		return cidades.findAll();
	}
}
