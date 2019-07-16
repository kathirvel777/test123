//
//  GmailTableCell.h
//  Montage
//
//  Created by Srinivasan on 19/09/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GmailTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *defaultImgView;

@property (strong, nonatomic) IBOutlet UILabel *mailIdLbl;

@property (strong, nonatomic) IBOutlet UIButton *checkBtn;

@end
