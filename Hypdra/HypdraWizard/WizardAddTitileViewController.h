//
//  WizardAddTitileViewController.h
//  Montage
//
//  Created by MacBookPro4 on 6/9/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;

@interface WizardAddTitileViewController : UIViewController<UITextFieldDelegate>
- (IBAction)createFinalVideo:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *wizardAlbumTitle;
- (IBAction)backAction:(id)sender;


- (IBAction)agreeBtn:(id)sender;

@end
