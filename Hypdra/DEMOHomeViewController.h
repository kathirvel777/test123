//
//  DEMOHomeViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.

#import "TextFieldValidator/TextFieldValidator.h"
#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "KIImagePager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "GoogleSignIn.h"

@interface DEMOHomeViewController : UIViewController<FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (strong, nonatomic) IBOutlet TextFieldValidator *email;

@property (strong, nonatomic) IBOutlet TextFieldValidator *password;


- (IBAction)showMenu;

@property (strong, nonatomic) IBOutlet KIImagePager *imagePager;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)profile:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *socialLoginView;


-(IBAction)forgotPassword:(id)sender;

@property (strong, nonatomic) IBOutlet GIDSignInButton *GoogleSign_In;

-(IBAction)FB_btn:(id)sender;
- (IBAction)back:(id)sender;

- (IBAction)twitterButton:(id)sender;
- (IBAction)GoogleSignIn:(id)sender;
- (IBAction)SignUpAcion:(id)sender;

@end
