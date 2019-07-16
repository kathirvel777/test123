//
//  GmailContactsViewController.h
//  Montage
//
//  Created by Srinivasan on 18/09/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface GmailContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIView *ViewHoldsWebView;
@property (strong, nonatomic) IBOutlet UILabel *inviteallLabel;

@property (strong, nonatomic) IBOutlet UIWebView *webView1;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *noOfContacts;

@property (strong, nonatomic) IBOutlet UIButton *inviteAll;

- (IBAction)inviteAllAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableViewMail;

@property(strong,nonatomic)IBOutlet NSString *inviteFor,*inviteThrough,*inviteVideoID;;
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)inviteTopAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *inviteTopLabel;
@property (strong, nonatomic) IBOutlet UIImageView *inviteAllImgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (strong, nonatomic) IBOutlet UIView *inviteTopLblView;



@end
