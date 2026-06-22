package com.academia.model;

import java.util.Date;

public class AvaliacaoFisica {
    private int idAvaliacao;
    private Date data;
    private float peso;
    private float altura;
    private float percentualGordura;
    private float massaMuscular;
    private String MassaMuscular;
    private String medidas;
    private Date proximaAvaliacao;

    public AvaliacaoFisica() {
    }

    public AvaliacaoFisica(int idAvaliacao, Date data, float peso, float altura, float percentualGordura, float massaMuscular, String MassaMuscular, String medidas, Date proximaAvaliacao) {
        this.idAvaliacao = idAvaliacao;
        this.data = data;
        this.peso = peso;
        this.altura = altura;
        this.percentualGordura = percentualGordura;
        this.massaMuscular = massaMuscular;
        this.MassaMuscular = MassaMuscular;
        this.medidas = medidas;
        this.proximaAvaliacao = proximaAvaliacao;
    }

    public int getIdAvaliacao() {
        return idAvaliacao;
    }

    public void setIdAvaliacao(int idAvaliacao) {
        this.idAvaliacao = idAvaliacao;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public float getPeso() {
        return peso;
    }

    public void setPeso(float peso) {
        this.peso = peso;
    }

    public float getAltura() {
        return altura;
    }

    public void setAltura(float altura) {
        this.altura = altura;
    }

    public float getPercentualGordura() {
        return percentualGordura;
    }

    public void setPercentualGordura(float percentualGordura) {
        this.percentualGordura = percentualGordura;
    }

    public float getMassaMuscular() {
        return massaMuscular;
    }

    public void setMassaMuscular(float massaMuscular) {
        this.massaMuscular = massaMuscular;
    }

    public String getMassaMuscularString() {
        return MassaMuscular;
    }

    public void setMassaMuscularString(String MassaMuscular) {
        this.MassaMuscular = MassaMuscular;
    }

    public String getMedidas() {
        return medidas;
    }

    public void setMedidas(String medidas) {
        this.medidas = medidas;
    }

    public Date getProximaAvaliacao() {
        return proximaAvaliacao;
    }

    public void setProximaAvaliacao(Date proximaAvaliacao) {
        this.proximaAvaliacao = proximaAvaliacao;
    }
}