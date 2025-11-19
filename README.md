# 🔐 Exploração de Vulnerabilidades em Redes Wireless com Foco em HTTP Inseguro

<div align="center">

⚠️ **AVISO LEGAL (DISCLAIMER)**  
Este repositório foi produzido exclusivamente para fins acadêmicos na disciplina de **Redes de Computadores II**.  
Todos os testes foram realizados em ambiente isolado, com dados fictícios e consentidos, seguindo as orientações de segurança do curso.

</div>

---

## 📑 1. Sumário Executivo

Este projeto apresenta uma **Prova de Conceito (PoC)** sobre a exploração de vulnerabilidades em redes Wi-Fi públicas, demonstrando o impacto do uso do protocolo **HTTP sem criptografia**.  
O cenário simula um **Rogue Access Point + Engenharia Social**, demonstrando como credenciais podem ser capturadas em **texto claro** (cleartext) por meio de um simples formulário não criptografado.

### 🎯 Objetivos

- Criar um ambiente controlado de rede wireless vulnerável.  
- Demonstrar a interceptação de dados transmitidos via HTTP.  
- Registrar e analisar pacotes em um arquivo **PCAP** (Wireshark).  
- Apresentar contramedidas de segurança.  
- Disponibilizar documentação completa e reprodutível.  

---

## 🏗️ 2. Arquitetura e Topologia

O ambiente foi montado utilizando uma **topologia híbrida**, devido a limitações do hotspot nativo do Windows.

### **Componentes Utilizados**

| Componente               | Especificação         | Função                                           |
|-------------------------|------------------------|--------------------------------------------------|
| Host Físico (Windows)  | Hotspot Integrado      | Provê rede Wi-Fi para o teste                   |
| Máquina Atacante (Kali) | VM em modo Bridge      | Hospeda o servidor malicioso e captura tráfego  |
| Vítima                  | Smartphone/PC          | Acessa o portal falso e envia dados             |

---

## ⚙️ 3. Metodologia

### **3.1 Limitações Identificadas**

O plano original previa um ataque **Man-in-the-Middle (MitM)** via **ARP Spoofing**, mas o hotspot nativo do Windows habilita automaticamente:

- **Client Isolation**  
- Bloqueio de comunicação direta entre clientes  

Isso impede o envio de *respostas ARP falsas* ao alvo.

### **3.2 Adaptação da Estratégia (Engenharia Social)**

Optou-se pela utilização de um **QR Code malicioso** para induzir a vítima a acessar um portal falso hospedado no atacante.

### QR Codes Criados

<div align="center">

| QR Code de Acesso | QR Code de "Validação" |
|------------------|-------------------------|
| Simula credibilidade | Redireciona para o atacante |
| <img src="evidencias/wifi.jpg" width="200"> | <img src="evidencias/Site falso.jpg" width="200"> |

</div>

---

## 🔄 4. Ciclo de Vida do Ataque

```mermaid
sequenceDiagram
    participant V as Vítima
    participant R as Roteador (Hotspot)
    participant A as Atacante (Kali)

    Note over V, R: Estágio 1 - Reconhecimento
    V->>R: Conexão ao Wi-Fi
    V->>A: Broadcast ARP/mDNS (captura passiva)

    Note over V, A: Estágio 2 - Engenharia Social
    V->>V: Escaneia QR Code
    V->>A: Acessa portal falso (HTTP)

    Note over V, A: Estágio 3 - Exfiltração
    V->>A: Envio do formulário (HTTP POST)
    A->>A: Registro dos dados em cleartext (PCAP)
```

---

## 📝 5. Análise Técnica

### 📡 **Estágio 1: Reconhecimento Passivo**

Ao se conectar ao Wi-Fi, o dispositivo emite:

- ARP  
- mDNS  
- DHCP  

O atacante obtém:

- **MAC Address**  
- **Endereço IP**  
- **Hostname (quando disponível)**  

---

### 🔗 **Estágio 2: Engenharia Social**

O QR Code age como **substituto de captive portal**, redirecionando a vítima para um servidor HTTP na máquina atacante.

---

### 🔓 **Estágio 3: Exfiltração de Dados**

O formulário falso envia:

```
HTTP POST /login
Content-Type: application/x-www-form-urlencoded
```

Como **não há TLS**, todo o conteúdo aparece no Wireshark em **texto legível**.

---

## 📸 6. Evidências

### **6.1 Portal Falso exibido à vítima**
<div align="center">
<img src="evidencias/print_portal.jpg" width="450">
</div>

### **6.2 Captura do POST no Wireshark**
<div align="center">
<img src="evidencias/wireshark1 .jpg" width="700">
</div>

---

## 📊 7. Classificação dos Dados Comprometidos

| Campo     | Tipo de Dado           | Risco    | Impacto                                        |
|-----------|-------------------------|----------|------------------------------------------------|
| Nome      | Identificação           | Médio    | Perfilamento da vítima                         |
| E-mail    | Credencial de acesso    | Alto     | Phishing e roubo de identidade                 |
| Telefone  | PII sensível            | Crítico  | Golpes via engenharia social em mensageiros    |

**Diagnóstico:**  
A ausência de criptografia expõe completamente a confidencialidade dos dados enviados pela vítima.

---

## 🛡️ 8. Contramedidas e Recomendações

### 🔐 **1. Camada de Aplicação — HTTPS/TLS**

- Utilizar certificados válidos  
- Impede leitura dos dados por sniffers locais  

---

### 🌐 **2. Camada de Rede — WPA3 + Defesa contra Rogue AP**

- Adotar **WPA3-Personal** ou **WPA3-Enterprise**  
- Ambientes corporativos → **802.1X + RADIUS**  
- Utilizar **WIDS/WIPS** para identificar APs falsos  

---

### 🛡️ **3. Camada de Navegador — HSTS**

- Obriga o navegador a comunicar-se apenas por **HTTPS**  

---

### 🎓 **4. Camada Humana — Conscientização**

- Verificar ícone de cadeado antes de inserir dados  
- Evitar escanear QR Codes desconhecidos  

---

## 🛠️ 9. Guia Completo de Reprodução

### **1. Requisitos**

- Windows com hotspot ativo  
- Kali Linux em modo Bridge  
- Dispositivo vítima conectado ao SSID de testes  

---

### **2. Servidor Malicioso**

```bash
git clone https://github.com/Kaypp21/Exploracao-Vulnerabilidade-HTTP.git
cd Exploracao-Vulnerabilidade-HTTP
sudo python3 -m http.server 80 --directory src/
```

---

### **3. Captura de Pacotes**

- Abrir o Wireshark  
- Selecionar a interface **eth0**  
- Aplicar o filtro:

```text
http.request.method == POST
```

---

### **4. Execução**

- A vítima escaneia o QR Code  
- Acessa o portal falso  
- Preenche o formulário  
- Os dados aparecem no Wireshark em tempo real  

---

<div align="center">

👨‍💻 **Desenvolvido por:**  
**Kayan Paiva Pereira • Enzo José Oliveira Pereira • Livya Silva de Carvalho • Nathan Massamb Belinato**

_Trabalho apresentado ao curso de Sistemas de Informação — Novembro/2025_

</div>
