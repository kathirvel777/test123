//
//  PlayThemeViewController.m
//  Montage
//
//  Created by MacBookPro4 on 6/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "PlayThemeViewController.h"
#import "MuiscTabViewController.h"

@interface PlayThemeViewController ()

@end

@implementation PlayThemeViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.player = [[VKVideoPlayer alloc] init];
    self.player.delegate = self;
    self.player.view.frame = self.playView.bounds;
    self.player.view.playerControlsAutoHideTime = @10;
    [self.playView addSubview:self.player.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self playSampleClip1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"URL = %@",self.playerURL);
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)playSampleClip1
{
    NSURL *videoURL=[[NSURL alloc] initWithString:self.playerURL];
    
    [self playStream:videoURL];
}

- (void)playStream:(NSURL*)url
{
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
    track.hasNext = YES;
    [self.player loadVideoWithTrack:track];
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event
{
    NSLog(@"%s event:%d", __FUNCTION__, event);
    __weak __typeof(self) weakSelf = self;
    
    if (event == VKVideoPlayerControlEventTapDone)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (event == VKVideoPlayerControlEventTapCaption)
    {
        RUN_ON_UI_THREAD(^{
            
            VKPickerButton *button = self.player.view.captionButton;
            
            NSArray *subtitleList = @[@"JP", @"EN"];
            
            if (button.isPresented)
            {
                [button dismiss];
            }
            else
            {
                weakSelf.player.view.controlHideCountdown = -1;
                [button presentFromViewController:weakSelf title:NSLocalizedString(@"settings.captionSection.subtitleLanguageCell.text", nil) items:subtitleList formatCellBlock:^(UITableViewCell *cell, id item)
                 {
                     NSString* code = (NSString*)item;
                     cell.textLabel.text = code;
                     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", @"50"];
                 }
                                  isSelectedBlock:^BOOL(id item)
                 {
                     return [item isEqualToString:weakSelf.currentLanguageCode];
                 }
                               didSelectItemBlock:^(id item)
                 {
                     //[weakSelf setLanguageCode:item];
                     [button dismiss];
                 }
                                  didDismissBlock:^{
                                      weakSelf.player.view.controlHideCountdown = [weakSelf.player.view.playerControlsAutoHideTime integerValue];
                                  }];
            }
        });
    }
}


- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState
{
    NSLog(@"didChangeStateFrom");
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState
{
    NSLog(@"willChangeStateFrom");
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track
{
    NSLog(@"didPlayToEnd");
    [self playSampleClip1];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)selectThemeAction:(id)sender
{
    // [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
    // [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    //    self.playerURL = @"";
    //    [self playSampleClip1];
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MuiscTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MuiscTab"];
    
    //        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:vc];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end

