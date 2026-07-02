package com.academia.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private static final String HOST = "sandbox.smtp.mailtrap.io";
    private static final String PORT = "2525";
    private static final String USERNAME = "3d5b63bcc43867";
    private static final String PASSWORD = "6d4de3523f7f46";

    // Método 1: Enviar Email de Ativação
    public static void enviarEmailAtivacao(String destinatario, String token, String contextPath) throws MessagingException {
        Properties prop = new Properties();
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", HOST);
        prop.put("mail.smtp.port", PORT);

        Session session = Session.getInstance(prop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("nao-responda@academia.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
        message.setSubject("Ativação de Conta - Academia");

        // Link que redireciona para o Servlet de Ativação
        String linkAtivacao = "http://localhost:8080" + contextPath + "/api/ativar?token=" + token;
        
        String htmlContent = "<h3>Bem-vindo à nossa Academia!</h3>"
                + "<p>Para ativar sua conta e liberar o seu acesso, clique no link abaixo:</p>"
                + "<a href=\"" + linkAtivacao + "\">Ativar Minha Conta</a>";

        message.setContent(htmlContent, "text/html; charset=utf-8");
        Transport.send(message);
    }

    // Método 2: Enviar Email de Recuperação 
    public static void enviarEmailRecuperacao(String destinatario, String token, String contextPath) throws MessagingException {
        Properties prop = new Properties();
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", HOST);
        prop.put("mail.smtp.port", PORT);

        Session session = Session.getInstance(prop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("nao-responda@academia.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
        message.setSubject("Recuperação de Senha - Academia");

        // Link direcionando para a página JSP de redefinição de senha
        String linkRedefinir = "http://localhost:8080" + contextPath + "/acesso.jsp?token=" + token;
        
        String htmlContent = "<h3>Recuperação de Senha</h3>"
                + "<p>Recebemos uma solicitação de alteração de senha para sua conta.</p>"
                + "<p>Se você realizou essa solicitação, clique no link abaixo para redefinir sua senha:</p>"
                + "<a href=\"" + linkRedefinir + "\">Redefinir Minha Senha</a>"
                + "<p>Caso não tenha feito essa solicitação, ignore este e-mail.</p>";

        message.setContent(htmlContent, "text/html; charset=utf-8");
        Transport.send(message);
    }
}
