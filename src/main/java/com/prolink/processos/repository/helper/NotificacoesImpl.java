package com.prolink.processos.repository.helper;

import java.util.Calendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import com.prolink.processos.model.Notificacao;
import com.prolink.processos.model.NotificacaoEnvio;
import com.prolink.processos.repository.helper.queries.NotificacoesQueries;

public class NotificacoesImpl implements NotificacoesQueries{
	@PersistenceContext
	private EntityManager manager;
	@Override
	public List<Notificacao> buscarHoje() {
		Calendar calendar = Calendar.getInstance();
		String sql = "select n from Notificacao n where n.dia=:dia and n.ativo=true";
		TypedQuery<Notificacao> query = manager.createQuery(sql,Notificacao.class);
		query.setParameter("dia", calendar.get(Calendar.DAY_OF_MONTH));
		return query.getResultList();
	}
	@Override
	public List<NotificacaoEnvio> notificacoesPendentes(){
		String sql = "select n from NotificacaoEnvio n where n.data=:data and n.status=false";
		TypedQuery<NotificacaoEnvio> query = manager.createQuery(sql,NotificacaoEnvio.class);
		query.setParameter("data", Calendar.getInstance());
		return query.getResultList();
	}
	@Override
	public boolean verSeExiste(Notificacao notificacao){
		String sql = "select count(*) from NotificacaoEnvio n where n.data=:data and n.notificacao=:notificacao";
		TypedQuery<Number> query = manager.createQuery(sql,Number.class);
		query.setParameter("data", Calendar.getInstance());
		query.setParameter("notificacao", notificacao);
		return query.getSingleResult().intValue()>0;
	}
}
