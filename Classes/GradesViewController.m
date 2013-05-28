//
//  GradesViewController.m
//  Argumento
//
//  Created by Pedro Góes on 28/05/13.
//
//

#import "GradesViewController.h"
#import "DataController.h"
#import "Constantes.h"
#import "NUIRenderer.h"

@interface GradesViewController ()

@property (assign, nonatomic) BOOL shouldMoveKeyboardUp;
@property (assign, nonatomic) CGFloat moveKeyboardRatio;
@property (assign, nonatomic) BOOL isUp;

@end

@implementation GradesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shouldMoveKeyboardUp = YES;
        _moveKeyboardRatio = 1.0;
        _isUp = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Iniciar cálculo!" style:UIBarButtonItemStylePlain target:self action:@selector(iniciarCalculoArgumento)];
    [NUIRenderer renderBarButtonItem:self.navigationItem.rightBarButtonItem];
    
    // Inicia o formatter (para formatar os números)
    self.formatter = [[NSNumberFormatter alloc] init];
	[self.formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[self.formatter setMaximumFractionDigits:2];
    
    linguaPrimeiraSerie.momentary = NO;
	linguaSegundaSerie.momentary = NO;
	linguaTerceiraSerie.momentary = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    
    self.formatter = nil;
}

#pragma mark - Keyboard Notifications

- (CGRect) calculateKeyboardFrame:(NSNotification*)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    
    return keyboardFrameConverted;
    
    // keyboard frame is in window coordinates
    //	NSDictionary *userInfo = [notification userInfo];
    //	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //	// convert own frame to window coordinates, frame is in superview's coordinates
    //	CGRect ownFrame = [self.view.window convertRect:self.view.frame fromView:self.view.superview];
    //
    //	// calculate the area of own frame that is covered by keyboard
    //	CGRect coveredFrame = CGRectIntersection(ownFrame, keyboardFrame);
    //
    //	// now this might be rotated, so convert it back
    //	coveredFrame = [self.view.window convertRect:coveredFrame toView:self.view.superview];
    
    return keyboardFrame;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    // Only go up if the view is still DOWN and we should move the keyboard up
    if (!_isUp && _shouldMoveKeyboardUp) {
        [self moveViewUp:YES withNotification:notification];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Only go down if the view is UP
    if (_isUp) {
        [self moveViewUp:NO withNotification:notification];
    }
}


- (void)moveViewUp:(BOOL)moveUp withNotification:(NSNotification*)notification {
    // Move the view up/down whenever the keyboard is shown/dismissed
    
    // Set our property
    self.isUp = moveUp;
    
    CGRect keyboardFrame = [self calculateKeyboardFrame:notification];
    
    // We apply the transformation bound to the screen pixel density
    CGFloat offset = keyboardFrame.size.height * (_moveKeyboardRatio / [[UIScreen mainScreen] scale]);
    CGRect rect = self.view.frame;
    
    if (self.tabBarController) {
        offset -= self.tabBarController.tabBar.frame.size.height;
    }
    
    if (moveUp) {
        rect.origin.y -= offset;
    } else {
        rect.origin.y += offset;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = rect;
    }];
}

#pragma mark - User Methods

- (IBAction)serieSelecionada {
    // Modifica a GUI de acordo com a série selecionada pelo usuário
    
	NSInteger s = [serie selectedSegmentIndex];
	
	// Quando s >= kPrimeiraSerie, nenhum campo será modificado, logo não devemos colocá-lo na condição;
	
	if (s >= kSegundaSerie) {
		labelPrimeiraSerie.hidden = NO;
		provaPrimeiraSerie.hidden = NO;
		linguaPrimeiraSerie.hidden = NO;
	} else {
		labelPrimeiraSerie.hidden = YES;
		provaPrimeiraSerie.hidden = YES;
		linguaPrimeiraSerie.hidden = YES;
	}
    
	
	if (s >= kTerceiraSerie) {
		labelSegundaSerie.hidden = NO;
		provaSegundaSerie.hidden = NO;
		linguaSegundaSerie.hidden = NO;
	} else {
		labelSegundaSerie.hidden = YES;
		provaSegundaSerie.hidden = YES;
		linguaSegundaSerie.hidden = YES;
	}
    
	
	if (s >= kCompleto) {
		labelTerceiraSerie.hidden = NO;
		provaTerceiraSerie.hidden = NO;
		linguaTerceiraSerie.hidden = NO;
	} else {
		labelTerceiraSerie.hidden = YES;
		provaTerceiraSerie.hidden = YES;
		linguaTerceiraSerie.hidden = YES;
	}
}

