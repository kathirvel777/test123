//
//  AboutTableViewCell.h
//  About
//
//  Created by MacBookPro on 7/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleValue;

@property (strong, nonatomic) IBOutlet UILabel *descriptionValue;

@property (strong, nonatomic) IBOutlet UIImageView *disImage;

@property (weak, nonatomic) IBOutlet UILabel *number;

@end
