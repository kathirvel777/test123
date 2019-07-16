//
//  WizardTabViewController.h
//  Hypdra
//
//  Created by MacBookPro on 7/25/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "TabBarViewController.h"

@interface WizardTabViewController : TabBarViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_Add;

- (IBAction)done:(id)sender;
@end
