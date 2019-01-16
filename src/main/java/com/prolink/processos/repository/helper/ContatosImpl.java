package com.prolink.processos.repository.helper;

import java.util.Calendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;

import com.prolink.processos.model.Contato;
import com.prolink.processos.repository.filter.ContatoFilter;
import com.prolink.processos.repository.helper.queries.ContatosQueries;

public class ContatosImpl implements ContatosQueries {

	@PersistenceContext
	private EntityManager manager;

	@Override
	public List<Contato> filtrar(ContatoFilter filter) {
		Criteria criteria = manager.unwrap(Session.class).createCriteria(Contato.class);
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
		
		return criteria.list();
	}

}
