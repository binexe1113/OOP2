import java.util.Date;

public class Matricula{
    private int idMatricula;
    private Date dataInicio;
    private Date dataFim;
    private boolean status;
    private Plano plano;

    public Matricula(int idMatricula, Date dataInicio, Date dataFim, boolean status, Plano plano) {
        this.idMatricula = idMatricula;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.status = status;
        this.plano = plano;
    }
}