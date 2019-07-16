//
//  CollectionViewCellEffects.h
//  Montage
//
//  Created by MacBookPro on 11/22/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCellEffects : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *effectLabel;
@property (strong, nonatomic) IBOutlet UIView *highLitedView;

@end
