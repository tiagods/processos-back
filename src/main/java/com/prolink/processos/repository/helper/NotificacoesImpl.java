package com.prolink.processos.repository.helper;

import java.util.Calendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import com.prolink.processos.model.Notificacao;
import com.prolink.processos.model.NotificacaoEnvio;
import com.prolink.processos.repository.helper.queries.NotificacoesQueries;

public class NotificacoesImpl implements NotificacoesQueries{
	
	@PersistenceContext
	private EntityManager manager;
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Notificacao> buscarHoje() {
		Calendar calendar = Calendar.getInstance();
		Criteria criteria = manager.unwrap(Session.class).createCriteria(Notificacao.class);
		criteria.add(Restrictions.eq("dia", calendar.get(Calendar.DAY_OF_MONTH)));
		criteria.add(Restrictions.eq("ativo", true));
		return criteria.list();
	}
	@Override
	public List<NotificacaoEnvio> notificacoesPendentes(){
		Criteria criteria = manager.unwrap(Session.class).createCriteria(NotificacaoEnvio.class);
		criteria.add(Restrictions.eq("data", Calendar.getInstance()));
		criteria.add(Restrictions.eq("status", false));
		 return criteria.list();
	}
	@Override
	public boolean verSeExiste(Notificacao notificacao){
		Criteria criteria = manager.unwrap(Session.class).createCriteria(NotificacaoEnvio.class);
		criteria.add(Restrictions.eq("data", Calendar.getInstance()));
		criteria.add(Restrictions.eq("notificacao",notificacao));
		criteria.setProjection(Projections.rowCount());
		return ((Number)criteria.uniqueResult()).intValue()>0;
	}
}
