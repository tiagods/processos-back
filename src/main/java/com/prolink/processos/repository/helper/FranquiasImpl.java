package com.prolink.processos.repository.helper;

import java.util.Calendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.transaction.annotation.Transactional;

import com.prolink.processos.model.Franquia;
import com.prolink.processos.repository.helper.queries.FranquiasQueries;

public class FranquiasImpl implements FranquiasQueries{
	
	@PersistenceContext
	private EntityManager manager;

	@Override
	@Transactional(readOnly=true)
	public List<Franquia> filtrarPorPeriodo(Calendar lastUpdate) {
		TypedQuery<Franquia> query = manager.createQuery("select f from Franquia f where f.lastUpdate=:lastUpdate", Franquia.class);
		query.setParameter("lastUpdate", lastUpdate);
		return query.getResultList();
	}
}
