import java.util.Date;

public class Treino{
    private int idTreino;
    private String descricao;
    private Date dataInicio;
    private Date dataFim;
    private Professor professor;

    public Treino(int idTreino, String descricao, Date dataInicio, Date dataFim, Professor professor) {
        this.idTreino = idTreino;
        this.descricao = descricao;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.professor = professor;
        }
}