- (IBAction)iniciarCalculoArgumento {
	
	double proporcao = 0.12;	// Proporção lingua estrangeira / total
	double base = 10.0;			// Base para cálculo argumento
	double peso = 0.08;			// Peso da prova de língua estrangeira em relação ao resto
	int level = 0;				// Número de provas realizadas até agora
	int pesosRestantes = 6;		// Soma de todos os pesos (1 + 2 + 3)
	
	double arg1, arg2, arg3;
	double argFinal = 0.0;
	
	double media11, media12, desvio11, desvio12;
	double media21, media22, desvio21, desvio22;
	double media31, media32, desvio31, desvio32;
    
    double prop1 = 1.0, prop2 = 1.0, prop3 = 1.0;
    
    if (!labelPrimeiraSerie.hidden) {
		level = 1;
	}
	
	if (!labelSegundaSerie.hidden) {
		level = 2;
	}
	
	if (!labelTerceiraSerie.hidden) {
		level = 3;
	}
    
    /* Iremos definir aqui as proporções entre as notas anteriores e as atuais
     Temos que definir apenas para os casos 1 e 2.
     Para o caso 0 (em que o candidato ainda não realizou a primeira etapa), não temos como saber se a prova será fácil ou difícil, logo é impossível deduzir a proporção.
     Para o caso 3 (em que o candidado já realizou as três etapas), a base de dados já está pronta para ser acessada e por isso não precisamos calcular nenhuma proporção.
     
     Nos dois outros casos (1 e 2), vamos carregar os valores do xml e dividí-los para obter a proporção procurada.
     
     */
    
    if (level == 1) {
        // Caso em que o candidato já fez a primeira etapa do subprograma
        NSArray * arrayA = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Primeira - Base 1"]];
        NSArray * arrayB = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Primeira - Base 3"]];
        prop1 = ([[arrayA objectAtIndex:10] doubleValue] / [[arrayB objectAtIndex:0] doubleValue]);
        prop2 = (3.0 - prop1) / 2.0;
        prop3 = prop2;
        [arrayA release];
        [arrayB release];
    }
    
    if (level == 2) {
        // Caso em que o candidato já fez a primeira e segundas etapas do subprograma
        NSArray * arrayA1 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Primeira - Base 1"]];
        NSArray * arrayA2 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Segunda - Base 1"]];
        NSArray * arrayB1 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Primeira - Base 2"]];
        NSArray * arrayB2 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Segunda - Base 2"]];
        prop1 = ([[arrayA1 objectAtIndex:10] doubleValue] / [[arrayB1 objectAtIndex:0] doubleValue]);
        prop2 = ([[arrayA2 objectAtIndex:10] doubleValue] / [[arrayB2 objectAtIndex:0] doubleValue]);
        prop3 = 3.0 - prop1 - prop2;
        [arrayA1 release];
        [arrayA2 release];
        [arrayB1 release];
        [arrayB2 release];
    }
    
    
	NSArray * array1 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Primeira - Base 1"]];
	double notaPrimeira = ([[provaPrimeiraSerie.text stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue] * prop1);
	media11 = [[array1 objectAtIndex:linguaPrimeiraSerie.selectedSegmentIndex*2] doubleValue];
	media12 = [[array1 objectAtIndex:6] doubleValue];
	desvio11 = [[array1 objectAtIndex:linguaPrimeiraSerie.selectedSegmentIndex*2+1] doubleValue];
	desvio12 = [[array1 objectAtIndex:7] doubleValue];
	double arg11 = ((notaPrimeira * proporcao) - media11) / desvio11 * base;
	double arg12 = ((notaPrimeira * (1 - proporcao)) - media12) / desvio12 * base;
	arg1 = (arg11 * peso) + (arg12 * (1 - peso));
	[array1 release];
	
	NSArray * array2 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Segunda - Base 1"]];
	double notaSegunda = ([[provaSegundaSerie.text stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue] * prop2);
	media21 = [[array2 objectAtIndex:linguaSegundaSerie.selectedSegmentIndex*2] doubleValue];
	media22 = [[array2 objectAtIndex:6] doubleValue];
	desvio21 = [[array2 objectAtIndex:linguaSegundaSerie.selectedSegmentIndex*2+1] doubleValue];
	desvio22 = [[array2 objectAtIndex:7] doubleValue];
	double arg21 = ((notaSegunda * proporcao) - media21) / desvio21 * base;
	double arg22 = ((notaSegunda * (1 - proporcao)) - media22) / desvio22 * base;
	arg2 = (arg21 * peso) + (arg22 * (1 - peso));
	[array2 release];
	
	NSArray * array3 = [[NSArray alloc] initWithArray:[[[DataController sharedInstance] dicionarioMedias] objectForKey:@"Terceira - Base 1"]];
	double notaTerceira = ([[provaTerceiraSerie.text stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue] * prop3);
	media31 = [[array3 objectAtIndex:linguaTerceiraSerie.selectedSegmentIndex*2] doubleValue];
	media32 = [[array3 objectAtIndex:6] doubleValue];
	desvio31 = [[array3 objectAtIndex:linguaTerceiraSerie.selectedSegmentIndex*2+1] doubleValue];
	desvio32 = [[array3 objectAtIndex:7] doubleValue];
	double arg31 = ((notaTerceira * proporcao) - media31) / desvio31 * base;
	double arg32 = ((notaTerceira * (1 - proporcao)) - media32) / desvio32 * base;
	arg3 = (arg31 * peso) + (arg32 * (1 - peso));
	[array3 release];
	
	if (level >= 1) {
		argFinal += 1*arg1;
		pesosRestantes -= 1;
	}
	
	if (level >= 2) {
		argFinal += 2*arg2;
		pesosRestantes -= 2;
	}
	
	if (level >= 3) {
		argFinal += 3*arg3;
		pesosRestantes -= 3;
	}
	
	if (pesosRestantes == 0 && level == 3) {
		if (([[[[DataController sharedInstance] argumentos] objectAtIndex:0] doubleValue] - argFinal) <= 0) {
			argumentoMinimoFinal.text = @"Aprovado";
		} else {
			argumentoMinimoFinal.text = @"Não aprovado";
		}
        
	} else {
		
		double deltaMinimo0 = 0.0, deltaMaximo0 = 0.0, xMinimo0 = 0.0, xMaximo0 = 0.0;
		double deltaMinimo1 = 0.0, deltaMaximo1 = 0.0, xMinimo1 = 0.0, xMaximo1 = 0.0;
		double deltaMinimo2 = 0.0, deltaMaximo2 = 0.0, xMinimo2 = 0.0, xMaximo2 = 0.0;
		
		// Favor checar valor dos números caso ocorram mudanças
		
		double min = ([[[[DataController sharedInstance] argumentos] objectAtIndex:0] doubleValue] - argFinal);
		double max = ([[[[DataController sharedInstance] argumentos] objectAtIndex:1] doubleValue] - argFinal);
		
		
		// Formato para cálculo: const * proporcao * peso
		if (level == 2) {
			deltaMinimo2 = min * (1.0 / 1.0) / 3.0;
			deltaMaximo2 = max * (1.0 / 1.0) / 3.0;
		} else if (level == 1) {
			deltaMinimo2 = min * (3.0 / 5.0) / 3.0;
			deltaMaximo2 = max * (3.0 / 5.0) / 3.0;
			
			deltaMinimo1 = min * (2.0 / 5.0) / 2.0;
			deltaMaximo1 = max * (2.0 / 5.0) / 2.0;
		} else if (level == 0) {
			deltaMinimo2 = min * (3.0 / 6.0) / 3.0;
			deltaMaximo2 = max * (3.0 / 6.0) / 3.0;
			
			deltaMinimo1 = min * (2.0 / 6.0) / 2.0;
			deltaMaximo1 = max * (2.0 / 6.0) / 2.0;
			
			deltaMinimo0 = min * (1.0 / 6.0) / 1.0;
			deltaMaximo0 = max * (1.0 / 6.0) / 1.0;
		}
        
        
		
		if (level <= 2) {
			
			// Invertendo: argumento -> nota pas
			
			// Para este cálculo, cheque a folha com a fórmula;
			double dividendoMinimo = deltaMinimo2 + (peso * base * media31 / desvio31) + ((1 - peso) * base * media32 / desvio32);
			double divisorMinimo = (peso * proporcao * base / desvio31) + ((1 - peso) * base * (1 - proporcao) / desvio32);
			xMinimo2 = dividendoMinimo / divisorMinimo;
			
			double dividendoMaximo = deltaMaximo2 + (peso * base * media31 / desvio31) + ((1 - peso) * base * media32 / desvio32);
			double divisorMaximo = (peso * proporcao * base / desvio31) + ((1 - peso) * base * (1 - proporcao) / desvio32);
			xMaximo2 = dividendoMaximo / divisorMaximo;
		}
		
		if (level <= 1) {
			
			// Invertendo: argumento -> nota pas
			
			// Para este cálculo, cheque a folha com a fórmula;
			double dividendoMinimo = deltaMinimo1 + (peso * base * media21 / desvio21) + ((1 - peso) * base * media22 / desvio22);
			double divisorMinimo = (peso * proporcao * base / desvio31) + ((1 - peso) * base * (1 - proporcao) / desvio32);
			xMinimo1 = dividendoMinimo / divisorMinimo;
			
			double dividendoMaximo = deltaMaximo1 + (peso * base * media21 / desvio21) + ((1 - peso) * base * media22 / desvio22);
			double divisorMaximo = (peso * proporcao * base / desvio21) + ((1 - peso) * base * (1 - proporcao) / desvio22);
			xMaximo1 = dividendoMaximo / divisorMaximo;
		}
		
		if (level <= 0) {
			
			// Invertendo: argumento -> nota pas
			
			// Para este cálculo, cheque a folha com a fórmula;
			double dividendoMinimo = deltaMinimo0 + (peso * base * media11 / desvio11) + ((1 - peso) * base * media12 / desvio12);
			double divisorMinimo = (peso * proporcao * base / desvio31) + ((1 - peso) * base * (1 - proporcao) / desvio32);
			xMinimo0 = dividendoMinimo / divisorMinimo;
			
			double dividendoMaximo = deltaMaximo0 + (peso * base * media11 / desvio11) + ((1 - peso) * base * media12 / desvio12);
			double divisorMaximo = (peso * proporcao * base / desvio11) + ((1 - peso) * base * (1 - proporcao) / desvio12);
			xMaximo0 = dividendoMaximo / divisorMaximo;
		}
		
		// Realizando a média
		
        double xMinimoFinal = (xMinimo0 + xMinimo1 + xMinimo2) / (3.0 - level);
		double xMaximoFinal = (xMaximo0 + xMaximo1 + xMaximo2) / (3.0 - level);
        
		//double xMinimoFinal = ((xMinimo0 + xMinimo1 + xMinimo2) / (3.0 - level)) * propFinal;
		//double xMaximoFinal = ((xMaximo0 + xMaximo1 + xMaximo2) / (3.0 - level)) * propFinal;
		
		
		argumentoMinimoFinal.text = [self.formatter stringFromNumber:[NSNumber numberWithDouble:xMinimoFinal]];
		argumentoMaximoFinal.text = [self.formatter stringFromNumber:[NSNumber numberWithDouble:xMaximoFinal]];
		
	}
	
}


- (IBAction)infoSerie {
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Informações"
						  message: @"Escolha sua série atual.\n\nLembre-se que a prova de sua atual série ainda não foi realizada."
						  delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (IBAction)infoNotas {
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Informações"
						  message: @"Insira as notas obtidas no PAS no formato (00.00). As mesmas podem variar de 00.00 até 99.99.\n\nPara a Língua Estrangeira, selecione:\n'I' para Inglês;\n'F' para Francês;\n'E' para Espanhol."
						  delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (IBAction)infoNotasiPad {
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Informações"
						  message: @"Insira as notas obtidas no PAS no formato (00.00). As mesmas podem variar de 00.00 até 99.99.\n\nPara a Língua Estrangeira, selecione entre Inglês, Francês e Espanhol."
						  delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (IBAction)infoResultado {
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Tendência"
						  message: @"As notas expressas nas linhas abaixo foram calculadas em resultados de PAS passados, logo, elas demonstram uma tendência a ser seguida e não uma verdade absoluta."
						  delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
