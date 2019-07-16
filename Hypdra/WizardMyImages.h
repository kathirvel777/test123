//
//  WizardMyImages.h
//  Hypdra
//
//  Created by Mac on 7/10/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardMyImages : UIViewController


@property (strong, nonatomic) IBOutlet UIView *emptyView;

@property (strong, nonatomic) IBOutlet UIImageView *emptyImgView;
@property (strong, nonatomic) IBOutlet UICollectionView *imagesCollectionview;

- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *ViewHoldsCollView;

- (IBAction)menu:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;

@property (strong, nonatomic) IBOutlet UIView *ADView;

@end
