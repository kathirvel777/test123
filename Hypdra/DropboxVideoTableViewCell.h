//
//  DropboxVideoTableViewCell.h
//  Montage
//
//  Created by Srinivasan on 25/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropboxVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *dropboxLabel;

@property (strong, nonatomic) IBOutlet UIButton *dropboxDownload;


@end
