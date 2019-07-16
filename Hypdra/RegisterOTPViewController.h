//
//  RegisterOTPViewController.h
//  Montage
//
//  Created by MacBookPro4 on 1/21/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterOTPViewController : UIViewController

@property (strong, nonatomic)  NSString *email;
@property (strong, nonatomic)  NSString *user_ID;
@property (strong, nonatomic) NSString *Type;


- (IBAction)submitAction:(id)sender;
- (IBAction)resendOTP:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *enterOTP;

@property (weak, nonatomic) IBOutlet UITextField *text1;

@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UITextField *text3;
@property (weak, nonatomic) IBOutlet UITextField *text4;
@property (weak, nonatomic) IBOutlet UITextField *text5;
@property (weak, nonatomic) IBOutlet UITextField *text6;

@end
