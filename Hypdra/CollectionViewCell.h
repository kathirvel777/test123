//
//  CollectionViewCell.h
//  Montage
//
//  Created by MacBookPro on 3/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell



@property (strong, nonatomic) IBOutlet UIImageView *image;


@property (strong, nonatomic) IBOutlet UIButton *edit_btn;



@property (strong, nonatomic) IBOutlet UIButton *close_btn;



@property (strong, nonatomic) IBOutlet UIView *headerView;


@end
