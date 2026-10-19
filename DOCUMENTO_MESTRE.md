# YbyGram — Documento Mestre do Projeto e Prompt para Antigravity

## 1. Instrução principal para o Antigravity

Atue como engenheiro de software sênior, arquiteto Flutter e parceiro técnico cuidadoso. Desenvolva o **YbyGram**, uma plataforma social, educacional e de comércio comunitário criada para o contexto brasileiro.

Trabalhe por etapas, com código legível, testável, seguro e documentado em português. Antes de alterar arquivos, inspecione a estrutura existente e preserve o que já funciona. Não substitua todo o projeto por uma solução nova sem necessidade. Ao terminar cada etapa, informe quais arquivos foram criados ou alterados, como executar e quais testes foram feitos.

**Não invente integrações funcionais.** Se uma API ainda não estiver configurada, crie uma interface/abstração, um serviço simulado claramente identificado e uma lista de passos para ativação. Nunca coloque chaves secretas no aplicativo Flutter. Credenciais de pagamento e segredos devem ficar no backend, em variáveis de ambiente.

## 2. Identidade, missão e princípios

- **Nome oficial:** YbyGram.
- **Conceito:** comunicação livre, saberes compartilhados, economia comunitária e autonomia digital.
- **Missão:** conectar pessoas, criadores, artesãos, mestres de saberes tradicionais, autores independentes e pequenos produtores brasileiros em um ambiente social útil, acolhedor e responsável.
- **Princípios:** respeito ao tempo das pessoas; transparência; acessibilidade; privacidade; diversidade cultural; valorização de saberes tradicionais; comércio justo; responsabilidade socioambiental; debate baseado em fatos; liberdade de expressão dentro da lei; proteção contra assédio, fraude e discurso de ódio.
- **Não usar:** mecanismos deliberadamente desenhados para indignação, compulsão, rolagem manipulativa ou pressão social.
- **Linguagem da interface:** português brasileiro simples, sem jargões técnicos desnecessários.
- **Marca:** substituir integralmente “Brazuca”, “Brazuca (Zuka)” e “Zuka” por “YbyGram” em títulos, AppBar, logotipo textual, onboarding, telas vazias, textos institucionais, nomes de variáveis visíveis e documentação do usuário. Não alterar nomes de integrações externas ou marcas de terceiros.

## 3. Estrutura principal do aplicativo

Aplicativo Flutter com Dart 3+, Material 3, suporte a Android, iOS e Web, design responsivo e tema claro/escuro. Use arquitetura organizada por funcionalidades; prefira Riverpod ou flutter_bloc, mas inspecione primeiro o projeto existente e não misture gerenciadores de estado sem motivo.

### Navegação inferior: quatro áreas

1. **Feed**
2. **Loja**
3. **Aulas**
4. **Hábitos**

O avatar do usuário fica no canto superior direito do cabeçalho e abre o perfil. Não manter um banner grande de formação no topo do Feed. O progresso da formação e o convite ao selo ficam no Perfil e na área Aulas.

### 3.1 Feed

No topo do Feed, oferecer quatro filtros por formato:
- **Saberes:** publicações escritas, reflexões, perguntas, relatos, fotos e conversas comunitárias.
- **Vídeos:** vídeos curtos, demonstrações, música, artesanato, receitas e rodas de saberes.
- **Produtos:** vitrine de produtos comunitários em grade de duas colunas.
- **Leitura:** livros, zines, cartilhas, ensaios e artigos longos.

Requisitos:
- Interface limpa, com hierarquia visual clara.
- Não tocar vídeos automaticamente com som.
- Oferecer controles de reprodução e respeito à preferência de dados móveis.
- Ações para curtir, comentar, compartilhar e salvar conhecimento.
- Exibir autor, data e contexto da publicação.
- Preparar paginação/rolagem incremental sem fingir que existe backend quando não existir.
- Conteúdo de demonstração deve ser identificado no código como mock.
- A moderação deve ter regras claras, denúncia, bloqueio e revisão contextual; não prometer moderação perfeita nem censura zero.

### 3.2 Loja e marketplace

Apresentar produtos em grade responsiva de duas colunas em telas estreitas, com foto, título curto, preço, origem/vendedor e informação de entrega quando disponível. Não inventar avaliações, preços ou prazo real.

Organizar em três frentes:
1. **Loja oficial YbyGram:** camisetas, bonés, roupas e acessórios sob demanda (POD).
2. **Livraria independente:** livros, cartilhas, zines e obras de autores independentes, com possibilidade de integração com a UICLAP ou outro fornecedor validado.
3. **Marketplace comunitário:** artesanato, biojoias, cerâmica, produtos regionais e itens de pequenos produtores.

