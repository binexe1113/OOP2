package com.academia.model;

import java.util.Date;

public class Usuario {
    private int idUsuario;
    private String emailLogin;
    private String hashSenha;
    private String role;
    private boolean status_conta;
    private String token_recuperacao;
    private Date data_criacao;

    public Usuario() {
    }

    public Usuario(int idUsuario, String emailLogin, String hashSenha, String role, boolean status_conta, String token_recuperacao, Date data_criacao) {
        this.idUsuario = idUsuario;
        this.emailLogin = emailLogin;
        this.hashSenha = hashSenha;
        this.role = role;
        this.status_conta = status_conta;
        this.token_recuperacao = token_recuperacao;
        this.data_criacao = data_criacao;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getEmailLogin() {
        return emailLogin;
    }

    public void setEmailLogin(String emailLogin) {
        this.emailLogin = emailLogin;
    }

    public String getHashSenha() {
        return hashSenha;
    }

    public void setHashSenha(String hashSenha) {
        this.hashSenha = hashSenha;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isStatus_conta() {
        return status_conta;
    }

    public void setStatus_conta(boolean status_conta) {
        this.status_conta = status_conta;
    }

    public String getToken_recuperacao() {
        return token_recuperacao;
    }

    public void setToken_recuperacao(String token_recuperacao) {
        this.token_recuperacao = token_recuperacao;
    }

    public Date getData_criacao() {
        return data_criacao;
    }

    public void setData_criacao(Date data_criacao) {
        this.data_criacao = data_criacao;
    }
}