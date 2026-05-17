import java.util.Date;

public class Recepcionista extends Funcionario {
    private String turno;

    public Recepcionista(int idFuncionario, String nome, String cpf, String email, String telefone, double salario, Date dataAdmissao, Academia academia, String turno) {
        super(idFuncionario, nome, cpf, email, telefone, salario, dataAdmissao, academia);
        this.turno = turno;
    }
    

}