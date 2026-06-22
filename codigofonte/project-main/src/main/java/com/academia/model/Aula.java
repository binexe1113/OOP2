package com.academia.model;

import java.sql.Time;

public class Aula {
    private int idAula;
    private String nome;
    private Time horario;
    private int duracao;
    private int capacidade;

    public Aula() {
    }

    public Aula(int idAula, String nome, Time horario, int duracao, int capacidade) {
        this.idAula = idAula;
        this.nome = nome;
        this.horario = horario;
        this.duracao = duracao;
        this.capacidade = capacidade;
    }

    public int getIdAula() {
        return idAula;
    }

    public void setIdAula(int idAula) {
        this.idAula = idAula;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Time getHorario() {
        return horario;
    }

    public void setHorario(Time horario) {
        this.horario = horario;
    }

    public int getDuracao() {
        return duracao;
    }

    public void setDuracao(int duracao) {
        this.duracao = duracao;
    }

    public int getCapacidade() {
        return capacidade;
    }

    public void setCapacidade(int capacidade) {
        this.capacidade = capacidade;
    }
}