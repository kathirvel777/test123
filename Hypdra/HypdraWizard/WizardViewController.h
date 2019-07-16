//
//  WizardViewController.h
//  Montage
//
//  Created by MacBookPro4 on 6/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardViewController : UIViewController
- (IBAction)createMovieAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backAction;
- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *createMovie;

@end
