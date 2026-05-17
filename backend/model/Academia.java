public class Academia {
    private int idAcademia;
    private String nome;
    private String endereco;
    private String telefone;
    private String email;
    private Financeiro financeiro;



public Academia(int idAcademia, String nome, String endereco, String telefone, String email, Financeiro financeiro) {
    this.idAcademia = idAcademia;
    this.nome = nome;
    this.endereco = endereco;
    this.telefone = telefone;
    this.email = email;
    this.financeiro = financeiro;   
}
}