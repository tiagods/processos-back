package com.prolink.processos.scheduler;

import com.prolink.processos.repository.ImplantacaoProcessosEtapas;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Schedules;

public class NotificacaoProcessosImplantacao {

    @Autowired
    private ImplantacaoProcessosEtapas etapas;


    //@Schedules(value = "* * 8 ? * MON,WED,FRI")
    public void notificarUsuarios(){

    }

    //@Schedules(value = "* * 8 ? * MON-FRI")
    public void notificarVenceHoje(){

    }

    //@Schedules(value = "* * 8 ? * MON-FRI")
    public void notificarControlador(){

    }

    //@Schedules(value = "* * 8 ? * FRI")
    public void notificarGestao(){

    }
}
