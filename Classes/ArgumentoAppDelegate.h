//
//  ArgumentoAppDelegate.h
//  Argumento UNB:PAS
//
//  Created by Pedro Peçanha Martins Góes on 20/08/10.
//  Copyright PEDROGOES.INFO 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArgumentoViewController;

@interface ArgumentoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ArgumentoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ArgumentoViewController *viewController;

@end

