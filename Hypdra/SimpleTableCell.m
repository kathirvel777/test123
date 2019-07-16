//
//  SimpleTableCell.m
//  Montage
//
//  Created by apple on 24/07/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "IFViewController.h"
#import "SimpleTableCell.h"

@implementation SimpleTableCell

@synthesize lbl_name=_lbl_name;
@synthesize lbl_mailid=_lbl_mailid;
@synthesize Iv_profile=_Iv_profile;
@synthesize Iv_msgicon=_Iv_msgicon;
@synthesize btn_checkbox=_btn_checkbox;

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
