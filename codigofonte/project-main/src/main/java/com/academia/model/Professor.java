public class Professor {
    private int idProfessor;
    private String nome;
    private String cpf;
    private String email;
    private String telefone;
    private double valorHoraAula;

    public Professor(int idProfessor, String nome, String cpf, String email, String telefone, double valorHoraAula) {
        this.idProfessor = idProfessor;
        this.nome = nome;
        this.cpf = cpf;
        this.email = email;
        this.telefone = telefone;
        this.valorHoraAula = valorHoraAula;
    }
}