Modelo de comissão inicialmente proposto para o marketplace: 90% ao vendedor e 10% à plataforma. Isso é uma regra de negócio proposta, não uma promessa de repasse automático: validar taxas de processamento, impostos, reembolsos, chargebacks, legislação e contratos com o provedor antes de ativar.

Checkout planejado:
- CEP de destino.
- Cotação de frete por integração validada.
- Pagamento por Pix e cartão por provedor compatível.
- Divisão de pagamento quando autorizada e suportada pelo provedor.
- Estados claros: aguardando pagamento, pago, em preparação, enviado, entregue, cancelado e reembolsado.
- Não afirmar que o provedor mantém valores em custódia ou libera pagamento após entrega sem confirmação contratual e técnica.
- Chaves e operações sensíveis exclusivamente no backend.
- Política de privacidade, termos, atendimento, devolução e proteção contra fraude.

### 3.3 Aulas e Direitos — trilha “Criador Soberano”

Área educacional gratuita com aulas curtas, material de apoio e questionários. Módulos propostos:
1. Saberes tradicionais, plantas medicinais e comunicação responsável.
2. Liberdade de expressão, debate público e responsabilidade jurídica.
3. Direitos autorais, licenças abertas e publicação independente.
4. Privacidade, segurança digital e autonomia tecnológica.
5. Bem-estar e uso consciente das telas.

Cada módulo pode conter vídeo, texto, material para leitura e quiz. O progresso deve ser salvo somente após implementação de autenticação e persistência. O selo “Criador Soberano” pode indicar conclusão da trilha; critérios e benefícios devem ser transparentes. Não usar um aviso legal como substituto de revisão jurídica ou sanitária.

Aviso reutilizável para conteúdos sobre plantas e saberes de saúde:
> “Este conteúdo compartilha informações culturais, históricas e etnobotânicas. Não substitui avaliação, diagnóstico ou acompanhamento de profissional de saúde. O uso de plantas pode apresentar riscos, interações e contraindicações.”

Evitar apresentar produtos artesanais como medicamentos ou atribuir benefícios clínicos sem evidência e conformidade regulatória.

### 3.4 Hábitos e bem-estar

Área opcional para práticas fora da tela:
- leitura;
- caminhada ou movimento;
- pausas e respiração;
- contato com a natureza;
- alimentação consciente;
- atividades educativas.

A gamificação deve ser gentil, não punitiva. Não envergonhar quem não cumprir metas, não fazer comparações públicas obrigatórias e não incentivar comportamento compulsivo. Permitir desativar lembretes e apagar registros.

Integrações futuras com Apple Health/Health Connect exigem consentimento explícito e escopo mínimo. Não coletar dados de saúde sem necessidade. Para a primeira versão, usar check-ins voluntários inseridos pelo próprio usuário.

Pontos e recompensas são uma ideia futura. Não apresentar integração com Lomadee, cupons ou cashback como funcional até validar a disponibilidade de API, termos comerciais, atribuição e modelo de remuneração.

## 4. Diretrizes visuais

