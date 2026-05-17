import java.util.Date;


public class Usuario{
    private int idUsuario;
    private String emailLogin;
    private String hashSenha;
    private String role;
    private boolean status_conta;
    private String token_recuperacao;
    private Date data_criacao;


public Usuario(int idUsuario, String emailLogin, String hashSenha, String role, boolean status_conta, String token_recuperacao, Date data_criacao) {
    this.idUsuario = idUsuario;
    this.emailLogin = emailLogin;
    this.hashSenha = hashSenha;
    this.role = role;
    this.status_conta = status_conta;
    this.token_recuperacao = token_recuperacao;
    this.data_criacao = data_criacao;
}
}