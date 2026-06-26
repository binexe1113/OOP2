import java.util.Date;
import java.sql.Time;

public class Aula{
    private int idAula;
    private String nome;
    private Time horario;
    private int duracao;
    private int capacidade;
    
    public Aula(int idAula, String nome, Time horario, int duracao, int capacidade) {
        this.idAula = idAula;
        this.nome = nome;
        this.horario = horario;
        this.duracao = duracao;
        this.capacidade = capacidade;
    }
}