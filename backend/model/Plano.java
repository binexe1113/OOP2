public class Plano{
    private int idPlano;
    private String nome;
    private String descricao;
    private double preco;
    private boolean status;

    public Plano(int idPlano, String nome, String descricao, double preco, boolean status) {
        this.idPlano = idPlano;
        this.nome = nome;
        this.descricao = descricao;
        this.preco = preco;
        this.status = status;
    }
    
}