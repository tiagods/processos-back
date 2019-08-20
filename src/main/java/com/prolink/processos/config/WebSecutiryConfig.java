package com.prolink.processos.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
public class WebSecutiryConfig extends WebSecurityConfigurerAdapter{
	@Autowired
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.inMemoryAuthentication().withUser("plkabf")
		.password("UCdpt2YbHfVrqqh8RVgtvRkKXbv0eiNZ").roles("USER").and().withUser("admin").password("admin").roles("USER");
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
				.csrf().disable();
	}
}
