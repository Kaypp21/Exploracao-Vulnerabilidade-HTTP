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

#### 🔗 Ferramentas de Indução (QR Codes)
A tabela a seguir apresenta as duas ferramentas visuais utilizadas na simulação para guiar a vítima ao servidor malicioso:

<div align="center">

| 1. QR Code de Conexão (Fase de Engano) | 2. QR Code de Validação (O Gatilho) |
| :---: | :---: |
| **Função:** Simula um acesso legítimo à rede e credibilidade. | **Função:** Redireciona a vítima ao IP do atacante (`http://192.168.137.177`). |
| <img src="https://github.com/Kaypp21/Exploracao-Vulnerabilidade-HTTP/blob/ca9e8da721803d1ed299af553e4c69c90ea04a5c/evidencias/wifi.jpg" width="200" height="200"> | <img src="https://github.com/Kaypp21/Exploracao-Vulnerabilidade-HTTP/blob/main/evidencias/site%20falso.jpg" width="200" height="200"> |

<p>
    <i>O escaneamento do código da direita é a ação crítica que inicia a captura das credenciais.</i>
</p>
</div>

1.  **O Isca:** Clonamos uma interface de "Login Wi-Fi Corporativo" (HTML/CSS).
2.  **O Gatilho:** Instruímos o usuário a "Escanear para Liberar o Acesso", direcionando-o ao IP do atacante.
3.  **A Captura:** Com a vítima acessando o servidor, utilizamos o Wireshark na interface `eth0` para gravar os dados (senha, e-mail, etc.).

## 📸 4. Evidências Visuais

### A. A Interface da Vítima
*Esta é a tela apresentada ao usuário ao escanear o QR Code:*

<div align="center">
<br>

![print_portal](https://github.com/user-attachments/assets/a27023d7-e74c-4842-b987-c28574f6eef1)

<br>
</div>

### B. A Prova do Crime (Wireshark)
*Captura do pacote HTTP POST contendo as credenciais em texto puro:*

<div align="center">
<br>

🚧 ARRASTE O PRINT DO WIRESHARK AQUI E APAGUE ESTA LINHA 🚧

<br>
</div>

📊 4. Resultados e Análise de Evidências
4.1. Dados Pessoais Interceptados (Payload)
A ausência de criptografia (TLS/SSL) no protocolo HTTP permitiu a leitura integral do payload da requisição POST. O ataque foi bem-sucedido na captura dos seguintes Dados Pessoais Identificáveis (PII):

Nome Completo: Informação crucial para fins de engenharia social e validação de identidade.

E-mail: Chave de acesso primária para redefinição de senhas e ataques futuros de phishing direcionado.

CPF/Telefone: Dado sensível que, quando combinado com nome e e-mail, permite a clonagem de identidade e acesso a serviços financeiros.

Conclusão: O experimento comprovou a vulnerabilidade do protocolo na Camada de Aplicação (L7), permitindo que um atacante obtenha PII em trânsito de forma passiva.

4.2. Prova Visual do Vazamento
Abaixo, a linha de comando (tcpdump/wireshark) que expõe o conteúdo do formulário:

(Inserir Imagem do Wireshark com a linha do POST)

🛡️ 6. Contramedidas e Mitigação (Blue Team)
Para mitigar a vulnerabilidade demonstrada e proteger a rede contra ataques semelhantes, as seguintes medidas defensivas devem ser implementadas:

1. Implementação de HTTPS (Criptografia de Transporte)
Mecanismo: Utiliza o protocolo TLS/SSL (Transport Layer Security) para estabelecer um canal seguro, criptografando os dados no cliente antes que eles deixem o dispositivo.

Efeito: Mesmo que o atacante intercepte os pacotes na rede local (o que fizemos), o conteúdo (payload) estaria ilegível (ex: x8s7d8f7...), frustrando o ataque de captura de credenciais.

2. Uso de VPN e Validação de Endpoint
Mecanismo: Ao utilizar uma VPN (Rede Privada Virtual), todo o tráfego da vítima é encapsulado em um túnel criptografado que se estende para fora da rede local.

Efeito: Impede que o atacante na rede do SoftAP leia o tráfego, pois ele é criptografado antes mesmo de chegar à interface Wi-Fi.

3. Conscientização e HSTS (Defesa de Aplicação)
Mecanismo: HSTS (HTTP Strict Transport Security) é uma política de segurança que instrui o navegador a nunca carregar a página via HTTP.

Efeito: Isso mitiga ataques de downgrade ou tentativas de redirecionamento para o nosso servidor falso, pois o navegador exibirá um erro de segurança imediato e não confiável.

<div align="center">

👨‍💻 Desenvolvido por
Kayan Paiva Pereira • [Nome Amigo 2] • [Nome Amigo 3] • [Nome Amigo 4]

Trabalho apresentado ao curso de Sistemas de Informação - Novembro/2025

</div>
