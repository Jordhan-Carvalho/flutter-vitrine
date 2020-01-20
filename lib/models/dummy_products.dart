import './products.dart';

final dummyProducts = [
  Product(
      id: '1',
      condition: 'Usado',
      createdOn: DateTime.now(),
      delivery: 'Entrega',
      description:
          'Put the spaghetti into the boiling water - they should be done in about 10 to 12 minutes.',
      title: 'Spagethti',
      tradable: true,
      zap: '991116269',
      imageUrl: [
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
        'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      ],
      price: 99.55),
  Product(
    id: '2',
    condition: 'Novo',
    createdOn: DateTime.now(),
    delivery: 'Buscar',
    price: 55.98,
    description:
        'Conan Exiles é um jogo de sobrevivência em mundo aberto ambientado nas terras brutais de Conan, o Bárbaro. Sobreviva em um mundo hostil, construa seu reino e subjugue seus inimigos em combates brutais e conflitos épicos.',
    title: 'Conan',
    tradable: false,
    zap: '991116269',
    imageUrl: [
      'https://cdn-istoe-ssl.akamaized.net/wp-content/uploads/sites/14/2016/01/mi_6205498677630722.jpg',
      'https://rika.vteximg.com.br/arquivos/ids/236015-1000-1000/-herois_abril_etc-espada-selvagem-conan-reed-044.jpg',
      'http://1.bp.blogspot.com/_vNPRdItYCdY/Sw1aaoKLlVI/AAAAAAAAAiI/pIOfrZ4DttE/s1600/SSOC74.jpg',
    ],
  ),
];
