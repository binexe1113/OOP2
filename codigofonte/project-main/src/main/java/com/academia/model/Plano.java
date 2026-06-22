package com.academia.model;

public class Plano {
    private int idPlano;
    private String nome;
    private String descricao;
    private double preco;
    private boolean status;

    public Plano() {
    }

    public Plano(int idPlano, String nome, String descricao, double preco, boolean status) {
        this.idPlano = idPlano;
        this.nome = nome;
        this.descricao = descricao;
        this.preco = preco;
        this.status = status;
    }

    public int getIdPlano() {
        return idPlano;
    }

    public void setIdPlano(int idPlano) {
        this.idPlano = idPlano;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}