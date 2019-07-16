//
//  MailTableCell.m
//  Montage
//
//  Created by apple on 01/08/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MailTableCell.h"
#import "MailIFViewController.h"

@implementation MailTableCell

@synthesize lbl_name=_lbl_name;
@synthesize lbl_mailid=_lbl_mailid;
@synthesize Iv_profile=_Iv_profile;
@synthesize Iv_msgicon=_Iv_msgicon;
@synthesize btn_checkbox=_btn_checkbox;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
