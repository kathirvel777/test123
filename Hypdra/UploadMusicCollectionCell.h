//
//  UploadMusicCollectionCell.h
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadMusicCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *duration;

@property (strong, nonatomic) IBOutlet UIImageView *ImgView;


@property (strong, nonatomic) IBOutlet UIView *aboveTopView;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *delete;

@property (strong, nonatomic) IBOutlet UIButton *cropMusic;

@property (strong, nonatomic) IBOutlet UIButton *playBtn;


@end
