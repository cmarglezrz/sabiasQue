#import "GestorCuriosidades.h"

@interface GestorCuriosidades ()

// Curiosidades organizadas por categoría.
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *datos;

// Guarda la posición actual de cada categoría.
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *posiciones;

@end

@implementation GestorCuriosidades

#pragma mark - Inicialización

- (instancetype)init {

    self = [super init];

    if (self) {

        // Datos curiosos de cada categoría.
        self.datos = @{

            @"Arte": @[
                @"La noche estrellada fue pintada por Vincent van Gogh en 1889.",
                @"El pigmento ultramarino se obtenía tradicionalmente del lapislázuli.",
                @"La Mona Lisa fue pintada por Leonardo da Vinci a principios del siglo XVI.",
                @"El impresionismo recibió su nombre de una pintura de Claude Monet."
            ],

            @"Tecnología": @[
                @"El primer ratón de computadora se construyó con una carcasa de madera.",
                @"El primer sitio web se puso en línea en 1991.",
                @"El primer mensaje enviado por ARPANET fue «LO».",
                @"El código QR fue inventado en Japón en 1994."
            ],

            @"Naturaleza": @[
                @"Los pulpos tienen tres corazones.",
                @"Los tiburones existen desde mucho antes que los árboles.",
                @"Las mariposas pueden percibir sabores mediante receptores en sus patas.",
                @"Los ajolotes pueden regenerar extremidades y partes de algunos órganos."
            ]
        };

        // Inicializar las posiciones de las curiosidades.
        self.posiciones = [NSMutableDictionary dictionary];
    }

    return self;
}

#pragma mark - Obtener dato curioso

- (NSString *)obtenerDato:(NSString *)categoria {

    // Obtener las curiosidades de la categoría seleccionada.
    NSArray<NSString *> *lista = self.datos[categoria];

    // Comprobar que existan curiosidades disponibles.
    if (lista.count == 0) {
        return @"No hay datos disponibles.";
    }

    // Consultar la posición de la siguiente curiosidad.
    NSUInteger posicion =
        [self.posiciones[categoria] unsignedIntegerValue]
        % lista.count;

    // Obtener el dato correspondiente.
    NSString *dato = lista[posicion];

    // Avanzar a la siguiente curiosidad.
    self.posiciones[categoria] =
        @((posicion + 1) % lista.count);

    return dato;
}

@end
