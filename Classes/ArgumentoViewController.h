//
//  ArgumentoViewController.h
//  Argumento UNB:PAS
//
//  Created by Pedro Peçanha Martins Góes on 20/08/10.
//  Copyright PEDROGOES.INFO 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ArgumentoViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

	IBOutlet UIView * primeiraTela;
	IBOutlet UIView * segundaTela;
	
	IBOutlet UIPickerView * picker;
	
	IBOutlet UILabel * argumentoMinimoCurso;
	IBOutlet UILabel * argumentoMaximoCurso;
	IBOutlet UILabel * candidatoVaga;
	IBOutlet UILabel * argumentoMinimoFinal;
	IBOutlet UILabel * argumentoMaximoFinal;
	
	IBOutlet UILabel * labelPrimeiraSerie;
	IBOutlet UILabel * labelSegundaSerie;
	IBOutlet UILabel * labelTerceiraSerie;
	IBOutlet UITextField * provaPrimeiraSerie;
	IBOutlet UITextField * provaSegundaSerie;
	IBOutlet UITextField * provaTerceiraSerie;
	IBOutlet UISegmentedControl * linguaPrimeiraSerie;
	IBOutlet UISegmentedControl * linguaSegundaSerie;
	IBOutlet UISegmentedControl * linguaTerceiraSerie;
	
	IBOutlet UISegmentedControl * serie;
	
	NSArray * cursos;
    NSArray * argumentos;
	
	NSDictionary * dicionarioCursos;
	NSDictionary * dicionarioMedias;
    
    NSInteger telaSelecionada;
}

@property (nonatomic, retain) NSArray *cursos;
@property (nonatomic, retain) NSArray *argumentos;
@property (nonatomic, retain) NSDictionary *dicionarioCursos;
@property (nonatomic, retain) NSDictionary *dicionarioMedias;
@property (nonatomic, retain) NSNumberFormatter *formatter;
@property (nonatomic, assign) NSInteger telaSelecionada;

- (IBAction) proximaPagina;
- (IBAction) retornar;
- (IBAction) serieSelecionada;
- (IBAction) iniciarCalculoArgumento;
- (IBAction) infoSobre;
- (IBAction) infoCurso;
- (IBAction) infoSerie;
- (IBAction) infoNotas;
- (IBAction) infoNotasiPad;
- (IBAction) infoResultado;
- (IBAction) textFieldDoneEditing: (id) sender;
- (void) atualizarDados;


@end

