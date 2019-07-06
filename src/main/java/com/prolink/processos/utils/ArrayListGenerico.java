package com.prolink.processos.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ArrayListGenerico<T> extends ArrayList<T>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<T> lista = new ArrayList<T>();
	
	public ArrayListGenerico(T object){
		lista.add(object);
	}
	public ArrayListGenerico(T[] object){
		lista.addAll(Arrays.asList(object));
	}
	public List<T> getLista(){
		return lista;
	}
}
