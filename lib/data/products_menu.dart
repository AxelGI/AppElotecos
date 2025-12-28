import '../models/product.dart';
import '../utils/constants.dart';

List<Product> getProductsList() {
  return [
    Product(
      name: 'Presioname',
      sizes: ['Selecciona'],
      prices: [],
      extras: ['Seleciona'],
    ),
    ////////ELOTES/////
    Product(
      name: 'Elote',
      sizes: ['natural', 'clasico', 'loco', 'papalote'],
      prices: [30, 35, 45, 60],
      fritura: frituras,
      bolsapapa: [
        'chetos flamin\' hot',
        'doritos',
        'takis',
        'ruffles',
        'cheto naranja',
        'tostito',
        'sabritas originales'
      ],
      extras: extraslista,
    ),
    Product(
      name: 'Charola eloteco',
      sizes: ['clasico', 'loco'],
      prices: [85, 95],
      extras: extraslista,
      fritura: frituras,
      bolsapapa: [
        'chetos flaming',
        'doritos',
        'takis',
        'ruffles',
        'cheto naranja',
        'tostito',
        'sabritas originales'
      ],
    ),
    Product(
      name: 'Costillitas',
      sizes: ['único'],
      prices: [65],
      extras: ['inglesa', 'maggy', 'ranch', 'tajin'],
      fritura: ['parmesano', 'lemon & pepper', 'BBQ', 'Mango habanero'],
    ),
    ////////////////////
    ///////////ESQUITE////////////
    Product(
      name: 'Tosti esquite',
      sizes: ['verde', 'morado'],
      prices: [60, 60],
      extras: extraslista,
    ),
    Product(
      name: 'Dori esquite',
      sizes: ['rojos', 'negros', 'morados'],
      prices: [60, 60, 60],
      extras: extraslista,
    ),
    Product(
      name: 'Esquite natural',
      sizes: size,
      prices: [30, 50],
      extras: extraslista,
    ),
    Product(
      name: 'Esquite clasico',
      sizes: size,
      prices: [35, 55],
      extras: extraslista,
    ),
    Product(
      name: 'Esquite loco',
      sizes: size,
      prices: [45, 65],
      fritura: frituras,
      extras: extraslista,
    ),
    Product(
      name: 'Papa esquite',
      sizes: size,
      prices: [60, 80],
      fritura: frituras,
      bolsapapa: [
        'chetos flaming',
        'doritos',
        'takis',
        'ruffles',
        'cheto naranja',
        'tostito',
        'sabritas originales'
      ],
      extras: extraslista,
    ),
    Product(
      name: 'Esquite suadero',
      sizes: size,
      prices: [55, 80],
      extras: extrascarne,
    ),
    Product(
      name: 'Esquite pastor',
      sizes: size,
      prices: [55, 80],
      extras: extrascarne,
    ),
    Product(
      name: 'Esquite cambray',
      sizes: size,
      prices: [50, 75],
      extras: extrascarne,
    ),
    //////
    // /////MARUCHAN/////////////
    Product(
      name: 'Maruchan',
      sizes: ['clasica', 'esquite y fritura', 'esquisopa loca', 'suadero', 'pastor', 'sin esquite'],
      prices: [60, 70, 85, 85, 85, 35],
      extras: extrascarne,
      sopa: ['pollo', 'camaron', 'habanero', 'piquin', 'res'],
      fritura: frituras,
      bolsapapa: [
        'chetos flaming',
        'doritos',
        'takis',
        'ruffles',
        'cheto naranja',
        'tostito',
        'sabritas originales'
      ],
    ),
    //////////////////////
    /////////SNACKS/////////
    Product(
      name: 'Papas locas',
      sizes: ['unico'],
      prices: [60],
      bolsapapa: ['naturales', 'queso', 'adobadas', 'chipotle'],
      extras: extraslista,
    ),
    Product(
      name: 'Nachos',
      sizes: ['sencillos', 'pastor', 'suadero', 'con esquite', 'con esquite y carne'],
      prices: [50, 75, 75, 70, 85],
      extras: extrascarne,
    ),
    ////////////
    /////BEBIDAS/////
    Product(
      name: 'Bebida preparada',
      sizes: ['vaso', 'patibanera'],
      prices: [45, 80],
      bebida: ['ameyal', 'sangria', 'azulito', 'moradito', 'squirt', 'agua mineral', 'boing', 'arizona'],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Pati Bañera',
      sizes: ['unico'],
      prices: [80],
      bebida: ['ameyal', 'sangria', 'azulito', 'moradito', 'squirt', 'agua mineral', 'boing', 'arizona'],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Arizona',
      sizes: ['normal'],
      prices: [25],
      bebida: ['mango', 'sandía', 'fresa kiwi', 'té verde', 'ponche'],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Arizona loco',
      sizes: ['mango', 'fresa'],
      prices: [75, 75],
      fritura: [
        'cacahuate enchilado',
        'cacahuate normal',
        'lombrices',
        'gomita circulo',
        'mangito enchilado'
      ],
      bebida: ['mango', 'sandía', 'fresa kiwi', 'té verde', 'ponche'],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Clamateco',
      sizes: ['unico'],
      prices: [50],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Refrescos',
      sizes: ['coca-cola 600ml', 'squirt 600ml', 'sprite 600ml', 'sangria 600ml'],
      prices: [25, 25, 25, 25],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Boing 500ml',
      sizes: ['mango', 'manzana', 'uva', 'fresa'],
      prices: [25, 25, 25, 25],
      extras: ['limon', 'popote'],
    ),
    Product(
      name: 'Agua',
      sizes: ['natural'],
      prices: [15],
      extras: ['limon', 'popote'],
    ),
    ////CORNDOG///
    Product(
      name: 'Banderilla salada',
      sizes: ['salchicha de pavo', 'queso con salchicha', 'queso gouda'],
      prices: [40, 45, 50],
      fritura: ['panko', 'koreana', 'ramen', 'doritos', 'takis', 'ruffles', 'chetos flaming'],
      extras: ['catsup', 'salsa'],
    ),
    Product(
      name: 'Banderilla dulce',
      sizes: ['kinder delice', 'milky way', 'choco rol', 'mamut', 'bubulubu'],
      prices: [35, 35, 30, 35, 35],
      extras: ['chocolate'],
    ),
    Product(
      name: 'Papas francesa',
      sizes: ['clasicas', 'gajo', 'curly', 'waffle'],
      prices: [45, 50, 50, 50],
      extras: ['catsup', 'queso amarillo'],
    ),
  ];
}

// Opcional: Clase para manejar los productos como un repositorio
class ProductsRepository {
  static List<Product> getAllProducts() {
    return getProductsList();
  }

  static Product? findProductByName(String name) {
    return getProductsList().firstWhere((product) => product.name == name);
  }

  static List<Product> getProductsByCategory(String category) {
    // Puedes implementar lógica para categorizar productos
    return getProductsList().where((product) {
      // Lógica de categorización basada en el nombre
      if (category == 'Elotes') {
        return product.name.contains('Elote') || product.name.contains('Esquite');
      } else if (category == 'Bebidas') {
        return product.name.contains('Bebida') ||
            product.name.contains('Refresco') ||
            product.name.contains('Agua') ||
            product.name.contains('Arizona') ||
            product.name.contains('Clamateco') ||
            product.name.contains('Boing');
      } else if (category == 'Snacks') {
        return product.name.contains('Papas') ||
            product.name.contains('Nachos') ||
            product.name.contains('Banderilla');
      } else if (category == 'Maruchan') {
        return product.name.contains('Maruchan');
      }
      return false;
    }).toList();
  }
}