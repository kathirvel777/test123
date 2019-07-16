//
//  BillingTableViewCell.h
//  SampleTest
//
//  Created by MacBookPro on 8/17/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *bDate;

@property (strong, nonatomic) IBOutlet UILabel *bType;

@property (strong, nonatomic) IBOutlet UILabel *bPayment;

@property (weak, nonatomic) IBOutlet UIButton *viewDetails;



@end
