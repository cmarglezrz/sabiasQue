
#import "ViewController.h"
#import "GestorCuriosidades.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *categoria;
@property (nonatomic, strong) GestorCuriosidades *gestor;

@property (nonatomic, strong) UIView *contenido;
@property (nonatomic, strong) UILabel *datoLabel;
@property (nonatomic, strong) UIButton *botonMostrar;
@property (nonatomic, strong) NSDictionary<NSString *, UIButton *> *botonesCategorias;

@end

@implementation ViewController

#pragma mark - Inicio

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    // Inicializar el gestor de curiosidades.
    self.gestor = [[GestorCuriosidades alloc] init];

    // Pantalla principal.
    [self mostrarInicio];

    // Notita: Agregué esto para las pruebas que hice en GitHub Actions
    
    NSArray<NSString *> *argumentos = [NSProcessInfo processInfo].arguments;

if ([argumentos containsObject:@"-captura-arte"] ||
    [argumentos containsObject:@"-captura-datos"]) {
    [self elegirArte];
    [self irADatos];

} else if ([argumentos containsObject:@"-captura-tecnologia"]) {
    [self elegirTecnologia];
    [self irADatos];

} else if ([argumentos containsObject:@"-captura-naturaleza"]) {
    [self elegirNaturaleza];
    [self irADatos];
}

}


    /// Asignar colores a las categorías, etc. 

#pragma mark - Colores

- (UIColor *)colorConRojo:(CGFloat)r
                    verde:(CGFloat)g
                     azul:(CGFloat)b {

    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:1.0];
}

- (UIColor *)colorCategoria:(NSString *)categoria {

    if ([categoria isEqualToString:@"Arte"]) {
        return [self colorConRojo:249 verde:211 azul:157];
    }

    if ([categoria isEqualToString:@"Tecnología"]) {
        return [self colorConRojo:221 verde:249 azul:237];
    }

    return [self colorConRojo:218 verde:169 azul:244];
}

#pragma mark - Componentes de interfaz

- (UILabel *)etiqueta:(NSString *)texto
               tamano:(CGFloat)tamano
              negrita:(BOOL)negrita {

    UILabel *label = [[UILabel alloc] init];

    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = texto;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];

    label.font = negrita
        ? [UIFont boldSystemFontOfSize:tamano]
        : [UIFont systemFontOfSize:tamano];

    label.numberOfLines = 0;

    return label;
}

