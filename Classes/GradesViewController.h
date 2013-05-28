//
//  GradesViewController.h
//  Argumento
//
//  Created by Pedro Góes on 28/05/13.
//
//

#import <UIKit/UIKit.h>

@interface GradesViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UISegmentedControl *serie;
	IBOutlet UILabel *labelPrimeiraSerie;
	IBOutlet UILabel *labelSegundaSerie;
	IBOutlet UILabel *labelTerceiraSerie;
	IBOutlet UITextField *provaPrimeiraSerie;
	IBOutlet UITextField *provaSegundaSerie;
	IBOutlet UITextField *provaTerceiraSerie;
	IBOutlet UISegmentedControl *linguaPrimeiraSerie;
	IBOutlet UISegmentedControl *linguaSegundaSerie;
	IBOutlet UISegmentedControl *linguaTerceiraSerie;
    IBOutlet UILabel *argumentoMinimoFinal;
	IBOutlet UILabel *argumentoMaximoFinal;
}

@property (nonatomic, strong) NSNumberFormatter *formatter;

- (IBAction)serieSelecionada;
- (IBAction)iniciarCalculoArgumento;
- (IBAction)infoSerie;
- (IBAction)infoNotas;
- (IBAction)infoNotasiPad;
- (IBAction)infoResultado;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
