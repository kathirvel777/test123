//
//  ProfileEditViewController.h
//  DemoExpandable
//
//  Created by MacBookPro on 8/2/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TextFieldValidator.h"

@interface ProfileEditViewController : UIViewController

@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;

@property (strong, nonatomic) IBOutlet UIView *changeProfile;


@property (strong, nonatomic) IBOutlet UIView *changePassword;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView; 



@property (strong, nonatomic) IBOutlet UIImageView *profileImage;


@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) IBOutlet UILabel *userEmail;


@property (strong, nonatomic) IBOutlet TextFieldValidator *userNewEmail;


@property (strong, nonatomic) IBOutlet TextFieldValidator *userConfirmEmail;



@property (strong, nonatomic) IBOutlet UITextField *userCountry;


@property (strong, nonatomic) IBOutlet TextFieldValidator *userCurrentPwd;


@property (strong, nonatomic) IBOutlet TextFieldValidator *userNewPwd;


@property (strong, nonatomic) IBOutlet TextFieldValidator *userConfirmPwd;

- (IBAction)updateProfile:(id)sender;

- (IBAction)changePassword:(id)sender;

- (IBAction)done:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *profileView;

- (IBAction)profile_pic_edit_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *change_profile_superView;

@property (strong, nonatomic) IBOutlet UIView *change_pass_superView;

@end
