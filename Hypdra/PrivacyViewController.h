//
//  PrivacyViewController.h
//  About
//
//  Created by MacBookPro on 7/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)back:(id)sender;


- (IBAction)menu:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
