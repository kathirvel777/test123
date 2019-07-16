//
//  AICollectionTableViewCell.h
//  Hypdra
//
//  Created by Mac on 1/7/19.
//  Copyright © 2019 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AICollectionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *delete_btn;
@property (strong, nonatomic) IBOutlet UIButton *download;
@property (strong, nonatomic) IBOutlet UIButton *edit;

@property (strong, nonatomic) IBOutlet UIButton *share;


@property (strong, nonatomic) IBOutlet UIImageView *userImg;

@property (strong, nonatomic) IBOutlet UIImageView *actionImg;


@property (strong, nonatomic) IBOutlet UIImageView *albumImg;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *cellActivityIndicator;

@property (strong, nonatomic) IBOutlet UIButton *albumImgButton;


@end

NS_ASSUME_NONNULL_END
