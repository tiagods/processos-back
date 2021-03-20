package com.prolink.processos.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
public class WebSecutiryConfig extends WebSecurityConfigurerAdapter {

	@Value("${usuario.username}")
	private String username;

	@Value("${usuario.password}")
	private String senha;

	@Autowired
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.inMemoryAuthentication()
				.withUser(username).password(senha).roles("USER");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
			.antMatchers("/**").permitAll()
			.antMatchers("/h2-console/**").permitAll()
				.antMatchers(HttpMethod.OPTIONS,"/**").permitAll()
			.anyRequest().authenticated()
			.and()
				.httpBasic()
			.and()
				.csrf()
				.disable();
	}
}
