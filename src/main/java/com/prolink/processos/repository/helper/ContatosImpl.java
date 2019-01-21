package com.prolink.processos.repository.helper;

import java.util.Calendar;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.filter.ContatoFilter;
import com.prolink.processos.repository.helper.queries.ContatosQueries;

public class ContatosImpl implements ContatosQueries {

	@PersistenceContext
	private EntityManager manager;


	private void adicionarFiltro(ContatoFilter filter, Criteria criteria) {
		if(filter.getPessoaTipo()!=null) criteria.add(Restrictions.eq("pessoaTipo",filter.getPessoaTipo()));
		if(filter.getContatoTipo()!=null) criteria.add(Restrictions.eq("contatoTipo",filter.getContatoTipo()));
		if(filter.getLista()!=null) {
			criteria.createAlias("listas", "lis");
			criteria.add(Restrictions.eq("lis.id", filter.getLista().getId()));
		}
		if(filter.getCategoria()!=null) criteria.add(Restrictions.eq("categoria", filter.getCategoria()));
		if(filter.getMalaDireta()!=null) criteria.add(Restrictions.eq("malaDireta", filter.getMalaDireta()));
		if(filter.getNivel()!=null) criteria.add(Restrictions.eq("nivel", filter.getNivel()));
		if(filter.getOrigem()!=null) criteria.add(Restrictions.eq("origem", filter.getOrigem()));
		if(filter.getServico()!=null) criteria.add(Restrictions.eq("servico", filter.getServico()));
		if(filter.getAtendente()!=null) criteria.add(Restrictions.eq("atendente", filter.getAtendente()));
		
		Calendar dataIn = Calendar.getInstance();
		dataIn.set(1900, 01, 01);
		
		Calendar dataFim = Calendar.getInstance();
		
		if(filter.getDataInicial()!=null) dataIn = filter.getDataInicial();
		if(filter.getDataFinal()!=null) dataFim = filter.getDataFinal();
		criteria.add(Restrictions.between("criadoEm", dataIn, dataFim));
		
		if(filter.getNome()!=null && !filter.getNome().trim().equals(""))
			criteria.add(Restrictions.ilike("nome", filter.getNome(), MatchMode.ANYWHERE));
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly=true)
	@Override
	public Page<Contato> filtrar(ContatoFilter filter,Pageable pageable) {
		Criteria criteria = manager.unwrap(Session.class).createCriteria(Contato.class);
		criteria.setMaxResults(pageable.getPageSize());
		int registro = pageable.getPageNumber() * pageable.getPageSize();
		criteria.setFirstResult(registro);
		
		adicionarFiltro(filter, criteria);
		
		criteria.addOrder(Order.desc("id"));
		return new PageImpl<Contato>(criteria.list(), pageable, total(filter));
	}
	private Long total(ContatoFilter filter) {
		Criteria criteria = manager.unwrap(Session.class).createCriteria(Contato.class);
		adicionarFiltro(filter, criteria);
		criteria.setProjection(Projections.rowCount());
		return (Long)criteria.uniqueResult();
	}
	
}
