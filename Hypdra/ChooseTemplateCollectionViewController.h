//
//  ChooseTemplateCollectionViewController.h
//  Hypdra
//
//  Created by MacBookPro on 7/4/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTemplateCollectionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;
- (IBAction)Done_actn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideMenu;
@property (strong, nonatomic) NSString *TemplateID;
- (IBAction)closeAction:(id)sender;

- (IBAction)Redeem:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *availableCredits_lbl;
- (IBAction)Pay:(id)sender;
- (IBAction)close_purchaseView:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *PurchaseView;
@property (strong, nonatomic) IBOutlet UIView *ADView;
@property (strong, nonatomic) IBOutlet UIView *VideoPlayerView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *Choose_Btn;
- (IBAction)Choose_actn:(id)sender;
@property (nonatomic, retain) NSString *name;
@end
