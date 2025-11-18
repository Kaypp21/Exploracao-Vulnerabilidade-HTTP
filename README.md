# Exploracao-Vulnerabilidade-HTTP
# 🛡️ PoC: Vulnerability Assessment & Credential Harvesting em Redes Wireless

![Status](https://img.shields.io/badge/Status-Concluído-success)
![Language](https://img.shields.io/badge/Linguagem-HTML%2FPython-blue)
![Focus](https://img.shields.io/badge/Foco-Network%20Security-red)
![License](https://img.shields.io/badge/License-Academic-lightgrey)

> **⚠️ AVISO LEGAL (DISCLAIMER)**
> Este repositório contém documentação e códigos desenvolvidos estritamente para fins acadêmicos na disciplina de **Redes de Computadores II**. Todas as demonstrações foram realizadas em ambiente controlado (Laboratório Virtual), utilizando dados fictícios (*mock data*) e dispositivos de propriedade dos autores. A interceptação de tráfego de terceiros sem consentimento é ilegal.

---

## 📑 Sumário Executivo
Este projeto apresenta uma Prova de Conceito (PoC) sobre a insegurança do protocolo **HTTP** em redes Wi-Fi públicas. O experimento simula um **Rogue Access Point** (Ponto de Acesso Malicioso) utilizando técnicas de Engenharia Social para contornar proteções de infraestrutura e capturar credenciais (PII) em texto claro (*Cleartext*).

### 🎯 Objetivos
1.  Implementar um ambiente controlado de ataque em rede sem fio.
2.  Demonstrar a vulnerabilidade de interceptação de dados em aplicações web sem criptografia (TLS/SSL).
3.  Analisar pacotes de rede (`.pcap`) para evidenciar o vazamento de informações.
4.  Propor medidas defensivas e contramedidas técnicas.

---

## 🏗️ Arquitetura e Topologia

A infraestrutura foi desenhada para operar em um cenário de restrição de hardware, adotando uma abordagem híbrida de virtualização.

| Componente | Especificação Técnica | Função no Laboratório |
| :--- | :--- | :--- |
| **Host Físico** | Windows 10/11 + Adaptador Intelbras IWA 3001 | Provedor de Acesso (SoftAP/Hotspot Móvel) |
| **Atacante** | Kali Linux (VirtualBox - Modo Bridge) | Servidor Web (Python) + Sniffer (Wireshark) |
| **Vítima** | Smartphone Android (Samsung S23 Ultra) | Cliente Wireless conectado ao Hotspot |

### 📂 Estrutura do Repositório
```bash
├── 📂 src/
│   └── index.html           # Front-end do Portal Falso (Clonagem de Interface)
├── 📂 scripts/
│   └── run_server.sh        # Script de automação do servidor Python (Porta 80)
├── 📂 evidencias/
│   ├── captura_anonima.pcap # Arquivo de prova (Sanitizado com tcprewrite)
│   ├── print_portal.jpg     # Evidência visual da tela de login falsa
│   └── print_wireshark.jpg  # Evidência da captura da senha
└── README.md                # Documentação Técnica do Projeto
⚙️ Metodologia de Execução
1. Análise de Restrições (Justificativa Técnica)
O plano inicial previa a execução de um ataque Man-in-the-Middle (MITM) via ARP Spoofing. Contudo, durante a fase de reconhecimento, identificou-se que o driver de Hotspot do Windows implementa nativamente o recurso de Isolamento de Cliente (Client Isolation).

Esta medida de segurança impede o roteamento de quadros de camada 2 entre clientes conectados ao mesmo SSID, mitigando ataques de envenenamento de cache ARP.

2. Adaptação do Vetor de Ataque
Para contornar a restrição de isolamento e cumprir o objetivo pedagógico, o grupo adotou uma estratégia de Engenharia Social Assistida:

Deploy do Payload: Hospedagem de uma página de login falsa (simulando um portal de "Wi-Fi Visitante") na porta 80 da máquina atacante.

Indução (Trigger): Utilização de QR Codes físicos instruindo a vítima a "Escanear para Validar o Acesso". O QR Code aponta diretamente para o IP do atacante na rede local.

Sniffing Passivo: Monitoramento da interface de rede eth0 para capturar as requisições HTTP POST enviadas pela vítima ao servidor do atacante.

📊 Resultados e Análise de Evidências
A prova de conceito foi bem-sucedida. A ausência de criptografia no protocolo HTTP permitiu a leitura integral dos dados submetidos pelo usuário.

📸 Evidência 1: Interface da Vítima
Abaixo, a interface apresentada ao usuário no momento da conexão, solicitando dados pessoais para "liberação" da rede:

(Simulação de Portal Corporativo com design responsivo)

🕵️ Evidência 2: Análise de Pacotes (.pcap)
A análise do tráfego no Wireshark revela o payload da requisição POST. Como não há túnel TLS (HTTPS), os campos são visíveis em ASCII:

Dados Extraídos (Cleartext):

nome: [DADO CAPTURADO]

email: [DADO CAPTURADO]

cpf/tel: [DADO CAPTURADO]

Nota de Privacidade e LGPD: O arquivo .pcap anexado a este repositório foi submetido a um processo de anonimização (sanitização) utilizando a ferramenta tcprewrite. Endereços MAC e IPs reais da infraestrutura foram mascarados e os dados de credenciais são fictícios.

🛡️ Contramedidas e Mitigação
Com base na vulnerabilidade explorada, recomendamos as seguintes defesas:

HTTPS Obrigatório (HSTS):

Servidores web devem implementar HSTS (HTTP Strict Transport Security) para forçar conexões criptografadas. Com HTTPS, os dados capturados no Wireshark estariam ilegíveis.

Validação de Endpoint:

Usuários devem ser treinados para verificar a URL. Acessar IPs numéricos (ex: 192.168...) em vez de domínios validados é um forte indício de ataque.

VPN (Rede Privada Virtual):

O uso de VPN em redes públicas cria um túnel criptografado, protegendo os dados mesmo se a rede local estiver comprometida.

🚀 Como Reproduzir este Laboratório
Clone o repositório:

Bash

git clone [https://github.com/](https://github.com/)[SEU-USUARIO]/Exploracao-Vulnerabilidade-HTTP.git
Acesse o diretório:

Bash

cd Exploracao-Vulnerabilidade-HTTP
Execute o servidor (No Kali Linux):

Bash

chmod +x scripts/run_server.sh
./scripts/run_server.sh
Acesse via Cliente: Conecte outro dispositivo na mesma rede e acesse o IP da máquina atacante via navegador.

👨‍💻 Autores
Kayan Paiva Pereira

[Nome do Amigo 2]

[Nome do Amigo 3]

[Nome do Amigo 4]

Trabalho apresentado ao curso de Sistemas de Informação - Novembro/2025.
