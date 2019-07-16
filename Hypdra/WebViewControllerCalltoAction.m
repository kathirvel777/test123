//
//  WebViewControllerCalltoAction.m
//  Montage
//
//  Created by MacBookPro on 12/28/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "WebViewControllerCalltoAction.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"

@interface WebViewControllerCalltoAction ()<UIWebViewDelegate,ClickDelegates>

@end

@implementation WebViewControllerCalltoAction

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlAddress = _stringUrl;//@"http://www.apple.com";
    NSURL *url = [NSURL URLWithString:urlAddress];

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:requestObj];
    self.myWebView.delegate=self;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(error)
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter a valid URL" withTitle:@"Warning" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        //  popUp.accessibilityHint =@"AcceptTerms";
        popUp.agreeBtn.hidden=YES;
        popUp.cancelBtn.hidden=YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
      NSLog(@"error is %@",error);
      
    }
}

-(void) okClicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView=nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"calltoActStatusVal" object:self];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)backAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"calltoActStatusVal" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
