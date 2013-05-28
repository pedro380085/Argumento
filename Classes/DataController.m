//
//  DataController.m
//  Argumento
//
//  Created by Pedro Góes on 28/05/13.
//
//

#import "DataController.h"

@implementation DataController

#pragma mark - Singleton

+ (DataController *)sharedInstance
{
    static DataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - User Methods

- (void)atualizarDados {
    // Inicia o bundle
	NSBundle * bundle = [NSBundle mainBundle];
    
    // Inicia o objeto para acessar as escolhas do usuário nos Ajustes e obtém o valor do ano selecionado
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; // Valores em tempo real
    NSInteger ano = [[defaults objectForKey:@"ano"] intValue];
    
    // Caso ocorra algum erro (0 == NULL), nós definimos ano com um valor default
    if (ano == 0) ano = 2007;
    
    // Carrega os argumentos dos cursos a partir do xml
	NSString * plistPath = [bundle pathForResource:[NSString stringWithFormat:@"cursos_%d", ano] ofType:@"xml"];
	self.dicionarioCursos = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	
    // Obtém as chaves do dicionário de cursos, o que representa o nome dos cursos
	NSArray *components = [self.dicionarioCursos allKeys];
    self.cursos = [components sortedArrayUsingSelector:@selector(compare:)];
    
    // Carrega as médias a partir do xml
	NSString * plistPath2 = [bundle pathForResource:[NSString stringWithFormat:@"medias_%d", ano] ofType:@"xml"];
	self.dicionarioMedias = [[NSDictionary alloc] initWithContentsOfFile:plistPath2];
}


- (void)selecionaCurso:(NSInteger)row {
    // Obtém o nome do curso selecionado e depois, utilizando-o como chave, recebe o vetor correspondente a partir do dicionário de cursos
    self.argumentos = [self.dicionarioCursos objectForKey:[self.cursos objectAtIndex:row]];
}

@end
