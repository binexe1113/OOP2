import java.util.Date;

public class Financeiro{
    private int idFinanceiro;
    private int idPagamento;
    private Date dataPagamento;
    private double valorPagamento;
    private String metodoPagamento;
    private boolean status;

    public Financeiro(int idFinanceiro, int idPagamento, Date dataPagamento, double valorPagamento, String metodoPagamento, boolean status) {
        this.idFinanceiro = idFinanceiro;
        this.idPagamento = idPagamento;
        this.dataPagamento = dataPagamento;
        this.valorPagamento = valorPagamento;
        this.metodoPagamento = metodoPagamento;
        this.status = status;
    }
}