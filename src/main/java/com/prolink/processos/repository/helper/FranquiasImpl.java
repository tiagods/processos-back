package com.prolink.processos.repository.helper;

import java.util.Calendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import com.prolink.processos.model.Franquia;
import com.prolink.processos.repository.helper.queries.FranquiasQueries;

public class FranquiasImpl implements FranquiasQueries{
	
	@PersistenceContext
	private EntityManager manager;

	@SuppressWarnings("unchecked")
	@Override
	@Transactional(readOnly=true)
	public List<Franquia> filtrarPorPeriodo(Calendar lastUpdate) {
		Criteria criteria = manager.unwrap(Session.class).createCriteria(Franquia.class);
		criteria.add(Restrictions.between("lastUpdate", lastUpdate, Calendar.getInstance()));
		return (List<Franquia>)criteria.list();
	}
	
}
