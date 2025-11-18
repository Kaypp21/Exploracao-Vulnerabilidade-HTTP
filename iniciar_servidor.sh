#!/bin/bash
echo "[*] Iniciando Servidor de Phishing na porta 80..."
echo "[*] Acesse: http://SEU_IP_LOCAL"
sudo python3 -m http.server 80 --directory src/
