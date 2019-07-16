//
//  AddAdvanceCollectionViewCell.m
//  Montage
//
//  Created by Mac on 5/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AddAdvanceCollectionViewCell.h"

@implementation AddAdvanceCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    //[self setHighlighted:NO];
    
    self.indicator_img1.hidden=YES;
    self.indicator_img2.hidden=YES;
    self.indicator_img3.hidden=YES;
    self.indicator_img4.hidden=YES;
    
    self.indicator_img1.backgroundColor = [UIColor clearColor];
    
    self.indicator_img2.backgroundColor = [UIColor clearColor];
    
    self.indicator_img3.backgroundColor = [UIColor clearColor];
    self.indicator_img4.backgroundColor = [UIColor clearColor];
}

@end
