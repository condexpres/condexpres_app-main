import secrets
import string
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import os
from dotenv import load_dotenv
from flask import Flask, request, jsonify  # Novas importações para a API

# Carrega as variáveis de ambiente do arquivo .env
load_dotenv() 

# --- Suas funções (quase sem alterações) ---

def gerar_token_seguro(tamanho=6):
    """Gera um token seguro com letras maiúsculas e dígitos."""
    caracteres = string.ascii_uppercase + string.digits
    return ''.join(secrets.choice(caracteres) for _ in range(tamanho))


def enviar_email(destinatario, assunto, mensagem):
    """Tenta enviar um e-mail e retorna um booleano de sucesso e uma mensagem."""
    smtp_server = 'smtp.gmail.com'
    smtp_port = 587
    remetente = "empresa.condexpres@gmail.com"

    # Busca a senha das variáveis de ambiente
    senha = os.getenv("EMAIL_APP_PASSWORD")

    if not senha:
        print("Erro: A variável de ambiente EMAIL_APP_PASSWORD não foi encontrada.")
        return False, "Erro no servidor: credenciais de e-mail não configuradas."

    msg = MIMEMultipart()
    msg['From'] = remetente
    msg['To'] = destinatario
    msg['Subject'] = assunto
    msg.attach(MIMEText(mensagem, 'plain'))

    server = None
    try:
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(remetente, senha)
        server.sendmail(remetente, destinatario, msg.as_string())
        print(f"Email enviado com sucesso para {destinatario}!")
        return True, "Email enviado com sucesso!"

    except smtplib.SMTPAuthenticationError:
        print("Erro: Falha na autenticação SMTP.")
        return False, "Erro de autenticação no servidor de e-mail."
    except Exception as e:
        print(f"Erro ao enviar e-mail: {e}")
        return False, f"Erro desconhecido ao enviar e-mail: {e}"
    finally:
        if server:
            server.quit()

# --- Criação do App Flask (A API) ---

app = Flask(__name__)

# Define a rota/endpoint da API. 
# Ela só aceitará requisições do tipo POST.
@app.route('/enviar-token', methods=['POST'])
def api_enviar_token():
    
    # 1. Pega os dados JSON que o Flutter enviou (ex: {"email": "..."})
    data = request.get_json()

    # 2. Valida se o e-mail foi enviado
    if not data or 'email' not in data:
        return jsonify({
            "status": "erro",
            "mensagem": "Nenhum email foi fornecido no corpo da requisição."
        }), 400 # 400 = Bad Request

    email_destino = data['email']
    
    # 3. Gera o token e a mensagem (sua lógica antiga)
    token_gerado = gerar_token_seguro(tamanho=6)
    assunto_do_email = "Seu Código de Verificação:"
    mensagem_do_email = f"Olá!\n\n Recebemos uma solicitação para: redefinição de senha na Condexpres.\n\n Use o código abaixo para concluir o processo:\n\n {token_gerado} \n\n Este código é válido por 10 minutos.\n\nSe você não solicitou este código, por favor, ignore este e-mail ou entre em contato com nosso suporte. Por motivos de segurança, nunca compartilhe este código com ninguém.\n\n Atenciosamente,\n\n Equipe Condexpres."

    # 4. Tenta enviar o e-mail
    sucesso, mensagem_status = enviar_email(email_destino, assunto_do_email, mensagem_do_email)

    # 5. Retorna uma resposta JSON para o Flutter
    if sucesso:
        return jsonify({
            "status": "sucesso",
            "mensagem": f"Token enviado para {email_destino}."
        }), 200 # 200 = OK
    else:
        return jsonify({
            "status": "erro",
            "mensagem": mensagem_status
        }), 500 # 500 = Internal Server Error


# --- Bloco para executar o servidor da API ---

if __name__ == '__main__':
    # host='0.0.0.0' faz o servidor ser acessível na sua rede local
    # (permitindo que seu celular ou emulador o acesse)
    # debug=True reinicia o servidor automaticamente quando você salva o arquivo
    app.run(host='0.0.0.0', port=5000, debug=True)