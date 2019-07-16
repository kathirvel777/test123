//
//  WizardCollectionViewController.h
//  Montage
//
//  Created by MacBookPro4 on 6/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"


@interface WizardCollectionViewController : UICollectionViewController
- (IBAction)menuAction:(id)sender;
- (IBAction)plusAction:(id)sender;
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) UIImageView *EmptyImage;
@property (strong, nonatomic) UIView *holdView;
@property (strong, nonatomic) UIButton *previewAction;
@property (strong, nonatomic) IBOutlet UICollectionView *wizardCollectionView;

- (IBAction)createWizardMovie:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (strong, nonatomic) IBOutlet UILabel *tilteNme;

@property (strong, nonatomic) IBOutlet UIImageView *WizardGB;


@property (strong, nonatomic) UIView *backView;

@property (strong,nonatomic) UILabel *title_lbl;


@end
