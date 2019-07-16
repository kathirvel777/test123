//
//  AICollectionTableViewCell.m
//  Hypdra
//
//  Created by Mac on 1/7/19.
//  Copyright © 2019 sssn. All rights reserved.
//

#import "AICollectionTableViewCell.h"

@implementation AICollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.albumImg.image =  [UIImage imageNamed:@"150-image-holder.png"];
}





@end
