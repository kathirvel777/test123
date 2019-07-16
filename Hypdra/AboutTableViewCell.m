//
//  AboutTableViewCell.m
//  About
//
//  Created by MacBookPro on 7/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AboutTableViewCell.h"

@implementation AboutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleValue sizeToFit];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
