# YBYgram • Rede Soberana | Protótipo PWA

> **"Algoritmos Amigáveis: Fluxo Cronológico de Oportunidade"**  
> Protótipo PWA com tela de boas-vindas Play Store, autenticação mock, estética fluida em ondas turquesa-dourado e algoritmo justo Fisher-Yates.

---

## 🌿 1. Visão Geral do Projeto

O **YBYgram** é um protótipo de aplicativo web progressivo (**PWA — Progressive Web App**) concebido como uma **Rede Social Viva e Soberana**. Diferente das plataformas comerciais tradicionais, o YBYgram é fundamentado na **soberania de dados**, no **respeito ao tempo do usuário** e em **algoritmos amigáveis**, eliminando mecânicas viciosas de retenção por dopamina, vigilância abusiva de dados ou feeds opacos orientados a leilão publicitário.

Este repositório contém a versão **100% frontend** com suporte nativo a instalação móvel (PWA), simulação de abertura na **Google Play Store**, fluxo completo de **Login Mock** e descoberta de conteúdos da terra (agroecologia, saberes ancestrais, plantas medicinais, hábitos saudáveis e economia circular).

---

## 🎨 2. Identidade Visual: Ondas Turquesa & Ouro Líquido

Inspirado na composição visual criada para a abertura na Play Store, o protótipo incorpora:
- **Fundo Obsidian Deep Green** (`#021411` e `#052e27`): remetendo à profundidade das florestas ancestrais e à serenidade digital.
- **Fitas Onduladas em Turquesa Neon** (`#00f5b4`, `#0d9488`): gradientes fluidos com desfoque atmosférico (`feGaussianBlur`), simbolizando os rios, a seiva das plantas e a conectividade limpa.
- **Ondas e Gotas em Ouro Líquido** (`#FFE58F`, `#F6CF4C`, `#D49312`): transmitindo o valor inestimável dos saberes passados de geração em geração, calor comunitário e abundância compartilhada.
- **Tipografia Moderna**: famílias limpas com pesos contrastantes, títulos expressivos e micro-estrelas de iluminação orgânica (`✦`, `✨`).
- **Simulação da Status Bar Android/iOS**: indicador de horário 9:41, rede móvel, Wi-Fi e bateria de ponta no topo do app shell.

---

## ⚡ 3. Arquitetura de Algoritmos Amigáveis

O YBYgram apresenta duas premissas de distribuição de conteúdos:

### 🕒 A. Fluxo Cronológico Decrescente de Oportunidade
- Aplicado primariamente ao feed de **Vídeos Curtos (9:16)**, **Saberes Gerais** e **Recados Rápidos (24h)**.
- **Regra**: Cada publicação enviada ganha visibilidade no topo no momento exato em que foi partilhada. Não há penalização por falta de "engajamento prévio", nem impulsionamento pago que sufoque a voz de pequenos produtores e artesãos.

### ✨ B. Descoberta Aleatória Justa (Algoritmo Fisher-Yates)
- Aplicado à aba de **Vídeos Longos / Cursos**, vitrine de conhecimentos perenes e no botão de exploração **"Descobrir Aleatório"**.
- **Fundamento Matemático**: O embaralhamento Fisher-Yates ($O(n)$ in-place) gera permutações uniformemente distribuídas, onde todo vídeo e aula têm probabilidade idêntica ($1/n$) de figurar nas primeiras posições a cada visita.

```javascript
// Implementação do embaralhamento justo Fisher-Yates
function shuffleFisherYates(array) {
  const copia = [...array];
  for (let i = copia.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copia[i], copia[j]] = [copia[j], copia[i]];
  }
  return copia;
}
```

---

## 📱 4. Fluxo da Tela de Boas-Vindas & Acesso ao Feed

Ao carregar a aplicação pela primeira vez ou ao clicar em **"🌟 Início PWA"** no cabeçalho:

1. **Apresentação Play Store**:
   - Logotipo com folha alada em vetor turquesa e dourado.
   - Título central: *"YBYgram • Rede Soberana | Algoritmos Amigáveis: Fluxo Cronológico de Oportunidade"*.
   - Mensagem de manifesto sobre soberania digital e economia da terra.
2. **Botão Principal de Ação**:
   - `✨ Faça sua Postagem / Entrar no Feed`: transição imediata para o feed interativo com o perfil padrão.
