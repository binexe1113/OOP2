import java.util.Date;

public class AvaliacaoFisica {
    private int idAvaliacao;
    private Date data;
    private float peso;
    private float altura;
    private float percentualGordura;
    private float massaMuscular;
    private String MassaMuscular;
    private String medidas;
    private Date proximaAvaliacao;

    public AvaliacaoFisica(int idAvaliacao, Date data, float peso, float altura, float percentualGordura, float massaMuscular, String MassaMuscular, String medidas, Date proximaAvaliacao) {
        this.idAvaliacao = idAvaliacao;
        this.data = data;
        this.peso = peso;
        this.altura = altura;
        this.percentualGordura = percentualGordura;
        this.massaMuscular = massaMuscular;
        this.MassaMuscular = MassaMuscular;
        this.medidas = medidas;
        this.proximaAvaliacao = proximaAvaliacao;
    }
}