//
//  WizardCollectionCell.h
//  Montage
//
//  Created by MacBookPro on 6/30/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardCollectionCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *ImgView;


@property (strong, nonatomic) IBOutlet UIButton *deleteVideo;


@property (strong, nonatomic) IBOutlet UIButton *playVideo;


@property (strong, nonatomic) IBOutlet UILabel *duration;


@property (strong, nonatomic) IBOutlet UILabel *fileName;

@property (strong, nonatomic) IBOutlet UIButton *edit;
@property (strong, nonatomic) IBOutlet UIImageView *SelectedItem;
@property (strong, nonatomic) IBOutlet UIView *AboveTopView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *LoadingIndicator;

@end

