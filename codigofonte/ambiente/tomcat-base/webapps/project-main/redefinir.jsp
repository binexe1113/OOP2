<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redefinir Senha - Academia</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h2 class="text-2xl font-bold mb-6 text-gray-800 text-center">Nova Senha</h2>
        <p class="text-sm text-gray-600 mb-6 text-center">Por favor, escolha uma palavra-passe forte para proteger a sua conta.</p>

        <form id="formRedefinir" action="RedefinirSenhaController" method="POST" class="space-y-4">
            <input type="hidden" name="token" value="${param.token}">

            <div>
                <label for="password" class="block text-sm font-medium text-gray-700">Nova Palavra-passe</label>
                <input type="password" id="password" name="password" required 
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div>
                <label for="confirmPassword" class="block text-sm font-medium text-gray-700">Confirmar Nova Palavra-passe</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required 
                       class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
            </div>

            <button type="submit" 
                    class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition duration-200 font-semibold">
                Atualizar Palavra-passe
            </button>
        </form>

        <div id="feedback" class="mt-4 text-sm text-center hidden"></div>
    </div>

    <script>
        document.getElementById('formRedefinir').addEventListener('submit', function(e) {
            const pass = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            const feedback = document.getElementById('feedback');

            if (pass !== confirm) {
                e.preventDefault();
                feedback.textContent = "As palavras-passe não coincidem.";
                feedback.classList.remove('hidden', 'text-green-600');
                feedback.classList.add('text-red-600');
            }
        });
    </script>
</body>
</html>