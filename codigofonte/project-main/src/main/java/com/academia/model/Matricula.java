package com.academia.model;

import java.util.Date;

public class Matricula {
    private int idMatricula;
    private Date dataInicio;
    private Date dataFim;
    private boolean status;
    private Plano plano;

    public Matricula() {
    }

    public Matricula(int idMatricula, Date dataInicio, Date dataFim, boolean status, Plano plano) {
        this.idMatricula = idMatricula;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.status = status;
        this.plano = plano;
    }

    public int getIdMatricula() {
        return idMatricula;
    }

    public void setIdMatricula(int idMatricula) {
        this.idMatricula = idMatricula;
    }

    public Date getDataInicio() {
        return dataInicio;
    }

    public void setDataInicio(Date dataInicio) {
        this.dataInicio = dataInicio;
    }

    public Date getDataFim() {
        return dataFim;
    }

    public void setDataFim(Date dataFim) {
        this.dataFim = dataFim;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Plano getPlano() {
        return plano;
    }

    public void setPlano(Plano plano) {
        this.plano = plano;
    }
}