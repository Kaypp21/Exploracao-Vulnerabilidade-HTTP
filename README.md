# Exploracao-Vulnerabilidade-HTTP
# Relatório Técnico: Exploração de Vulnerabilidades em Protocolos de Aplicação (HTTP Sniffing)

**Disciplina:** Redes de Computadores II  
**Curso:** Sistemas de Informação  
**Data:** 19/11/2025  

## 1. Objetivo do Projeto
Este laboratório tem como objetivo demonstrar, em ambiente controlado, a insegurança intrínseca do protocolo **HTTP (Hypertext Transfer Protocol)** quando utilizado para tráfego de dados sensíveis sem criptografia.

O projeto visa explorar a captura de credenciais (usuário e senha) através da intercepção e análise de tráfego de rede, evidenciando a necessidade de implementação de camadas de segurança como TLS/SSL (HTTPS).

---

## 2. Topologia e Infraestrutura
Para a realização do experimento, foi configurado um ambiente virtualizado isolado:

* **Host (Máquina Física):** Windows 10/11 atuando como Provedor de Acesso (Soft AP / Hotspot Móvel).
* **Interface de Rede:** Adaptador Wireless USB Intelbras IWA 3001 (Chipset Realtek).
* **Máquina Atacante (Virtual):** Kali Linux 2024.x rodando sobre Oracle VirtualBox.
    * *Configuração de Rede:* Modo Bridge (Ponte) com o adaptador virtual do Host.
* **Vítima:** Dispositivo Móvel (Smartphone) ou Browser Desktop na mesma sub-rede lógica.
* **Ferramentas Utilizadas:**
    * **Python `http.server`:** Para hospedagem do servidor de Phishing.
    * **Wireshark/Tcpdump:** Para captura e análise de pacotes (Packet Sniffing).
    * **HTML/CSS:** Para clonagem da interface de autenticação (Engenharia Social).

---

## 3. Metodologia e Execução do Ataque

### 3.1. Análise de Restrições (Justificativa Técnica)
Inicialmente, o grupo planejou a execução de um ataque *Man-in-the-Middle* (MITM) via envenenamento de cache ARP (*ARP Spoofing*). No entanto, durante a fase de reconhecimento, identificou-se que o driver de "Hotspot Móvel" do sistema operacional Host implementa, por padrão, o recurso de **Isolamento de Cliente (Client Isolation/AP Isolation)**.

Esta medida de segurança impede a comunicação direta na Camada 2 (Enlace) entre dispositivos conectados ao mesmo SSID, mitigando ataques de ARP Spoofing e impedindo o roteamento de pacotes através da máquina atacante.

### 3.2. Adaptação do Vetor de Ataque (Phishing + Sniffing)
Para contornar a restrição de infraestrutura e cumprir o objetivo pedagógico de capturar credenciais HTTP, adotou-se um vetor de ataque baseado em **Engenharia Social e Phishing Direto em Rede Local**.

**Passo a Passo da Execução:**

1.  **Levantamento do Servidor Falso:**
    Foi desenvolvido um clone de uma página de login bancária (`index.html`) hospedado na máquina Kali Linux através do módulo HTTP do Python, escutando na porta 80:
    ```bash
    sudo python3 -m http.server 80
    ```

2.  **Indução da Vítima:**
    A vítima, conectada à rede Wi-Fi do laboratório, foi induzida a acessar o endereço IP do servidor atacante (simulando um link malicioso enviado por e-mail ou QR Code de validação de rede).

3.  **Captura de Tráfego (Sniffing):**
    Utilizando o **Wireshark** na interface `eth0` do atacante, iniciou-se a escuta passiva de todo o tráfego de entrada. Como o servidor web reside na própria máquina de captura, o bloqueio de *Client Isolation* não se aplica ao tráfego destinado legitimamente ao servidor.

4.  **Filtragem e Extração:**
    O tráfego capturado foi filtrado pelo método de requisição:
    `http.request.method == POST`

---

## 4. Resultados e Evidências

A execução do ataque foi bem-sucedida. Ao submeter o formulário na página falsa, o navegador da vítima enviou os dados via método POST.

Como o protocolo utilizado foi o **HTTP (Porta 80)**, os dados não sofreram encapsulamento criptográfico.

### Evidência 1: Interface do Site Falso
*(Insira aqui o print da sua tela de login "Banco XYZ")*

### Evidência 2: Captura Wireshark (A Prova)
O arquivo `.pcap` anexado demonstra a captura do pacote. A análise do payload `HTML Form URL Encoded` revela as credenciais em texto claro (*Cleartext*):

* **Campo `usuario`:** [Valor capturado]
* **Campo `senha`:** [Valor capturado]

*(Insira aqui o print do Wireshark com a seta apontando para a senha)*

---

## 5. Análise de Vulnerabilidade e Contramedidas

O experimento comprovou que a segurança da camada de transporte é crítica. A ausência de criptografia permite que qualquer nó intermediário (roteadores, switches ou sniffers na mesma rede de colisão) leia o conteúdo das mensagens.

### Contramedidas Recomendadas (Defesa)

1.  **Implementação de HTTPS (TLS/SSL):**
    * **Como funciona:** Utiliza certificados digitais para estabelecer um túnel criptografado entre cliente e servidor.
    * **Eficácia:** Mesmo que o atacante capture o pacote (como fizemos), o conteúdo (payload) estaria ilegível (ex: `A8f#9kL...`), protegendo a senha.

2.  **HSTS (HTTP Strict Transport Security):**
    * **Como funciona:** O servidor instrui o navegador a *nunca* aceitar conexões HTTP inseguras, forçando o redirecionamento para HTTPS automaticamente. Isso mitigaria tentativas de downgrade ou acesso a links inseguros.

3.  **Validação de Endpoint (Educação do Usuário):**
    * Verificar sempre a URL na barra de endereços. Endereços IP numéricos (ex: `192.168...`) ou domínios sem o cadeado de segurança não devem ser utilizados para inserção de credenciais.

---

## 6. Como Reproduzir este Laboratório

1.  Clone este repositório.
2.  Em uma máquina Linux (Kali/Ubuntu), navegue até a pasta do projeto.
3.  Execute o servidor:
    `sudo python3 -m http.server 80`
4.  Em outra máquina na mesma rede, acesse o IP do servidor pelo navegador.
5.  Monitore o tráfego com Wireshark ou Tcpdump.
