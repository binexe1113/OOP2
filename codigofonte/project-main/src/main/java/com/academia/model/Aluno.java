public class Aluno{
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


public Aluno(int idAluno, String nome, String cpf, int idade, String email, String telefone, Matricula matricula, Treino treino, Aula aula, AvaliacaoFisica avaliacaoFisica, Academia academia) {
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
}

}