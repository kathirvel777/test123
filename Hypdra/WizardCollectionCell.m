//
//  WizardCollectionCell.m
//  Montage
//
//  Created by MacBookPro on 6/30/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "WizardCollectionCell.h"

@implementation WizardCollectionCell
- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.AboveTopView.hidden=YES;
    self.SelectedItem.hidden = YES;
    [self.LoadingIndicator stopAnimating];
    
}
@end
