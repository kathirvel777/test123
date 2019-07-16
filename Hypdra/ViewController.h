//
//  ViewController.h
//  Montage
//
//  Created by MacBookPro on 3/20/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIView *titleView;

@property (strong, nonatomic) IBOutlet UIView *userText,*FirstText,*LastText,*emailText,*pwdText;



@property (strong, nonatomic) IBOutlet UIView *centerView;




@property (strong, nonatomic) IBOutlet UIView *passText;


@property (strong, nonatomic) UIButton *SignIn,*NewAccount,*createAccount;

@property (strong, nonatomic) UIButton *forget,*facebook,*AddFacebook,*AlreadyAccount;


@property (strong, nonatomic) UILabel *labelText,*connectText;




@property (strong, nonatomic) IBOutlet UIButton *loginBtn;


@property (strong, nonatomic) IBOutlet UIButton *signupBtn;


@end

