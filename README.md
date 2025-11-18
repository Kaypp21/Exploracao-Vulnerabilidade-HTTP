# Exploracao-Vulnerabilidade-HTTP
# 🛡️ PoC: Exploração de Vulnerabilidades em Redes Wireless (Captive Portal Phishing)

**Instituição:** [Nome da Sua Faculdade/Universidade]  
**Curso:** Sistemas de Informação  
**Disciplina:** Redes de Computadores II  
**Data de Entrega:** 19/11/2025  

---

## 📑 Sumário Executivo
Este projeto consiste na implementação de uma Prova de Conceito (PoC) para demonstrar vulnerabilidades críticas em redes Wi-Fi públicas e protocolos de aplicação não criptografados (HTTP). 

O objetivo central foi simular um cenário de **Rogue Access Point (Ponto de Acesso Falso)** combinado com técnicas de **Engenharia Social**, visando a captura de credenciais e dados pessoais (PII) de usuários desavisados.

---

## ⚠️ Aviso Legal (Disclaimer)
Este projeto foi desenvolvido estritamente para **fins acadêmicos e educacionais**. Todas as simulações foram realizadas em ambiente controlado, utilizando dispositivos de propriedade dos membros do grupo e dados fictícios (*mock data*). O grupo não se responsabiliza pelo uso indevido das ferramentas ou técnicas aqui descritas.

---

## 🛠️ Topologia e Ambiente de Testes

Para a execução do laboratório, foi configurada a seguinte infraestrutura:

* **Host (Infraestrutura de Rede):**
    * Sistema Operacional: Windows 10/11.
    * Hardware de Rede: Adaptador Wireless USB (Intelbras IWA 3001).
    * Função: Provedor de acesso via SoftAP (Hotspot Móvel).
    
* **Máquina Atacante (Virtual Machine):**
    * Sistema Operacional: Kali Linux (Rolling Release).
    * Virtualização: Oracle VirtualBox (Rede em modo *Bridge*).
    * Endereçamento IP: Estático na sub-rede `192.168.137.0/24`.

* **Dispositivo Vítima:**
    * Hardware: Smartphone Android 
    * Conexão: Wi-Fi (WLAN).

---

## ⚙️ Metodologia do Ataque

### 1. Análise de Restrições Técnicas
Inicialmente, planejou-se a execução de ataques de camada 2 (Enlace), especificamente *ARP Spoofing*, para realizar um ataque *Man-in-the-Middle* (MITM). 

Contudo, identificou-se que o driver de Hotspot do Windows implementa nativamente o recurso de **Isolamento de Cliente (Client Isolation)**, impedindo o roteamento de tráfego entre clientes conectados ao mesmo SSID. Isso inviabilizou o redirecionamento automático via envenenamento de cache ARP.

### 2. Adaptação Estratégica (O Vetor de Ataque)
Para contornar a restrição de hardware e cumprir o objetivo de capturar credenciais HTTP, adotou-se uma abordagem híbrida de **Engenharia Social + Phishing Local**:

1.  **Clonagem de Interface (Front-End):**
    Desenvolvemos uma página HTML/CSS responsiva simulando um "Portal de Autenticação Wi-Fi Corporativo", solicitando Nome, E-mail e CPF/Telefone para "liberar a navegação".

2.  **Hospedagem do Payload:**
    Utilizamos o módulo `http.server` do Python para hospedar o portal falso na porta 80 da máquina atacante (Kali Linux).

3.  **Indução via QR Code (O Gatilho):**
    Para simular a experiência de um *Walled Garden* (Portal Cativo), geramos QR Codes distribuídos fisicamente no ambiente, instruindo a vítima a escanear o código para validar seu acesso à rede. O QR Code contém o link direto para o servidor malicioso (`http://IP_DO_ATACANTE`).

4.  **Captura Passiva (Sniffing):**
    Com a vítima acessando o servidor hospedado na própria máquina atacante, utilizamos o **Wireshark** escutando a interface `eth0` para interceptar as requisições HTTP POST.

---

## 📊 Resultados e Evidências

A execução foi bem-sucedida. Ao preencher o formulário falso, o navegador da vítima enviou os dados em texto plano (*Cleartext*), comprovando a ausência de criptografia na camada de transporte.

### Evidência 1: Interface Maliciosa
Abaixo, a interface apresentada à vítima no momento da conexão:

![Imagem do WhatsApp de 2025-11-18 à(s) 13 17 31_b168591b](https://github.com/user-attachments/assets/7f9ee375-421f-40ff-8385-3a8a97262664)


### Evidência 2: Análise de Pacotes (.pcap)
A captura de tráfego revela o conteúdo do pacote HTTP POST. Os campos sensíveis estão plenamente visíveis no payload `HTML Form URL Encoded`:

* **Nome:** `[Dado Capturado]`
* **Email:** `[Dado Capturado]`
* **CPF:** `[Dado Capturado]`

*(Arraste aqui o print do Wireshark mostrando os dados)*

> **Nota de Privacidade:** O arquivo `.pcap` anexado a este repositório foi sanitizado. Dados reais de infraestrutura (MAC/IP) foram anonimizados utilizando a ferramenta `tcprewrite` para conformidade com as boas práticas de segurança.

---

## 🛡️ Contramedidas e Recomendações

Com base na vulnerabilidade explorada, recomendamos as seguintes mitigações:

1.  **Uso Obrigatório de HTTPS (TLS/SSL):**
    A implementação de certificados SSL no servidor web garantiria que, mesmo em caso de interceptação ou acesso a sites falsos, o conteúdo dos dados estaria ilegível para o atacante.

2.  **Educação em Segurança (Security Awareness):**
    Treinar usuários para não escanear QR Codes de fontes desconhecidas e verificar a URL na barra de endereços. Endereços IP numéricos (ex: `192.168...`) em vez de domínios (ex: `wifi.empresa.com`) são fortes indícios de ataque.

3.  **Uso de VPN (Rede Privada Virtual):**
    Ao utilizar redes Wi-Fi públicas, o uso de VPN cria um túnel criptografado, impedindo a leitura de dados por terceiros na rede local.

---

## 🚀 Como Reproduzir

1.  Clone este repositório:
    ```bash
    git clone [https://github.com/](https://github.com/)[SEU_USUARIO]/Exploracao-Vulnerabilidade-HTTP.git
    ```
2.  Acesse o diretório do projeto:
    ```bash
    cd Exploracao-Vulnerabilidade-HTTP
    ```
3.  Execute o script de inicialização do servidor (no Kali Linux):
    ```bash
    chmod +x iniciar_servidor.sh
    ./iniciar_servidor.sh
    ```
4.  Em um dispositivo na mesma rede, acesse o IP da máquina atacante e monitore o tráfego.

---

**Autores:**
* Kayan Paiva Pereira
* [Nome do Amigo 2]
* [Nome do Amigo 3]
