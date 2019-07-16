//
//  DEMOViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORootViewController.h"

@interface DEMORootViewController ()

@end

@implementation DEMORootViewController





- (void)awakeFromNib:(NSString*)First arg:(NSString*)Second
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:First];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:Second];
}








@end
