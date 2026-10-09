
#import "ViewController.h"
#import "GestorCuriosidades.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *categoria;
@property (nonatomic, strong) GestorCuriosidades *gestor;

@property (nonatomic, weak) IBOutlet UIView *pantallaInicio;
@property (nonatomic, weak) IBOutlet UIView *pantallaDatos;

@property (nonatomic, weak) IBOutlet UIButton *botonMostrar;
@property (nonatomic, weak) IBOutlet UIButton *botonArte;
@property (nonatomic, weak) IBOutlet UIButton *botonTecnologia;
@property (nonatomic, weak) IBOutlet UIButton *botonNaturaleza;
@property (nonatomic, weak) IBOutlet UIButton *botonOtroDato;
@property (nonatomic, weak) IBOutlet UIButton *botonVolver;

@property (nonatomic, weak) IBOutlet UILabel *categoriaLabel;
@property (nonatomic, weak) IBOutlet UILabel *datoLabel;
@property (nonatomic, weak) IBOutlet UIView *tarjeta;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gestor = [[GestorCuriosidades alloc] init];

    [self configurarDiseno];
    [self mostrarInicio];

    // Esto fue para hacer algunas pruebas con Github Actions.
    NSArray<NSString *> *argumentos =
        [NSProcessInfo processInfo].arguments;

    if ([argumentos containsObject:@"-captura-arte"] ||
        [argumentos containsObject:@"-captura-datos"]) {
        [self elegirCategoria:@"Arte"];
        [self irADatos:nil];

    } else if ([argumentos containsObject:@"-captura-tecnologia"]) {
        [self elegirCategoria:@"Tecnología"];
        [self irADatos:nil];

    } else if ([argumentos containsObject:@"-captura-naturaleza"]) {
        [self elegirCategoria:@"Naturaleza"];
        [self irADatos:nil];
    }
}


   /// Cambia el color del marco segun la categoría sellecionada.
#pragma mark - Diseño

- (UIColor *)colorConRojo:(CGFloat)rojo
                    verde:(CGFloat)verde
                     azul:(CGFloat)azul {
    return [UIColor colorWithRed:rojo / 255.0
                          green:verde / 255.0
                           blue:azul / 255.0
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

- (void)configurarBoton:(UIButton *)boton {
    boton.layer.cornerRadius = 18;
    boton.clipsToBounds = YES;
}


- (void)configurarDiseno {
    for (UIButton *boton in @[
        self.botonArte,
        self.botonTecnologia,
        self.botonNaturaleza,
        self.botonMostrar,
        self.botonOtroDato,
        self.botonVolver
    ]) {
        [self configurarBoton:boton];
    }

    self.categoriaLabel.layer.cornerRadius = 15;
    self.categoriaLabel.clipsToBounds = YES;

    self.tarjeta.layer.cornerRadius = 22;
    self.tarjeta.layer.borderWidth = 2;
    self.tarjeta.backgroundColor =
        [[UIColor whiteColor] colorWithAlphaComponent:0.90];
}

#pragma mark - Inicio

- (void)mostrarInicio {
    self.categoria = nil;

    self.pantallaInicio.hidden = NO;
    self.pantallaDatos.hidden = YES;

    self.botonMostrar.enabled = NO;
    self.botonMostrar.alpha = 0.55;

    for (UIButton *boton in @[
        self.botonArte,
        self.botonTecnologia,
        self.botonNaturaleza
    ]) {
        boton.layer.borderWidth = 0;
    }
}

- (void)elegirCategoria:(NSString *)categoria {
    self.categoria = categoria;

    self.botonMostrar.enabled = YES;
    self.botonMostrar.alpha = 1.0;

    NSDictionary<NSString *, UIButton *> *botones = @{
        @"Arte": self.botonArte,
        @"Tecnología": self.botonTecnologia,
        @"Naturaleza": self.botonNaturaleza
    };

    for (NSString *nombre in botones) {
        UIButton *boton = botones[nombre];

        boton.layer.borderWidth =
            [nombre isEqualToString:categoria] ? 2.5 : 0;

        boton.layer.borderColor =
            [self colorConRojo:182 verde:70 azul:153].CGColor;
    }
}

#pragma mark - Acciones de categorías

- (IBAction)elegirArte:(id)sender {
    [self elegirCategoria:@"Arte"];
}

- (IBAction)elegirTecnologia:(id)sender {
    [self elegirCategoria:@"Tecnología"];
}

- (IBAction)elegirNaturaleza:(id)sender {
    [self elegirCategoria:@"Naturaleza"];
}

#pragma mark - Curiosidades

- (IBAction)irADatos:(id)sender {
    if (self.categoria == nil) {
        return;
    }

    self.categoriaLabel.text = [self.categoria uppercaseString];

    UIColor *color = [self colorCategoria:self.categoria];
    self.categoriaLabel.backgroundColor = color;
    self.tarjeta.layer.borderColor = color.CGColor;

    self.pantallaInicio.hidden = YES;
    self.pantallaDatos.hidden = NO;

    [self mostrarOtroDato:nil];
}

- (IBAction)mostrarOtroDato:(id)sender {
    self.datoLabel.text =
        [self.gestor obtenerDato:self.categoria];
}

- (IBAction)volverAlInicio:(id)sender {
    [self mostrarInicio];
}

@end
