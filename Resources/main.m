//
//  main.m
//  Argumento UNB:PAS
//
//  Created by Pedro Peçanha Martins Góes on 20/08/10.
//  Copyright PEDROGOES.INFO 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[]) {
    
    @autoreleasepool {
        [NUISettings initWithStylesheet:@"SkyBlue.NUI"];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
