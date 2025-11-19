🔐 Exploração de Vulnerabilidades em Redes Wireless com Foco em HTTP Inseguro
<div align="center">






<br>

⚠️ AVISO LEGAL (DISCLAIMER)
Este repositório foi produzido exclusivamente para fins acadêmicos na disciplina de Redes de Computadores II.
Todos os testes foram realizados em ambiente isolado, com dados fictícios e consentidos, seguindo as orientações de segurança do curso.

</div>
📑 1. Sumário Executivo

Este projeto apresenta uma Prova de Conceito (PoC) sobre a exploração de vulnerabilidades em redes Wi-Fi públicas e o impacto do uso do protocolo HTTP sem criptografia.
O cenário simulado envolve um Rogue Access Point associado a uma técnica de Engenharia Social, com o objetivo de demonstrar a captura de credenciais enviadas em cleartext.

🎯 Objetivos

Criar um ambiente controlado de rede wireless vulnerável.

Demonstrar a interceptação de dados transmitidos via HTTP.

Registrar e analisar pacotes em um arquivo PCAP usando Wireshark.

Apresentar contramedidas de segurança.

Disponibilizar documentação completa e reprodutível.

🏗️ 2. Arquitetura e Topologia

O ambiente foi construído com uma topologia híbrida devido a limitações de hardware físico:

Componente	Especificação	Função
Host Físico (Windows 10/11)	Hotspot Integrado	Provê rede Wi-Fi para o teste
Atacante (Kali Linux)	VM em modo Bridge	Hospeda o servidor malicioso e realiza o sniffing
Vítima	Smartphone/PC	Acessa o portal falso e envia dados
⚙️ 3. Metodologia
3.1 Limitações Identificadas

O plano original considerava um ataque Man-in-the-Middle (MitM) por ARP Spoofing.
Porém, o Hotspot nativo do Windows aplica automaticamente Client Isolation, impedindo comunicação direta entre os dispositivos conectados.

Isso inviabiliza o spoofing ARP, pois a vítima não recebe respostas ARP falsas provenientes do atacante.

3.2 Adaptação da Estratégia (Engenharia Social)

Diante da impossibilidade de manipular o tráfego interno, adotou-se uma abordagem baseada no fator humano.

Vetor Utilizado: QR Code Malicioso

Foram criados dois QR Codes com funções distintas:

<div align="center">
QR Code de Acesso	QR Code de Validação
Simula credibilidade de acesso ao Wi-Fi	Redireciona ao IP do atacante (http://192.168.137.xxx)
<img src="evidencias/wifi.jpg" width="200">	<img src="evidencias/site_falso.jpg" width="200">
</div>
🔄 4. Ciclo de Vida do Ataque
sequenceDiagram
    participant V as Vítima
    participant R as Roteador (Hotspot)
    participant A as Atacante (Kali)

    Note over V, R: Estágio 1 - Reconhecimento
    V->>R: Conexão ao Wi-Fi
    V->>A: Broadcast ARP/mDNS (captura passiva)

    Note over V, A: Estágio 2 - Engenharia Social
    V->>V: Escaneia QR Code
    V->>A: Acessa o portal falso via HTTP

    Note over V, A: Estágio 3 - Exfiltração
    V->>A: Envio de formulário (HTTP POST)
    A->>A: Registro do pacote e dos dados em texto claro

📝 5. Análise Técnica das Fases
📡 Estágio 1: Reconhecimento Passivo

Ao entrar no Wi-Fi, o dispositivo emite pacotes ARP e mDNS para se anunciar na rede.
Com isso, o atacante descobre:

MAC Address (camada 2)

Endereço IP (camada 3)

Essas informações permitem rastreabilidade e mapeamento da vítima.

🔗 Estágio 2: Engenharia Social

Sem redirecionamento automático (como um captive portal real), o QR Code funciona como um “atalho físico” para o servidor web malicioso.

🔓 Estágio 3: Exfiltração de Dados

A vítima preenche um formulário acreditando ser um cadastro padrão da rede.

O envio ocorre com:

HTTP POST /login
Content-Type: application/x-www-form-urlencoded


Como não há TLS, o conteúdo aparece completamente legível no Wireshark.

📸 6. Evidências
6.1 Portal Falso exibido à vítima
<div align="center"> <img src="evidencias/print_portal.jpg" width="450"> </div>
6.2 Captura do POST no Wireshark
<div align="center"> <img src="evidencias/wireshark1.jpg" width="700"> </div>
📊 7. Classificação dos Dados Comprometidos
Campo	Tipo de Dado	Risco	Impacto
Nome	Identificação	Médio	Perfilamento da vítima
E-mail	Credencial de acesso	Alto	Phishing e roubo de identidade
Telefone	PII sensível	Crítico	Uso em golpes e engenharia social em mensageiros

Diagnóstico:

A ausência de criptografia de transporte compromete a confidencialidade e expõe integralmente os dados inseridos pela vítima.

🛡️ 8. Contramedidas e Recomendações

As defesas foram classificadas por camadas:

🔐 1. Camada de Aplicação — HTTPS / TLS

Implementar certificados digitais válidos.

Evita leitura dos dados por sniffers locais.

🌐 2. Camada de Rede — WPA3 + Proteção contra Rogue AP

Utilizar WPA3-Personal ou WPA3-Enterprise.

Redes empresariais devem usar 802.1X + RADIUS para autenticação.

Habilitar WIDS/WIPS (Wireless Intrusion Detection/Prevention) para detectar APs falsos.

🛡️ 3. Camada de Navegador — HSTS

Obriga o navegador a se comunicar apenas por HTTPS.

🎓 4. Camada Humana — Conscientização

Usuários devem verificar o cadeado/HTTPS antes de inserir dados.

Identificar portais suspeitos e evitar QR Codes desconhecidos.

🛠️ 9. Guia Completo de Reprodução
1. Requisitos

Host Windows com Hotspot ativado

VM Kali Linux em modo Bridge

Smartphone vítima conectado ao SSID de teste

2. Servidor Malicioso
git clone https://github.com/Kaypp21/Exploracao-Vulnerabilidade-HTTP.git
cd Exploracao-Vulnerabilidade-HTTP
sudo python3 -m http.server 80 --directory src/

3. Captura de Pacotes

Abrir Wireshark

Selecionar eth0

Filtro:

http.request.method == POST

4. Execução

A vítima escaneia o QR Code

Preenche o formulário

Dados aparecem imediatamente no Wireshark

<div align="center">

👨‍💻 Desenvolvido por:
Kayan Paiva Pereira • Enzo José Oliveira Pereira • Livya Silva de Carvalho • Nathan Massamb Belinato

Trabalho apresentado ao curso de Sistemas de Informação — Novembro/2025

</div>
