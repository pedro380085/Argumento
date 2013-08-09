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

@interface CoursesViewController ()

@property NSInteger selectedIndex;

@end

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
    [picker reloadData];
    
    // Seleciona a primeira linha do picker (para os argumentos iniciais não serem vazios aos olhos do usuário)
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[picker selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [[picker cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)proximoControlador {
    
    GradesViewController *gradesViewController = [[GradesViewController alloc] initWithNibName:@"GradesViewController" bundle:nil];
    [self.navigationController pushViewController:gradesViewController animated:YES];
}
    

#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[[DataController sharedInstance] cursos] count];
}

#pragma mark - Picker Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[[DataController sharedInstance] cursos] objectAtIndex:indexPath.row];
    
    UITableViewCellAccessoryType *type = (_selectedIndex == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [cell setAccessoryType:type];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Marca a célula como não selecionada
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Marca a célula como selecionada
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    // Informa o singleton sobre o curso selecionado
    [[DataController sharedInstance] selecionaCurso:indexPath.row];
	
    // Escreve os valores dos argumentos e relação candidato/vaga na tela
    argumentoMinimoCurso.text = [self.formatter stringFromNumber:[[[DataController sharedInstance] argumentos] objectAtIndex:0]];
    argumentoMaximoCurso.text = [self.formatter stringFromNumber:[[[DataController sharedInstance] argumentos] objectAtIndex:1]];
    candidatoVaga.text = [self.formatter stringFromNumber:[[[DataController sharedInstance] argumentos] objectAtIndex:2]];
}


@end
