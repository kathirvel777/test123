//
//  LetsConnectViewController.h
//  Montage
//
//  Created by MacBookPro on 7/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetsConnectViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *firstName;

@property (strong, nonatomic) IBOutlet UITextField *lastName;

@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UITextField *mobileNo;

@property (strong, nonatomic) IBOutlet UITextField *message;

- (IBAction)submit:(id)sender;

- (IBAction)back:(id)sender;

- (IBAction)menu:(id)sender;


@end
