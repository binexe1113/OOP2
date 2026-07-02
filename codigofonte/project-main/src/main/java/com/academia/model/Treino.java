package com.academia.model;

import java.util.Date;

public class Treino {
    private int idTreino;
    private String descricao;
    private Date dataInicio;
    private Date dataFim;
    private Professor professor;

    // Construtor vazio
    public Treino() {
    }

    // Construtor completo
    public Treino(int idTreino, String descricao, Date dataInicio, Date dataFim, Professor professor) {
        this.idTreino = idTreino;
        this.descricao = descricao;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.professor = professor;
    }

    // Getters e Setters
    public int getIdTreino() {
        return idTreino;
    }

    public void setIdTreino(int idTreino) {
        this.idTreino = idTreino;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
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

    public Professor getProfessor() {
        return professor;
    }

    public void setProfessor(Professor professor) {
        this.professor = professor;
    }
}