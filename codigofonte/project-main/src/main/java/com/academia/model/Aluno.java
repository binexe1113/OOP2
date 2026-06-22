package com.academia.model;

public class Aluno {
    private int idAluno;
    private String nome;
    private String cpf;
    private int idade;
    private String email;
    private String telefone;
    private Matricula matricula;
    private Treino treino;
    private Aula aula;
    private AvaliacaoFisica avaliacaoFisica;
    private Academia academia;
    private Usuario usuario;

    public Aluno() {
    }

    public Aluno(int idAluno, String nome, String cpf, int idade, String email, String telefone, Matricula matricula, Treino treino, Aula aula, AvaliacaoFisica avaliacaoFisica, Academia academia, Usuario usuario) {
        this.idAluno = idAluno;
        this.nome = nome;
        this.cpf = cpf;
        this.idade = idade;
        this.email = email;
        this.telefone = telefone;
        this.matricula = matricula;
        this.treino = treino;
        this.aula = aula;
        this.avaliacaoFisica = avaliacaoFisica;
        this.academia = academia;
        this.usuario = usuario;
    }

    public int getIdAluno() {
        return idAluno;
    }

    public void setIdAluno(int idAluno) {
        this.idAluno = idAluno;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public int getIdade() {
        return idade;
    }

    public void setIdade(int idade) {
        this.idade = idade;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public Matricula getMatricula() {
        return matricula;
    }

    public void setMatricula(Matricula matricula) {
        this.matricula = matricula;
    }

    public Treino getTreino() {
        return treino;
    }

    public void setTreino(Treino treino) {
        this.treino = treino;
    }

    public Aula getAula() {
        return aula;
    }

    public void setAula(Aula aula) {
        this.aula = aula;
    }

    public AvaliacaoFisica getAvaliacaoFisica() {
        return avaliacaoFisica;
    }

    public void setAvaliacaoFisica(AvaliacaoFisica avaliacaoFisica) {
        this.avaliacaoFisica = avaliacaoFisica;
    }

    public Academia getAcademia() {
        return academia;
    }

    public void setAcademia(Academia academia) {
        this.academia = academia;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}