- Identidade orgânica, brasileira e acolhedora.
- Paleta sugerida: verde-mata (#245C45), tons terrosos, bege natural (#F8F6F0) e neutros com contraste adequado.
- Material 3, tipografia legível, botões com áreas de toque confortáveis e suporte a tamanhos de fonte maiores.
- Evitar excesso de cards, animações, notificações e elementos competitivos.
- Garantir contraste, semântica para leitores de tela, navegação por teclado na Web e estados de carregamento/erro/vazio.
- Usar “YbyGram” em toda a identidade visível. O logotipo pode começar como wordmark tipográfico; não inventar um arquivo de imagem que não exista.

## 5. Arquitetura técnica proposta

Estrutura inicial sugerida:

```text
lib/
  main.dart
  app/
    app.dart
    theme/
      app_theme.dart
    navigation/
      main_navigation.dart
  core/
    errors/
    network/
    privacy/
    widgets/
  features/
    feed/
      data/
      domain/
      presentation/
    store/
      data/
      domain/
      presentation/
    education/
      data/
      domain/
      presentation/
    habits/
      data/
      domain/
      presentation/
    profile/
      presentation/
```

Princípios:
- Separar interface, regras de negócio e acesso a dados.
- Criar modelos tipados e validação de entradas.
- Usar repositórios para que mocks possam ser substituídos por serviços reais.
- Não incluir tokens secretos no app.
- Não assumir que Web3/IPFS/Lens é imutável, permanente, gratuito ou adequado para todo tipo de dado. Avaliar privacidade, moderação, remoção, custo e disponibilidade antes de adotar.
- Não armazenar dados pessoais ou de saúde em blockchain pública.
- Para a primeira versão, priorizar uma arquitetura híbrida simples e segura; descentralização pode ser adicionada após avaliação técnica.
- Banco sugerido para protótipo/backend: PostgreSQL gerenciado (por exemplo, Supabase ou serviço equivalente), após avaliação de custo, limites, região, segurança e termos.
- Vídeos de usuários precisam de armazenamento, processamento, limites de tamanho, proteção contra abuso, direitos autorais e política de remoção. Não prometer hospedagem ilimitada ou gratuita.

## 6. Entidades iniciais

Criar modelos para:
- `UserProfile`: id, nome público, avatar opcional, biografia, selo e preferências.
- `Post`: id, autor, tipo, texto, mídia opcional, data, contadores e sinalização de conteúdo demonstrativo.
- `Product`: id, título, descrição, preço, moeda, imagens, vendedor, origem e disponibilidade.
- `Order`: id, comprador, itens, frete, total, status e datas.
- `ShippingOption`: transportadora, preço e prazo, sempre identificados como cotados ou simulados.
- `Course`, `Lesson`, `Quiz`, `CourseProgress`.
- `HabitEntry`: tipo, data e registro voluntário.
- `RewardTransaction`: somente quando o sistema de pontos estiver especificado e auditável.
- `Report`: denúncia, motivo, conteúdo relacionado, status e data.

## 7. Integrações futuras

### Frete
Avaliar API do Melhor Envio ou alternativa. Implementar no backend, validar CEP, peso, dimensões, cobertura, prazo e seguro. Não presumir que todo serviço possui seguro automático ou disponibilidade para todos os envios.

### Pagamento
Avaliar Pagar.me ou outro provedor. Confirmar split, cadastro de recebedores, taxas, KYC, estornos, chargebacks e obrigações fiscais. O backend deve validar valores e receber webhooks com autenticação e idempotência.

### Impressão sob demanda
Avaliar fornecedores brasileiros, incluindo disponibilidade de catálogo, qualidade, API, marca branca, prazos, devoluções, integração e sustentabilidade. Não assumir que uma empresa oferece API ou todos os produtos sem confirmação.

### Livros
Avaliar UICLAP ou outras opções de impressão sob demanda, verificando contrato, ISBN, direitos autorais, prazos, custos e integração.

### Mídia
Comparar armazenamento tradicional e descentralizado segundo custo total, velocidade, moderação, remoção, privacidade e disponibilidade. Não gravar informações pessoais em armazenamento público permanente.

## 8. Segurança, privacidade e conformidade

- Projetar considerando a LGPD: finalidade, necessidade, transparência, segurança, direitos do titular e retenção limitada.
- Solicitar consentimento para dados sensíveis e integrações de saúde quando aplicável.
- Implementar autenticação segura, autorização no backend, proteção de sessão, validação de uploads e limitação de requisições.
- Nunca confiar em valores de preço, pontos ou split enviados pelo cliente.
- Criar política de conteúdo, denúncia, bloqueio, apelação e resposta a incidentes.
- Incluir termos, política de privacidade e canais de contato antes do lançamento.
- Avaliar regras brasileiras de comércio eletrônico, defesa do consumidor, tributação e produtos regulados com profissionais habilitados.
- Não prometer “blindagem fiscal”, anonimato absoluto, impossibilidade de censura ou segurança perfeita.

## 9. Plano de execução recomendado

**Fase 1 — Protótipo local:** navegação, Feed com filtros, perfil, grade de produtos, área de aulas e check-ins. Dados mock claramente identificados. Sem cobrança nem coleta sensível.

**Fase 2 — Base de engenharia:** testes, acessibilidade, organização por funcionalidades, tratamento de erros, documentação e CI.

**Fase 3 — Backend:** autenticação, banco, regras de acesso, upload de mídia e persistência.

**Fase 4 — Comércio:** catálogo real, vendedor, frete, pagamento, split, pedidos, reembolso e painel administrativo em ambiente de testes.

**Fase 5 — Comunidade e educação:** cursos, quizzes, denúncias, moderação, políticas e selo.

**Fase 6 — Piloto:** testes com usuários, revisão de segurança, acessibilidade, privacidade, custos operacionais e suporte antes da publicação.

## 10. Critérios de aceite

- A marca visível é “YbyGram” em todas as telas.
- As quatro áreas inferiores funcionam.
- O Feed contém Saberes, Vídeos, Produtos e Leitura.
- O avatar abre Perfil.
- Produtos aparecem em grade responsiva de duas colunas em celular.
- Aulas mostram a trilha Criador Soberano e o aviso de conteúdo de saúde.
- Hábitos permitem check-ins voluntários e não punitivos.
- Conteúdo de demonstração está identificado como mock.
- Nenhum botão aparenta executar pagamento, frete, upload ou sincronização real sem integração.
- O projeto compila, tem instruções de execução e testes básicos.
