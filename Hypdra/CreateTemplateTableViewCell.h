//
//  CreateTemplateTableViewCell.h
//  Hypdra
//
//  Created by MacBookPro on 7/9/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTemplateTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *titles;

@property (strong, nonatomic) IBOutlet UILabel *CharLimitIndicator;

@property (strong, nonatomic) IBOutlet UIImageView *errorIndicator;


@end
