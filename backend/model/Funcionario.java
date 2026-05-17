import java.util.Date;

public class Funcionario{

    private int idFuncionario;
    private String nome;
    private String cpf;
    private String email;
    private String telefone;
    private double salario;
    private Date dataAdmissao;
    private Academia academia;

    public Funcionario(int idFuncionario, String nome, String cpf, String email, String telefone, double salario, Date dataAdmissao, Academia academia) {
        this.idFuncionario = idFuncionario;
        this.nome = nome;
        this.cpf = cpf;
        this.email = email;
        this.telefone = telefone;
        this.salario = salario;
        this.dataAdmissao = dataAdmissao;
        this.academia = academia;
    }
}
