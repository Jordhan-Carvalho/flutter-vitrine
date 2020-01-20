import './products.dart';

final dummyProducts = [
  Product(
      id: '1',
      condition: 'Usado',
      createdOn: DateTime.now(),
      delivery: false,
      description:
          'Put the spaghetti into the boiling water - they should be done in about 10 to 12 minutes.',
      title: 'Spagethti',
      tradable: true,
      zap: '991116269',
      imageUrl: [
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
        'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      ],
      price: 99.55,
      category: 'Comidas'),
  Product(
    id: '2',
    condition: 'Novo',
    createdOn: DateTime.now(),
    delivery: false,
    price: 55.98,
    category: "Gibi",
    description:
        'Conan Exiles é um jogo de sobrevivência em mundo aberto ambientado nas terras brutais de Conan, o Bárbaro. Sobreviva em um mundo hostil, construa seu reino e subjugue seus inimigos em combates brutais e conflitos épicos.',
    title: 'Conan',
    tradable: true,
    zap: '991116269',
    imageUrl: [
      'https://cdn-istoe-ssl.akamaized.net/wp-content/uploads/sites/14/2016/01/mi_6205498677630722.jpg',
      'https://rika.vteximg.com.br/arquivos/ids/236015-1000-1000/-herois_abril_etc-espada-selvagem-conan-reed-044.jpg',
      'http://1.bp.blogspot.com/_vNPRdItYCdY/Sw1aaoKLlVI/AAAAAAAAAiI/pIOfrZ4DttE/s1600/SSOC74.jpg',
    ],
  ),
  Product(
    id: '3',
    condition: 'Usado',
    createdOn: DateTime.now(),
    delivery: true,
    price: 55.98,
    category: "Tablet",
    description:
        'iPad new 2018  128 gigas de memória interna tela de 9.7 roda jogos pesado como pubg freefire ',
    title: 'iPad new 2018',
    tradable: true,
    zap: '991116269',
    imageUrl: [
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/82772113_2473682046216624_5840907475313754112_o.jpg?_nc_cat=111&_nc_ohc=mtR8XXsBjs8AX9oZATJ&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=125f02a00e707dc36fb85aac30b42ab1&oe=5E9543B2',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/82819235_2473682066216622_3482651476948418560_o.jpg?_nc_cat=108&_nc_ohc=NqVZjwivvj4AX_eWTpD&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=a75d35c0fed91c74ef7bf43a89fe8d0f&oe=5E8E0DAB',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/83065889_2473682052883290_2465216957666820096_o.jpg?_nc_cat=102&_nc_ohc=fqOf0pscHjAAX_nLPTy&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=cf8da5b74cf988f948df1e0ffc27d7ba&oe=5E98DCE9',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/82781867_2473682036216625_7301290153744531456_o.jpg?_nc_cat=100&_nc_ohc=S0goob-DqiAAX9oQYtZ&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=31e6bbb9a03cf2c3289b64a88d3ae191&oe=5E8E2D12',
    ],
  ),
  Product(
    id: '4',
    condition: 'Usado',
    createdOn: DateTime.now(),
    delivery: true,
    price: 1200.98,
    category: "Video-game",
    description:
        'XBOX One em perfeito estado de funcionamento e extremamente conservado Um controleHD Interno de 500gb Troco por notebook',
    title: 'XBOX One',
    tradable: true,
    zap: '991116269',
    imageUrl: [
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-0/p180x540/82637300_1537829739688563_2005341018144112640_o.jpg?_nc_cat=111&_nc_ohc=lfxVyGCnj-0AX94RQg4&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=49a557e14f892fff0839497b29b6c672&oe=5ED9E7C6',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/s960x960/83200643_1537829776355226_6462962591114199040_o.jpg?_nc_cat=100&_nc_ohc=WC2bGYLZZAwAX9C6HgH&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=fb9f4b6f9764cd45c72ad54b7b73d941&oe=5E9FC8FE',
    ],
  ),
  Product(
    id: '5',
    condition: 'Novo',
    createdOn: DateTime.now(),
    delivery: true,
    price: 1852,
    category: "Video-game",
    description:
        'Impressora para grande demanda toner  imprime mais de 17.000 páginas ',
    title: 'Impressora Ricoh',
    tradable: false,
    zap: '991116269',
    imageUrl: [
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/s960x960/83009265_152874209468681_3205980554302324736_o.jpg?_nc_cat=106&_nc_ohc=cPv6AGXYj7kAX8BiQpp&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=da71ef71574130a970eafe5b8e4dac36&oe=5E9F73F8',
    ],
  ),
  Product(
    id: '6',
    condition: 'Novo',
    createdOn: DateTime.now(),
    delivery: false,
    price: 900,
    category: "Esteira",
    description: 'Está bem conservada !  ',
    title: 'Esteira elétrica',
    tradable: false,
    zap: '991116269',
    imageUrl: [
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/s960x960/82953437_1465708370260121_4495882859629772800_o.jpg?_nc_cat=109&_nc_ohc=b66gRFxjP7kAX_xILxp&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=4a4e762418fc29bfa32e9ae4143017ae&oe=5ED171D3',
    ],
  ),
  Product(
    id: '7',
    condition: 'Usado',
    createdOn: DateTime.now(),
    delivery: true,
    price: 150,
    category: "Vestuario",
    description:
        'Lindas camisas Nfl e Nba, só encontra na loja hot nigga, mais informações chama no whats 077 998048211',
    title: 'Camisas NFl e Nba',
    tradable: true,
    zap: '991116269',
    imageUrl: [
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/78547359_961968214181802_2078483800093884416_o.jpg?_nc_cat=111&_nc_ohc=9El1RGy_RSMAX9DkCKV&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=24c85c8562ce6ac41383e8ae387dbd9b&oe=5E9F5088',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/78899625_961968244181799_3483473430609657856_o.jpg?_nc_cat=111&_nc_ohc=PmwFE9XNzYkAX89GUGV&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=2ec8c954a5e4fcbdba8211daf84d9f2b&oe=5ED81892',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/77112858_961968274181796_3043357926946242560_o.jpg?_nc_cat=109&_nc_ohc=p65l0TO4QoQAX8FPtn_&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=84a5d7eb5e0f8970b7041f413a9f97fa&oe=5E8E0FE1',
      'https://scontent.flaz1-1.fna.fbcdn.net/v/t1.0-9/p720x720/78281958_961968307515126_8754108132046667776_o.jpg?_nc_cat=102&_nc_ohc=_s1iXQ4a7AwAX_ns3H0&_nc_ht=scontent.flaz1-1.fna&_nc_tp=1002&oh=05dcfcdd985d74d11d2e2baa8dbaa1a7&oe=5ED4E2D8',
    ],
  ),
];
