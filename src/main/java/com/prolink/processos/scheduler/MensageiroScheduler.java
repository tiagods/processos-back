package com.prolink.processos.scheduler;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.io.IOException;

import javax.annotation.PostConstruct;

import org.quartz.CronScheduleBuilder;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SimpleScheduleBuilder;
import org.quartz.Trigger;
import org.quartz.TriggerKey;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.quartz.SpringBeanJobFactory;

import com.prolink.processos.AutoWiringSpringBeanJobFactory;
import com.prolink.processos.scheduler.job.MensageiroJob;

public class MensageiroScheduler {

    Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    private ApplicationContext applicationContext;

    @PostConstruct
    public void init() {
        logger.info("Hello world from Quartz...");
    }

    @Bean
    public SpringBeanJobFactory springBeanJobFactory() {
        AutoWiringSpringBeanJobFactory jobFactory = new AutoWiringSpringBeanJobFactory();
        logger.debug("Configuring Job factory");
        jobFactory.setApplicationContext(applicationContext);
        return jobFactory;
    }

    @Bean
    public Scheduler scheduler(Trigger trigger, JobDetail job) throws SchedulerException, IOException {
        StdSchedulerFactory factory = new StdSchedulerFactory();
        factory.initialize(new ClassPathResource("quartz.properties").getInputStream());
        logger.debug("Getting a handle to the Scheduler");
        Scheduler scheduler = factory.getScheduler();
        scheduler.setJobFactory(springBeanJobFactory());
        scheduler.scheduleJob(job, trigger);
        logger.debug("Starting Scheduler threads");
        scheduler.start();
        return scheduler;
    }
    @Bean
    public JobDetail jobDetail() {
        return newJob().ofType(MensageiroJob.class).storeDurably().withIdentity(JobKey.jobKey("Qrtz_Job_Detail")).withDescription("Invoke Sample Job service...").build();
    }
    @Bean
    public Trigger trigger(JobDetail job) {
        int frequencyInSec = 3600;
        return newTrigger()
        		.forJob(job)
        		.withIdentity(TriggerKey.triggerKey("Qrtz_Trigger"))
        		.withDescription("Sample trigger")
        		//.withSchedule(CronScheduleBuilder.cronSchedule("0 0/10 * * * ?"))
        		.withSchedule(SimpleScheduleBuilder.simpleSchedule().withIntervalInSeconds(frequencyInSec).repeatForever())
        		.build();
    }
}
