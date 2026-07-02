package com.academia.model;

import java.util.Date;

public class CheckIn {
    private int idCheckIn;
    private Date dataHora;
    private Aluno aluno;
    private Academia academia;
    private Treino treino;

    public int getIdCheckIn() {
        return idCheckIn;
    }

    public void setIdCheckIn(int idCheckIn) {
        this.idCheckIn = idCheckIn;
    }

    public Date getDataHora() {
        return dataHora;
    }

    public void setDataHora(Date dataHora) {
        this.dataHora = dataHora;
    }

    public Aluno getAluno() {
        return aluno;
    }

    public void setAluno(Aluno aluno) {
        this.aluno = aluno;
    }

    public Academia getAcademia() {
        return academia;
    }

    public void setAcademia(Academia academia) {
        this.academia = academia;
    }

    public Treino getTreino() {
        return treino;
    }

    public void setTreino(Treino treino) {
        this.treino = treino;
    }
}
