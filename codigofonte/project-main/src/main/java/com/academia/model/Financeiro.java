package com.academia.model;

import java.util.Date;

public class Financeiro {
    private int idFinanceiro;
    private int idPagamento;
    private Date dataPagamento;
    private double valorPagamento;
    private String metodoPagamento;
    private boolean status;

    public Financeiro() {
    }

    public Financeiro(int idFinanceiro, int idPagamento, Date dataPagamento, double valorPagamento, String metodoPagamento, boolean status) {
        this.idFinanceiro = idFinanceiro;
        this.idPagamento = idPagamento;
        this.dataPagamento = dataPagamento;
        this.valorPagamento = valorPagamento;
        this.metodoPagamento = metodoPagamento;
        this.status = status;
    }

    public int getIdFinanceiro() {
        return idFinanceiro;
    }

    public void setIdFinanceiro(int idFinanceiro) {
        this.idFinanceiro = idFinanceiro;
    }

    public int getIdPagamento() {
        return idPagamento;
    }

    public void setIdPagamento(int idPagamento) {
        this.idPagamento = idPagamento;
    }

    public Date getDataPagamento() {
        return dataPagamento;
    }

    public void setDataPagamento(Date dataPagamento) {
        this.dataPagamento = dataPagamento;
    }

    public double getValorPagamento() {
        return valorPagamento;
    }

    public void setValorPagamento(double valorPagamento) {
        this.valorPagamento = valorPagamento;
    }

    public String getMetodoPagamento() {
        return metodoPagamento;
    }

    public void setMetodoPagamento(String metodoPagamento) {
        this.metodoPagamento = metodoPagamento;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}