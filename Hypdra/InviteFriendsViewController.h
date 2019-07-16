//
//  InviteFriendsViewController.h
//  Montage
//
//  Created by MacBookPro on 7/19/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TextFieldValidator.h"

@interface InviteFriendsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *linkedInTextView;
- (IBAction)linkedInCancel:(id)sender;
- (IBAction)linkedInShare:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *linkedInView;

@property (strong, nonatomic) NSString *cntyCode;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property SLComposeViewController *mySLComposerSheet;

@property (strong, nonatomic) IBOutlet UIView *secondView;


@property (strong, nonatomic) IBOutlet UIView *numberView;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIView *otpView;

@property (strong, nonatomic) IBOutlet UIButton *resendCodeValue;


- (IBAction)submitCode:(id)sender;

- (IBAction)closeBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *submitCodeValue;

@property (strong, nonatomic) IBOutlet UIButton *closeVal;

- (IBAction)resendCode:(id)sender;


- (IBAction)facebookBtn:(id)sender;

- (IBAction)myContacts:(id)sender;


- (void) contactSend:(NSString *)sel;

@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;


- (IBAction)twitterBtn:(id)sender;


- (IBAction)gmailBtn:(id)sender;


- (IBAction)linkedIn:(id)sender;

- (IBAction)yahooSignIn:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *otpCode;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;


@property (strong, nonatomic) IBOutlet UITextField *countryCode;



@property (strong, nonatomic) IBOutlet UIView *inviteTop;



@property (strong, nonatomic) IBOutlet UIView *inviteInner;


@property (strong, nonatomic) IBOutlet UIView *getCountryView;


@property (strong, nonatomic) IBOutlet TextFieldValidator *mobileNumber;



- (IBAction)getOTP:(id)sender;



@property (strong, nonatomic) IBOutlet UIImageView *countryImage;



@property (strong, nonatomic) IBOutlet UILabel *cntryCodeLabel;



@property (strong, nonatomic) IBOutlet UIView *pick;



@property (strong, nonatomic) IBOutlet UIView *sndView;


@property (strong, nonatomic) IBOutlet UIView *lblView1;
@property (strong, nonatomic) IBOutlet UIView *lblView2;

//OTP Outlet

@property (strong, nonatomic) IBOutlet UIView *otpTop;

@property (strong, nonatomic) IBOutlet UIView *otpInner;

@property (strong, nonatomic) IBOutlet UIButton *otpCloseBtn;

- (IBAction)otpClose:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *enterOTP;

- (IBAction)submitOTP:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *otpsView;

- (IBAction)whatsappAction:(id)sender;

- (IBAction)hangoutAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *RefferenceCode_lbl;

@end

