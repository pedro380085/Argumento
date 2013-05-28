//
//  DataController.h
//  Argumento
//
//  Created by Pedro Góes on 28/05/13.
//
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

@property (nonatomic, strong) NSArray *cursos;
@property (nonatomic, strong) NSArray *argumentos;
@property (nonatomic, strong) NSDictionary *dicionarioCursos;
@property (nonatomic, strong) NSDictionary *dicionarioMedias;

+ (DataController *)sharedInstance;

- (void)atualizarDados;
- (void)selecionaCurso:(NSInteger)row;

@end
