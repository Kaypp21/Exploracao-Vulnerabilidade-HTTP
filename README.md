# Exploracao-Vulnerabilidade-HTTP
<div align="center">

# 🔐 PoC: Wi-Fi Credential Harvesting
### Exploração de Vulnerabilidades em Redes Wireless & Engenharia Social

![Status](https://img.shields.io/badge/Status-Finalizado-success?style=for-the-badge&logo=git)
![Tech](https://img.shields.io/badge/Tech-Python%20%7C%20Wireshark-blue?style=for-the-badge&logo=python)
![Focus](https://img.shields.io/badge/Foco-Network%20Security-red?style=for-the-badge&logo=kali-linux)

<br>

> **⚠️ AVISO LEGAL (DISCLAIMER)**
> 
> Este repositório contém documentação e códigos desenvolvidos estritamente para fins acadêmicos na disciplina de **Redes de Computadores II**. Todas as demonstrações foram realizadas em ambiente controlado (Laboratório Virtual), utilizando dados fictícios e dispositivos próprios.

</div>

---

## 📑 1. Sumário Executivo

Este projeto apresenta uma Prova de Conceito (PoC) demonstrando a **insegurança do protocolo HTTP** em redes públicas. O experimento simula um ataque de *Rogue Access Point* (Ponto de Acesso Malicioso) combinado com Engenharia Social para capturar credenciais de usuários em texto claro (*Cleartext*).

### 🎯 Objetivos do Projeto
- [x] Criar um ambiente controlado de ataque Wireless.
- [x] Demonstrar a interceptação de dados sem criptografia (TLS/SSL).
- [x] Analisar o tráfego de rede (`.pcap`) com Wireshark.
- [x] Desenvolver medidas de mitigação (Defesa).

---

## 🏗️ 2. Arquitetura e Topologia

O laboratório foi configurado utilizando uma abordagem híbrida para contornar restrições de hardware físico.

| Componente | Especificação | Função no Ataque |
| :--- | :--- | :--- |
| **🖥️ Host Físico** | Windows 10/11 + Adaptador Intelbras | **Infraestrutura:** Provedor de Acesso (Hotspot) |
| **🏴‍☠️ Atacante** | Kali Linux (VirtualBox Bridge) | **Servidor:** Hospedagem do Phishing + Sniffer |
| **📱 Vítima** | Smartphone Android (S23 Ultra) | **Cliente:** Conectado à rede maliciosa |

---

## ⚙️ 3. Metodologia: O Desafio e a Solução

### 🔴 O Problema (Restrição de Infraestrutura)
O plano original consistia em um ataque *Man-in-the-Middle* via **ARP Spoofing**. Contudo, identificamos que o driver de Hotspot do Windows implementa nativamente o **Isolamento de Cliente (Client Isolation)**.
> *Isso impede que dispositivos na mesma rede Wi-Fi troquem pacotes diretamente, bloqueando a interceptação tradicional.*

### 🟢 A Solução (Engenharia Social)
Para contornar o bloqueio, alteramos o vetor de ataque para **Phishing Assistido**:

1.  **O Isca:** Clonamos uma interface de "Login Wi-Fi Corporativo" (HTML/CSS).
2.  **O Gatilho:** Utilizamos **QR Codes** físicos instruindo a vítima a *"Escanear para Liberar o Acesso"*. O link aponta diretamente para o IP do atacante.
3.  **A Captura:** Com a vítima acessando o servidor do atacante, utilizamos o Wireshark na interface `eth0` para gravar os dados.

---

## 📸 4. Evidências Visuais

### A. A Interface da Vítima
*Esta é a tela apresentada ao usuário ao escanear o QR Code:*

<div align="center">
<br>

🚧 ARRASTE O PRINT DO SITE FALSO AQUI E APAGUE ESTA LINHA 🚧

<br>
</div>

### B. A Prova do Crime (Wireshark)
*Captura do pacote HTTP POST contendo as credenciais em texto puro:*

<div align="center">
<br>

🚧 ARRASTE O PRINT DO WIRESHARK AQUI E APAGUE ESTA LINHA 🚧

<br>
</div>

---

## 📊 5. Análise dos Dados

Como não há túnel criptografado (HTTPS), os dados extraídos do arquivo `.pcap` são totalmente legíveis:

```yaml
[+] DADOS INTERCEPTADOS:
------------------------
Nome:     Kayan Paiva
Email:    usuario@exemplo.com
CPF:      123.456.789-00
🔒 Nota de Privacidade: O arquivo .pcap anexado foi sanitizado via tcprewrite para mascarar IPs e MACs reais da infraestrutura.🛡️ 6. Contramedidas (Como se proteger)VulnerabilidadeSolução TécnicaFalta de CriptografiaImplementação de HTTPS (HSTS) obrigatório.Phishing LocalValidação de Endpoint. Nunca inserir dados em IPs numéricos.Sniffing em Wi-FiUso de VPN para encapsular o tráfego em túnel seguro.🚀 7. Como ReproduzirBash# 1. Clone o repositório
git clone [https://github.com/SEU-USUARIO/NOME-DO-REPO.git](https://github.com/SEU-USUARIO/NOME-DO-REPO.git)

# 2. Entre na pasta
cd NOME-DO-REPO

# 3. Execute o servidor (Requer Python 3)
chmod +x scripts/run_server.sh
sudo ./scripts/run_server.sh

-----

### 🎨 O que você precisa fazer agora (Checklist Final):

1.  **Copie** o código acima e cole no seu GitHub.
2.  **Substitua** onde diz `[Nome Amigo]` pelos nomes reais.
3.  **Substitua** onde diz `SEU-USUARIO` pelo seu link do Git.
4.  **O Mais Importante:**
      * Apague a frase `🚧 ARRASTE O PRINT...`
      * **Arraste a foto** do seu computador para aquele espaço em branco.

👨‍💻 Autores
Kayan Paiva Pereira

[Nome do Amigo 2]

[Nome do Amigo 3]

[Nome do Amigo 4]

Trabalho apresentado ao curso de Sistemas de Informação - Novembro/2025.
