//
//  AdvancedCollectionCell.m
//  Montage
//
//  Created by MacBookPro on 4/28/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AdvancedCollectionCell.h"

@implementation AdvancedCollectionCell
- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.AboveTopView.hidden=YES;
    self.SelectedItem.hidden = YES;
    [self.LoadingIndicator stopAnimating];
    
}
@end
