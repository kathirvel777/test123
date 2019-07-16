//
//  UploadVideoCollectionCell.m
//  Montage
//
//  Created by Mac on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "UploadVideoCollectionCell.h"

@implementation UploadVideoCollectionCell


-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.selectedIconForDelete.hidden = true;
    self.aboveTopView.hidden = true;
    // Then Reset here back to default values that you want.
    //    self.img.image=nil;
}


//- (void) setSelected:(BOOL)selected
//{
//    NSLog(@"setSelected");
//}

@end

