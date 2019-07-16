//
//  OutlookViewController.h
//  Montage
//
//  Created by MacBookPro on 3/2/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutlookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UISearchBarDelegate>
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *ViewHoldsWebView;
@property (strong, nonatomic) IBOutlet UILabel *inviteallLabel;

@property (strong, nonatomic) IBOutlet UIWebView *webView1;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *inviteTopLblView;

@property (strong, nonatomic) IBOutlet UILabel *noOfContacts;

@property (strong, nonatomic) IBOutlet UIButton *inviteAll;


- (IBAction)inviteAllAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableViewMail;

@property(strong,nonatomic)IBOutlet NSString *inviteFor,*inviteThrough,*inviteVideoID;;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)inviteTopAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *inviteTopLabel;
@property (strong, nonatomic) IBOutlet UIImageView *inviteAllImgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;


@end
