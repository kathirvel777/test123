//
//  RegisterViewController.h
//  Montage
//
//  Created by MacBookPro on 4/24/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator/TextFieldValidator.h"

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet TextFieldValidator *firstName;

@property (strong, nonatomic) IBOutlet TextFieldValidator *lastName;


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet TextFieldValidator *email;

@property (strong, nonatomic) IBOutlet TextFieldValidator *mobileNumber;

@property (strong, nonatomic) IBOutlet TextFieldValidator *password;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentForOTP;

@end

