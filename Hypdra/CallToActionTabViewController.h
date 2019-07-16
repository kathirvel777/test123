//
//  CallToActionTabViewController.h
//  Montage
//
//  Created by MacBookPro on 6/28/17.
//  Copyright © 2017 sssn. All rights reserved.


#import <UIKit/UIKit.h>

@interface CallToActionTabViewController : UITabBarController
- (IBAction)Back:(id)sender;

- (IBAction)sideMenu:(id)sender;
@property (nonatomic, retain)NSString *calledVC;
@property (assign) int index;

- (IBAction)Done:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;


@end
