//
//  UploadImageCollectionCell.m
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "UploadImageCollectionCell.h"

@implementation UploadImageCollectionCell

- (IBAction)View_btn:(id)sender {
}

- (IBAction)Edit_btn:(id)sender {
}

- (IBAction)Delete_btn:(id)sender {
}

- (IBAction)Annotate_btn:(id)sender {
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.AboveTopView.hidden=YES;
    self.SelectedItem.hidden = YES;
}
@end
