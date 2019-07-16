//
//  TermsAndCondtVC.h
//  Hypdra
//
//  Created by Mac on 7/8/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndCondtVC : UIViewController{
    
    NSArray *sectionTitleArray;
    NSArray *sectionTitleArray1;
    NSMutableArray *arrayForBool;

}
@property (strong, nonatomic) IBOutlet UITableView *TermsNcond_tblview;
@property (strong, nonatomic) UIView *backView;

@property (strong,nonatomic) UILabel *title_lbl;

- (IBAction)back:(id)sender;

- (IBAction)menu:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
