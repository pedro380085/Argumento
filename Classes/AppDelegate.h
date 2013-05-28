//
//  AppDelegate.h
//  Argumento UNB:PAS
//
//  Created by Pedro Peçanha Martins Góes on 20/08/10.
//  Copyright PEDROGOES.INFO 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUIAppearance.h"

@class CoursesViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CoursesViewController *coursesViewController;

@end

