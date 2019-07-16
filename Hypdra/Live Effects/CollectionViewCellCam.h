//
//  CollectionViewCellCam.h
//  Montage
//
//  Created by MacBookPro on 12/1/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCellCam : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *labelType;

@property (strong, nonatomic) IBOutlet UIView *bgViewImg;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btn;

@end
