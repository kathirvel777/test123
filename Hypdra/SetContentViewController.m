//
//  SetContentViewController.m
//  Montage
//
//  Created by MacBookPro on 4/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SetContentViewController.h"
#import "ContainerViewControllers.h"

@interface SetContentViewController ()

@property (nonatomic, weak) ContainerViewControllers *containerViewController;

@end

@implementation SetContentViewController


-(void)viewWillAppear:(BOOL)animated
{
 
    
    NSLog(@"Presented..");
    
//    self.view.layer.borderWidth = 1.5f;
//    self.view.layer.cornerRadius = 10;
//    self.view.layer.masksToBounds = YES;
//    self.view.layer.borderColor=[UIColor whiteColor].CGColor;

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"embedContainer"])
    {
        self.containerViewController = segue.destinationViewController;
    }
}

- (IBAction)swapButtonPressed:(id)sender
{
    
}


- (IBAction)SwapChnaged:(id)sender
{
    NSLog(@"Changed..");
    
    [self.containerViewController swapViewControllers];

}



- (IBAction)Close:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ContentClose"
     object:self];

}


@end
