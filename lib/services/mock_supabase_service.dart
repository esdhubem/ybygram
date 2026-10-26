import '../models/post.dart';
import '../models/product.dart';
import '../models/course.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';

class MockSupabaseService {
  static final MockSupabaseService _instance = MockSupabaseService._internal();
  factory MockSupabaseService() => _instance;
  MockSupabaseService._internal() {
    _initData();
  }

  late UserProfile currentUser;
  late List<StoryItem> stories;
  late List<PostItem> posts;
  late List<VideoReelItem> videoReels;
  late List<ProductItem> products;
  late List<CourseModule> schoolModules;
  late HealthHabitsState habitsState;
  late List<FoodItem> foodDatabase;

  void _initData() {
    currentUser = UserProfile(
      id: 'usr_silviane_01',
      name: 'Silviane Terra',
      handle: '@silviane_saberes',
      bio: 'Educadora popular, guardiã de sementes crioulas e defensora da soberania tecnológica comunitária.',
      location: 'Vitória / ES (Comunidade Yby)',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      coverUrl: 'https://images.unsplash.com/photo-1511497584788-87676104235f?w=600',
      isSovereignCreator: true,
      isMeiSeller: true,
      healthPoints: 580,
      completedOrdersCount: 19,
    );

    stories = [
      const StoryItem(
        id: 'st_1',
        authorName: 'Aldeia Yvy',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        isLive: true,
        hasUnseen: true,
      ),
      const StoryItem(
        id: 'st_2',
        authorName: 'Mestre Tiago',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        isLive: false,
        hasUnseen: true,
      ),
      const StoryItem(
        id: 'st_3',
        authorName: 'Dona Benvinda',
        avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
        isLive: false,
        hasUnseen: true,
      ),
      const StoryItem(
        id: 'st_4',
        authorName: 'Biojoias Vale',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        isLive: false,
        hasUnseen: true,
      ),
      const StoryItem(
        id: 'st_5',
        authorName: 'Agroecologia ES',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        isLive: false,
        hasUnseen: true,
      ),
    ];

    posts = [
      PostItem(
        id: 'p_1',
        authorName: 'Dona Benvinda Ervas',
        authorLocation: 'Chapada Diamantina / BA',
        authorAvatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
        communityTag: 'Etnobotânica & Saberes',
        text: 'O preparo das folhas de Guandú e Carqueja respeita o ciclo das luas. Compartilhamos aqui a receita tradicional de infusão para o bem-estar do estômago, preservando a memória das nossas avós sem o filtro de grandes corporações.',
        imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800',
        likesCount: 142,
        commentsCount: 23,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        comments: [
          CommentItem(
            id: 'c_1',
            authorName: 'Tiago Santos',
            text: 'Gratidão por compartilhar essa sabedoria, Dona Benvinda!',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      PostItem(
        id: 'p_2',
        authorName: 'Aldeia Yvy Porã',
        authorLocation: 'Litoral Norte / SP',
        authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        communityTag: 'Cultura Viva',
        text: 'Iniciamos hoje o mutirão do plantio de mandioca e milho guarani. Redes livres conectando quem planta com quem come, garantindo que o valor fique direto na comunidade sem passar por intermediários predatórios.',
        imageUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800',
        likesCount: 289,
        commentsCount: 41,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      PostItem(
        id: 'p_3',
        authorName: 'Lucas Rede Livre',
        authorLocation: 'Vitória / ES',
        authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        communityTag: 'Soberania Digital',
        text: 'Nossos servidores comunitários rodando em energia solar e software livre. A internet é um bem público comum, não o feudo de cinco monopólios do Vale do Silício. Viva a autonomia digital popular!',
        imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
        likesCount: 312,
        commentsCount: 38,
        createdAt: DateTime.now().subtract(const Duration(hours: 9)),
      ),
    ];

    videoReels = [
      VideoReelItem(
        id: 'vr_1',
        authorName: 'Mestre Tiago',
        authorHandle: '@tiago_ervas',
        authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        title: 'Como identificar a Erva-Baleeira autêntica na Mata Atlântica e seu uso medicinal.',
        platform: 'Odysee',
        platformBadge: 'ODYSSEE LIVRE',
        thumbnailUrl: 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=600',
        likesCount: 840,
        commentsCount: 96,
      ),
      VideoReelItem(
        id: 'vr_2',
        authorName: 'Artesanato Guarani',
        authorHandle: '@arte_guarani',
        authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        title: 'Trançado ancestral de taquara para balaios comunitários: passo a passo.',
        platform: 'YouTube Shorts',
        platformBadge: 'YT SHORTS',
        thumbnailUrl: 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=600',
        likesCount: 1250,
        commentsCount: 142,
      ),
      VideoReelItem(
        id: 'vr_3',
        authorName: 'Sementes Crioulas',
        authorHandle: '@sementes_br',
        authorAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        title: 'Armazenamento seguro de sementes sem agrotóxicos em garrafas de vidro.',
        platform: 'TikTok',
        platformBadge: 'TIKTOK',
        thumbnailUrl: 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=600',
        likesCount: 620,
        commentsCount: 54,
      ),
    ];

    products = [
      const ProductItem(
        id: 'prd_1',
        title: 'Camiseta Algodão Orgânico YBYgram — Raízes da Terra',
        sellerName: 'YBYgram Oficial',
        sellerBadge: 'Exclusivo YBYgram (POD)',
        type: ProductType.officialPod,
        price: 89.90,
        imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500',
        description: 'Produzida sob demanda em 100% algodão agroecológico colhido no Nordeste brasileiro. O lucro financia os servidores da plataforma.',
        location: 'São Paulo / SP',
        rating: 5.0,
        salesCount: 114,
      ),
      const ProductItem(
        id: 'prd_2',
        title: 'Extrato Fitoterápico de Guaçatonga e Espinheira Santa (60ml)',
        sellerName: 'Dona Benvinda Ervas (MEI)',
        sellerBadge: 'Artesão Local MEI',
        type: ProductType.localArtisan,
        price: 46.00,
        imageUrl: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=500',
        description: 'Plantas cultivadas sem agrotóxicos em solo regenerativo. Acompanha manual impresso de posologia tradicional.',
        location: 'Chapada Diamantina / BA',
        rating: 4.9,
        salesCount: 88,
      ),
      const ProductItem(
        id: 'prd_3',
        title: 'Biojoia Colar em Sementes de Açaí e Jarina Amazônica',
        sellerName: 'Coletivo Mulheres da Mata',
        sellerBadge: 'Artesão Local MEI',
        type: ProductType.localArtisan,
        price: 55.00,
        imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500',
        description: 'Trabalho manual de coleta sustentável na várzea. Tingimento com cúrcuma e urucum natural.',
        location: 'Santarém / PA',
        rating: 4.9,
        salesCount: 42,
      ),
      const ProductItem(
        id: 'prd_4',
        title: 'Mel Silvestre de Abelhas Nativas sem Ferrão Jataí (250g)',
        sellerName: 'Meliponário Yby Porã',
        sellerBadge: 'Artesão Local MEI',
        type: ProductType.localArtisan,
        price: 68.00,
        imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=500',
        description: 'Mel puro e medicinal com alto teor de antioxidantes e propriedades probióticas preservadas a frio.',
        location: 'Domingos Martins / ES',
        rating: 5.0,
        salesCount: 73,
      ),
      const ProductItem(
        id: 'prd_5',
        title: 'Livro Físico: Etnobotânica e Curas Populares do Brasil',
        sellerName: 'Editora Comunitária',
        sellerBadge: 'Editora UICLAP',
        type: ProductType.physicalBook,
        price: 58.90,
        imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500',
        description: 'Livro impresso sob demanda via UICLAP. 280 páginas com fotos em cores e fichas botânicas de 80 espécies nativas.',
        location: 'Campinas / SP',
        rating: 4.8,
        salesCount: 52,
      ),
      const ProductItem(
        id: 'prd_6',
        title: 'E-book PDF: Guia de Criptografia e Redes Livres Comunitárias',
        sellerName: 'Coletivo Soberania Digital',
        sellerBadge: 'E-book Digital (PDF)',
        type: ProductType.ebookDigital,
        price: 24.90,
        imageUrl: 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=500',
        description: 'Download imediato em PDF e ePub. Passo a passo para montar sua estação de rádio, rede mesh e chat seguro.',
        isEbook: true,
        pdfDownloadUrl: 'https://ybygram.org/downloads/guia-soberania-digital.pdf',
        location: 'Vitória / ES',
        rating: 5.0,
        salesCount: 165,
      ),
    ];

    currentUser.libraryEbooks = [products[5]];
    currentUser.myStoreProducts = [products[0], products[1]];

    schoolModules = [
      CourseModule(
        id: 'mod_1',
        title: 'Módulo 1: O Que é a Escola do Criador Soberano',
        description: 'Entenda os princípios éticos, a lei de direitos autorais e o propósito coletivo do YBYgram.',
        lessons: [
          LessonItem(
            id: 'l_1_1',
            title: '1. Boas-vindas e o manifesto da soberania comunitária',
            duration: '06:12',
            videoEmbedUrl: 'https://odysee.com/$/embed/ybygram-manifesto',
            summary: 'Conheça por que o YBYgram existe e como o valor gerado retorna para quem produz.',
            isCompleted: true,
          ),
          LessonItem(
            id: 'l_1_2',
            title: '2. Regras éticas: o que NÃO é permitido na plataforma',
            duration: '08:45',
            videoEmbedUrl: 'https://odysee.com/$/embed/regras-eticas',
            summary: 'Proibição de produtos industriais massificados, drop-shipping chinês e desinformação de saúde.',
            isCompleted: true,
          ),
        ],
      ),
      CourseModule(
        id: 'mod_2',
        title: 'Módulo 2: Como Cadastrar e Vender no Marketplace',
        description: 'Aprenda a cadastrar como MEI ou artesão, emitir etiquetas no Melhor Envio e receber via Pagar.me.',
        lessons: [
          LessonItem(
            id: 'l_2_1',
            title: '1. Cadastro de MEI e configuração de conta bancária',
            duration: '10:20',
            videoEmbedUrl: 'https://odysee.com/$/embed/cadastro-vendedor',
            summary: 'Configuração do split de pagamento transparente que envia 95% direto para sua chave Pix.',
            isCompleted: true,
          ),
          LessonItem(
            id: 'l_2_2',
            title: '2. Fotos de qualidade e precificação justa',
            duration: '07:30',
            videoEmbedUrl: 'https://odysee.com/$/embed/fotos-produtos',
            summary: 'Dicas práticas para valorizar produtos artesanais com luz natural e boas descrições.',
            isCompleted: false,
          ),
        ],
      ),
      CourseModule(
        id: 'mod_3',
        title: 'Módulo 3: Diretrizes para Fitoterápicos e Saberes de Saúde',
        description: 'Responsabilidade ética ao compartilhar receitas, etnobotânica e respeito aos limites legais de saúde.',
        lessons: [
          LessonItem(
            id: 'l_3_1',
            title: '1. Avisos obrigatórios e respeito à medicina integrativa',
            duration: '11:15',
            videoEmbedUrl: 'https://odysee.com/$/embed/saude-etica',
            summary: 'A importância de nunca prometer curas milagrosas e valorizar o acompanhamento profissional.',
            isCompleted: false,
          ),
        ],
      ),
      CourseModule(
        id: 'mod_4',
        title: 'Módulo 4: Código de Ética e Proteção à Saúde Integrativa',
        description: 'Combate rigoroso a charlatanismo, validação prévia de criadores de saúde e rigor científico.',
        lessons: [
          LessonItem(
            id: 'l_4_1',
            title: '1. Repúdio absoluto a promessas de cura milagrosa',
            duration: '12:30',
            videoEmbedUrl: 'https://odysee.com/$/embed/repudio-cura-milagrosa',
            summary: 'Proibição severa de promessas de cura de câncer, diagnósticos pseudocientíficos e desestímulo a tratamentos convencionais.',
            isCompleted: true,
          ),
          LessonItem(
            id: 'l_4_2',
            title: '2. Filtro de curadoria humana e validação de vendedor',
            duration: '09:45',
            videoEmbedUrl: 'https://odysee.com/$/embed/curadoria-humana-saude',
            summary: 'Checagem de credenciais profissionais e validação prévia para comercialização de fitoterápicos e serviços integrativos.',
            isCompleted: false,
          ),
          LessonItem(
            id: 'l_4_3',
            title: '3. Transparência, rigor científico e denúncia comunitária',
            duration: '08:20',
            videoEmbedUrl: 'https://odysee.com/$/embed/rigor-cientifico-denuncia',
            summary: 'Como embasar saberes em etnobotânica séria, estudos científicos e usar a ferramenta de denúncia da comunidade.',
            isCompleted: false,
          ),
        ],
      ),
    ];

    habitsState = HealthHabitsState();

    foodDatabase = const [
      FoodItem(name: 'Banana da terra cozida (1 unid)', calories: 120, portion: '100g', category: 'Frutas & Raízes'),
      FoodItem(name: 'Mandioca cozida com azeite', calories: 180, portion: '150g', category: 'Frutas & Raízes'),
      FoodItem(name: 'Arroz integral com feijão carioca', calories: 240, portion: '1 prato raso', category: 'Prato Típico'),
      FoodItem(name: 'Chá de erva-cidreira sem açúcar', calories: 2, portion: '200ml', category: 'Infusões'),
      FoodItem(name: 'Castanha-do-Brasil (3 unid)', calories: 95, portion: '15g', category: 'Oleaginosas'),
      FoodItem(name: 'Açaí puro com sementes de chia', calories: 210, portion: '200ml', category: 'Frutas & Raízes'),
    ];
  }

  void addPost(String text, String? imageUrl, String communityTag) {
    final newPost = PostItem(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      authorName: currentUser.name,
      authorLocation: currentUser.location,
      authorAvatar: currentUser.avatarUrl,
      communityTag: communityTag.isNotEmpty ? communityTag : 'Comunidade Yby',
      text: text,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    posts.insert(0, newPost);
  }

  void toggleLikePost(String postId) {
    final p = posts.firstWhere((item) => item.id == postId);
    p.isLiked = !p.isLiked;
    p.likesCount += p.isLiked ? 1 : -1;
  }

  void addComment(String postId, String text) {
    final p = posts.firstWhere((item) => item.id == postId);
    p.comments.add(
      CommentItem(
        id: 'c_${DateTime.now().millisecondsSinceEpoch}',
        authorName: currentUser.name,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    p.commentsCount = p.comments.length;
  }
}