3. **Botões de Autenticação Mock**:
   - `Criar Conta`: abre modal com alternância para cadastro soberano local.
   - `Entrar`: abre modal com alternância para login mock.
4. **Seletor de Perfis Rápidos (1-Clique)**:
   - **Silviane Terra** (@silviane_saberes) — Educadora Popular & Criadora Principal.
   - **Dona Benvinda** (@benvinda_ervas) — Mestre Erveira e Fitoterapeuta.
   - **Mestre Tiago** (@tiago_agrofloresta) — Agrofloresta e Manejo da Terra.
   - **Visitante Livre** (@visitante_livre) — Acesso exploratório aberto.
5. **Pílula de Navegação Rápida**:
   - Atalhos instantâneos para as 4 áreas temáticas: `Saberes`, `Curtos`, `Longos` e `Música`.
   - Seletor rápido de modo: `Recentes 🕒` ou `Descobrir Aleatório ✨`.

---

## 🗂️ 5. Estrutura de Arquivos PWA

```
YbyGram/
├── index.html          # Aplicação principal (App Shell, Telas, Modais e Lógica)
├── manifest.json       # Manifesto Web PWA (cores, orientação, atalhos e ícones)
├── sw.js               # Service Worker com cache offline e estratégia Stale-While-Revalidate
├── _serve.js           # Servidor local Node.js com MIME types (JSON, JS, SVG, HTML)
├── icons/
│   └── icon.svg        # Ícone adaptativo vetorial (Ondas Turquesa e Ouro)
└── README.md           # Documentação técnica e guia do protótipo
```

---

## 🚀 6. Como Executar e Testar Localmente

### Pré-requisitos
- **Node.js** instalado na máquina.

### Executando o Servidor Local
Abra o terminal na pasta do projeto e inicie o servidor:
```bash
node _serve.js
```
O servidor estará ativo em:
👉 **`http://localhost:3333`**

### Testando os Recursos PWA no Navegador
1. Abra `http://localhost:3333` no **Google Chrome** ou **Microsoft Edge**.
2. Abra o DevTools (`F12`) e vá na aba **Application / Aplicativo**:
   - **Manifest**: Verifique se o `manifest.json` foi carregado com nome *"YBYgram • Rede Soberana"*, cores de tema e atalhos.
   - **Service Workers**: Verifique o status `Activated and running` do arquivo `sw.js`.
3. **Instalação no Computador**: Clique no ícone de computador com seta para baixo na barra de endereços do Chrome (*"Instalar YBYgram"*).
4. **Instalação no Smartphone Android**:
   - Acesse o IP da sua máquina ou utilize o Chrome com emulação mobile (`Ctrl + Shift + M`).
   - No celular, clique no menu de três pontos e selecione **"Adicionar à tela inicial"** ou **"Instalar aplicativo"**.

---

## 📲 7. Arquitetura para Play Store: Trusted Web Activity (TWA)

Embora este seja um **protótipo frontend**, o YBYgram foi estruturado para ser empacotado como um aplicativo nativo para a **Google Play Store** através do padrão **TWA (Trusted Web Activity)** sem precisar reescrever o código em Kotlin/Java:

1. **Requisitos atendidos pelo protótipo**:
   - `manifest.json` válido com `display: "standalone"`, `start_url` e `theme_color`.
   - `sw.js` com suporte a evento `fetch` e carregamento offline do App Shell.
   - Ícone quadrado de alta resolução (`icons/icon.svg` ou PNGs 192x192 / 512x512).
   - Design 100% responsivo para telas móveis.

2. **Ferramenta recomendada para empacotamento**:
   - **PWABuilder** ([pwabuilder.com](https://www.pwabuilder.com)) ou **Bubblewrap CLI**:
     ```bash
     npm install -g @bubblewrap/cli
     bubblewrap init --manifest https://seu-dominio.org/manifest.json
     bubblewrap build
     ```
   - O processo gera o arquivo `.aab` (Android App Bundle) assinado pronto para publicação no Google Play Console.
   - No domínio do servidor de produção, basta adicionar o arquivo `/.well-known/assetlinks.json` para eliminar a barra de endereços do Chrome no Android.

---

## 🔒 8. Nota sobre Autenticação & Dados

- **Sem Login Real**: Todos os logins e cadastros utilizam dados simulados no `localStorage` do navegador do usuário.
- **Sem Servidor Externo de Armazenamento**: O protótipo é autosuficiente no cliente, preservando a soberania e a privacidade do usuário de acordo com as premissas da rede.
