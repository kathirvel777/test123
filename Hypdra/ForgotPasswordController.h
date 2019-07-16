//
//  ForgotPasswordController.h
//  SampleTest
//
//  Created by MacBookPro on 8/18/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *forgotText;

- (IBAction)backAction:(id)sender;

- (IBAction)ResetPwd:(id)sender;

- (IBAction)registerBtn:(id)sender;


@end
