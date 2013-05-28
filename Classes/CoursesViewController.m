//
//  CoursesViewController.m
//  Argumento UNB:PAS
//
//  Created by Pedro Peçanha Martins Góes on 20/08/10.
//  Copyright PEDROGOES.INFO 2011. All rights reserved.
//

#import "CoursesViewController.h"
#import "Constantes.h"
#import "NUIRenderer.h"
#import "DataController.h"
#import "GradesViewController.h"

@implementation CoursesViewController

#pragma mark - Cycle

- (void)viewDidLoad {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sobre" style:UIBarButtonItemStylePlain target:self action:@selector(infoSobre)];
    [NUIRenderer renderBarButtonItem:self.navigationItem.leftBarButtonItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Avançar" style:UIBarButtonItemStylePlain target:self action:@selector(proximoControlador)];
    [NUIRenderer renderBarButtonItem:self.navigationItem.rightBarButtonItem];
    
    // Inicia o formatter (para formatar os números)
    self.formatter = [[NSNumberFormatter alloc] init];
	[self.formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[self.formatter setMaximumFractionDigits:2];
    
    // Metódo para atualizar os dados (em decorrência de uma possível troca do ano base nos Ajustes)
    [self atualizarDados];
	
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    // Metódo para atualizar os dados (em decorrência de uma possível troca do ano base nos Ajustes
    [self atualizarDados];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];

    self.formatter = nil;
}

#pragma mark - Alerts

- (IBAction)infoSobre {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sobre" 
						  message: @"Este programa SIMULA os resultados do PAS.\n\n © Estúdio Trilha\n\nVersão atual: 1.5\nRelease: Maio/2013\n"
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (IBAction)infoCurso {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Informações" 
						  message: @"Escolha seu curso para visualizar os argumentos mínimo e máximo.\n\nA versão da base de dados (ano do subprograma) utilizada pode ser escolhida dentro dos Ajustes do iPod/iPhone/iPad."
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

#pragma mark - User Methods

- (void)atualizarDados {
    
    // Atualiza os dados no controlador
    [[DataController sharedInstance] atualizarDados];
    
    // Atualiza todos os componentes do picker
    [picker reloadAllComponents];
    // Seleciona a primeira linha do picker (para os argumentos iniciais não serem vazios aos olhos do usuário)
	[picker.delegate pickerView:picker didSelectRow:0 inComponent:0];
}

- (void)proximoControlador {
    
    GradesViewController *gradesViewController = [[GradesViewController alloc] initWithNibName:@"GradesViewController" bundle:nil];
    [self.navigationController pushViewController:gradesViewController animated:YES];
}
    

#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[[DataController sharedInstance] cursos] count];
}

#pragma mark - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[[DataController sharedInstance] cursos] objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
    [[DataController sharedInstance] selecionaCurso:row];
	
    // Escreve os valores dos argumentos e relação candidato/vaga na tela
    argumentoMinimoCurso.text = [self.formatter stringFromNumber:[[[DataController sharedInstance] argumentos] objectAtIndex:0]];
    argumentoMaximoCurso.text = [self.formatter stringFromNumber:[[[DataController sharedInstance] argumentos] objectAtIndex:1]];
    candidatoVaga.text = [self.formatter stringFromNumber:[[[DataController sharedInstance] argumentos] objectAtIndex:2]];
}

@end
