//
//  PageSelectionViewController.h
//  Montage
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageSelectionViewController : UIViewController


@property BOOL signOut;


@property (strong, nonatomic) IBOutlet UIView *withoutAlbum;


@property (strong, nonatomic) IBOutlet UIView *withAlbum;

@property(nonatomic,strong) UIDocumentInteractionController *documentInteractionController;


//@property (strong, nonatomic) NSString *nStr;

//-(void)shareVal;

@property (strong, nonatomic) IBOutlet UIButton *advanceWO;


@property (strong, nonatomic) IBOutlet UIButton *uploadWO;


@property (strong, nonatomic) IBOutlet UIButton *wizardWO;


@property (strong, nonatomic) IBOutlet UIButton *uploadWA;


@property (strong, nonatomic) IBOutlet UIButton *wizardWA;


@property (strong, nonatomic) IBOutlet UIButton *advanceWA;


@property (strong, nonatomic) IBOutlet UIButton *albumWA;
@property (weak, nonatomic) IBOutlet UIButton *btnStandard;

@property (weak, nonatomic) IBOutlet UIButton *btnFree;
@property (weak, nonatomic) IBOutlet UIButton *btnPremium;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *imgForMenu;
@property (weak, nonatomic) IBOutlet UILabel *txtForMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)btnMenuAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *menuTitle;

- (IBAction)menuAction:(id)sender;

- (IBAction)btnFreeAction:(id)sender;
- (IBAction)btnStandardAction:(id)sender;
- (IBAction)btnPremiumAction:(id)sender;

@end
