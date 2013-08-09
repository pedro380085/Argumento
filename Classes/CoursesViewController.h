//
//  CoursesViewController.h
//  Argumento UNB:PAS
//
//  Created by Pedro Peçanha Martins Góes on 20/08/10.
//  Copyright PEDROGOES.INFO 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CoursesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *picker;
	
	IBOutlet UILabel *argumentoMinimoCurso;
	IBOutlet UILabel *argumentoMaximoCurso;
	IBOutlet UILabel *candidatoVaga;
}

@property (nonatomic, strong) NSNumberFormatter *formatter;

- (IBAction)infoSobre;
- (IBAction)infoCurso;

- (void)atualizarDados;
- (void)proximoControlador;

@end

