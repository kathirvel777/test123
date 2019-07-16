//
//  MailTableCell.h
//  Montage
//
//  Created by apple on 01/08/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *Iv_profile;



@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_mailid;

@property (strong, nonatomic) IBOutlet UIImageView *Iv_msgicon;

@property (strong, nonatomic) IBOutlet UIButton *btn_checkbox;


@end