- (UIButton *)boton:(NSString *)titulo
              color:(UIColor *)color
             accion:(SEL)accion {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setTitle:titulo forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];

    button.backgroundColor = color;
    button.layer.cornerRadius = 18;

    [button addTarget:self
               action:accion
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark - Preparar pantalla y fondo

- (void)prepararPantalla {

    // Este es para eliminar el contenido de la pantalla anterior.
    [self.contenido removeFromSuperview];

    UIView *panel = [[UIView alloc] init];

    panel.translatesAutoresizingMaskIntoConstraints = NO;
    panel.backgroundColor = [UIColor clearColor];

    [self.view addSubview:panel];

    [NSLayoutConstraint activateConstraints:@[
        [panel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [panel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [panel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [panel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    // Agregar la imagen de fondo.
    UIImage *imagen = [UIImage imageNamed:@"fondo"];

    if (imagen != nil) {

        UIImageView *fondo = [[UIImageView alloc] initWithImage:imagen];

        fondo.translatesAutoresizingMaskIntoConstraints = NO;
        fondo.contentMode = UIViewContentModeScaleAspectFill;
        fondo.clipsToBounds = YES;

        [panel addSubview:fondo];

        [NSLayoutConstraint activateConstraints:@[
            [fondo.topAnchor constraintEqualToAnchor:panel.topAnchor],
            [fondo.bottomAnchor constraintEqualToAnchor:panel.bottomAnchor],
            [fondo.leadingAnchor constraintEqualToAnchor:panel.leadingAnchor],
            [fondo.trailingAnchor constraintEqualToAnchor:panel.trailingAnchor]
        ]];
    }

    self.contenido = panel;
}

#pragma mark - Pantalla principal

- (void)mostrarInicio {

    self.categoria = nil;

    [self prepararPantalla];

    UILabel *titulo =
        [self etiqueta:@"¿Sabías qué?"
                tamano:27
               negrita:YES];

    UILabel *subtitulo =
        [self etiqueta:@"Elige una categoría"
                tamano:15
               negrita:NO];

    UIButton *arte =
        [self boton:@"ARTE"
              color:[self colorConRojo:246 verde:155 azul:211]
             accion:@selector(elegirArte)];

    UIButton *tecnologia =
        [self boton:@"TECNOLOGÍA"
              color:[self colorCategoria:@"Tecnología"]
             accion:@selector(elegirTecnologia)];

    UIButton *naturaleza =
        [self boton:@"NATURALEZA"
              color:[self colorCategoria:@"Naturaleza"]
             accion:@selector(elegirNaturaleza)];

    UIButton *mostrar =
        [self boton:@"MOSTRAR DATO"
              color:[self colorConRojo:0 verde:204 azul:226]
             accion:@selector(irADatos)];

    mostrar.enabled = NO;
    mostrar.alpha = 0.55;

    for (UIView *vista in @[
        titulo,
        subtitulo,
        arte,
        tecnologia,
        naturaleza,
        mostrar
    ]) {
        [self.contenido addSubview:vista];
    }

    [NSLayoutConstraint activateConstraints:@[

        [titulo.topAnchor constraintEqualToAnchor:self.contenido.topAnchor constant:65],
        [titulo.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],

        [subtitulo.topAnchor constraintEqualToAnchor:titulo.bottomAnchor constant:30],
        [subtitulo.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],

        [arte.centerYAnchor constraintEqualToAnchor:self.contenido.centerYAnchor constant:-30],
        [arte.trailingAnchor constraintEqualToAnchor:self.contenido.centerXAnchor constant:-8],
        [arte.widthAnchor constraintEqualToConstant:115],
        [arte.heightAnchor constraintEqualToConstant:46],

        [tecnologia.centerYAnchor constraintEqualToAnchor:arte.centerYAnchor],
        [tecnologia.leadingAnchor constraintEqualToAnchor:self.contenido.centerXAnchor constant:8],
        [tecnologia.widthAnchor constraintEqualToConstant:132],
        [tecnologia.heightAnchor constraintEqualToConstant:46],

        [naturaleza.topAnchor constraintEqualToAnchor:arte.bottomAnchor constant:12],
        [naturaleza.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],
        [naturaleza.widthAnchor constraintEqualToConstant:145],
        [naturaleza.heightAnchor constraintEqualToConstant:46],

        [mostrar.bottomAnchor constraintEqualToAnchor:self.contenido.bottomAnchor constant:-75],
        [mostrar.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],
        [mostrar.widthAnchor constraintEqualToConstant:190],
        [mostrar.heightAnchor constraintEqualToConstant:52]
    ]];

    self.botonMostrar = mostrar;

    self.botonesCategorias = @{
        @"Arte": arte,
        @"Tecnología": tecnologia,
        @"Naturaleza": naturaleza
    };
}

#pragma mark - Selección de categoría

- (void)elegirArte {
    [self elegir:@"Arte"];
}

- (void)elegirTecnologia {
    [self elegir:@"Tecnología"];
}

- (void)elegirNaturaleza {
    [self elegir:@"Naturaleza"];
}

- (void)elegir:(NSString *)categoria {

    self.categoria = categoria;

    self.botonMostrar.enabled = YES;
    self.botonMostrar.alpha = 1.0;

    for (NSString *clave in self.botonesCategorias) {

        UIButton *boton = self.botonesCategorias[clave];

        boton.layer.borderWidth =
            [clave isEqualToString:categoria] ? 2.5 : 0;

        boton.layer.borderColor =
            [self colorConRojo:182 verde:70 azul:153].CGColor;
    }
}

#pragma mark - Pantalla de curiosidades

- (void)irADatos {

    if (self.categoria == nil) {
        return;
    }

    [self prepararPantalla];

    UILabel *titulo =
        [self etiqueta:@"¿Sabías qué?"
                tamano:27
               negrita:YES];

    UILabel *categoria =
        [self etiqueta:[self.categoria uppercaseString]
                tamano:15
               negrita:YES];

    categoria.backgroundColor =
        [self colorCategoria:self.categoria];

    categoria.layer.cornerRadius = 15;
    categoria.layer.masksToBounds = YES;

    UIView *tarjeta = [[UIView alloc] init];

    tarjeta.translatesAutoresizingMaskIntoConstraints = NO;
    tarjeta.backgroundColor =
        [[UIColor whiteColor] colorWithAlphaComponent:0.90];

    tarjeta.layer.borderWidth = 2;

    tarjeta.layer.borderColor =
        [self colorCategoria:self.categoria].CGColor;

    tarjeta.layer.cornerRadius = 22;

    self.datoLabel =
        [self etiqueta:@""
                tamano:17
               negrita:NO];

    UIButton *otro =
        [self boton:@"MOSTRAR DATO"
              color:[self colorConRojo:0 verde:204 azul:226]
             accion:@selector(mostrarOtroDato)];

    UIButton *volver =
        [self boton:@"CAMBIAR CATEGORÍA"
              color:[self colorCategoria:@"Tecnología"]
             accion:@selector(mostrarInicio)];

    for (UIView *vista in @[
        titulo,
        categoria,
        tarjeta,
        otro,
        volver
    ]) {
        [self.contenido addSubview:vista];
    }

    [tarjeta addSubview:self.datoLabel];

    [NSLayoutConstraint activateConstraints:@[

        [titulo.topAnchor constraintEqualToAnchor:self.contenido.topAnchor constant:65],
        [titulo.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],

        [categoria.topAnchor constraintEqualToAnchor:titulo.bottomAnchor constant:32],
        [categoria.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],
        [categoria.widthAnchor constraintEqualToConstant:165],
        [categoria.heightAnchor constraintEqualToConstant:43],

        [tarjeta.centerYAnchor constraintEqualToAnchor:self.contenido.centerYAnchor constant:15],
        [tarjeta.leadingAnchor constraintEqualToAnchor:self.contenido.leadingAnchor constant:28],
        [tarjeta.trailingAnchor constraintEqualToAnchor:self.contenido.trailingAnchor constant:-28],
        [tarjeta.heightAnchor constraintEqualToConstant:230],

        [self.datoLabel.leadingAnchor constraintEqualToAnchor:tarjeta.leadingAnchor constant:20],
        [self.datoLabel.trailingAnchor constraintEqualToAnchor:tarjeta.trailingAnchor constant:-20],
        [self.datoLabel.centerYAnchor constraintEqualToAnchor:tarjeta.centerYAnchor],

        [otro.topAnchor constraintEqualToAnchor:tarjeta.bottomAnchor constant:28],
        [otro.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],
        [otro.widthAnchor constraintEqualToConstant:190],
        [otro.heightAnchor constraintEqualToConstant:52],

        [volver.topAnchor constraintEqualToAnchor:otro.bottomAnchor constant:20],
        [volver.centerXAnchor constraintEqualToAnchor:self.contenido.centerXAnchor],
        [volver.widthAnchor constraintEqualToConstant:190],
        [volver.heightAnchor constraintEqualToConstant:48]
    ]];

    // Mostrar la primera curiosidad de la categoría.
    [self mostrarOtroDato];
}

#pragma mark - Mostrar curiosidad

- (void)mostrarOtroDato {

    // Pide la siguiente curiosidad al gestor.
    self.datoLabel.text =
        [self.gestor obtenerDato:self.categoria];
}

@end
