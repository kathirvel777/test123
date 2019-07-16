//
//  ViewController.m
//  RotateDemo
//
//  Created by SurpriseWave on 02/05/15.
//  Copyright (c) 2015 SurpriseWave. All rights reserved.
//

#import "SWImageRotation.h"
#import "UIRotateImageView.h"
#import "MyImages.h"
#import "SectionViewController.h"
 
@interface SWImageRotation ()

@property (weak, nonatomic) IBOutlet UIRotateImageView *imgvPhoto;
@property (weak, nonatomic) IBOutlet UIView *viewLayer;

@property (weak, nonatomic) IBOutlet UISlider *slidRotationAngle;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation SWImageRotation

@synthesize imgvPhoto, viewLayer, view1, view2;

#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareViews];
}

#pragma mark - Views Methods
- (void)prepareViews
{


//    NSUInteger index = arc4random_uniform(3) + 1;
//
//    NSString *imageName = [NSString stringWithFormat:@"image%@.jpg", @(index)];
//
    
    NSData *data =  [[NSUserDefaults standardUserDefaults]objectForKey:@"EditImage"];

    UIImage *img = [UIImage imageWithData:data];
    
    imgvPhoto.image = img;
    
//    imgvPhoto.image = [UIImage imageNamed:@"image1.jpg"];
//    imgvPhoto.image = [UIImage imageNamed:@"image2.jpg"];
//    imgvPhoto.image = [UIImage imageNamed:@"image3.jpg"];
    
    viewLayer.layer.borderColor = [UIColor whiteColor].CGColor;
    viewLayer.layer.borderWidth = 1.0;

    [self adjustPossition];
}

- (void)setBlankSpaceView
{
    if(imgvPhoto.imageHeight <= imgvPhoto.imageWidth)
    {
        view1.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMinY(imgvPhoto.frame));
        view2.frame = CGRectMake(0, CGRectGetMaxY(imgvPhoto.frame), CGRectGetWidth(self.view.frame), CGRectGetMinY(imgvPhoto.frame));
    }
    else
    {
        view1.frame = CGRectMake(0, 0, CGRectGetMinX(imgvPhoto.frame), CGRectGetHeight(imgvPhoto.frame));
        view2.frame = CGRectMake(CGRectGetMaxX(imgvPhoto.frame), 0, CGRectGetMinX(imgvPhoto.frame), CGRectGetHeight(imgvPhoto.frame));
    }
}

- (void)adjustPossition
{
    CGAffineTransform saveState = imgvPhoto.transform;
    
    imgvPhoto.transform = CGAffineTransformIdentity;
    
    [imgvPhoto setFrameToFitImage];
    
    viewLayer.frame = imgvPhoto.frame;
    
    [self setBlankSpaceView];
    
    imgvPhoto.transform = saveState;
}

#pragma mark - Event Methods
- (IBAction)btnRotateRightTap:(UIButton *)sender
{
    [imgvPhoto rotateAtPosition:kRotateRight];
    
    [self adjustPossition];
}

- (IBAction)btnRotateLeftTap:(UIButton *)sender
{
    [imgvPhoto rotateAtPosition:kRotateLeft];
    
    [self adjustPossition];
}

- (IBAction)btnVerticalTap:(UIButton *)sender
{
    [imgvPhoto flipVertically];
    
    [self adjustPossition];
}

- (IBAction)btnHorizontalTap:(UIButton *)sender
{
    [imgvPhoto flipHorizontally];
    
    [self adjustPossition];
}

- (IBAction)slidRotationAngleChange:(UISlider *)sender
{
    [imgvPhoto rotateWithAngle:sender.value];
}

- (IBAction)btnOkTap:(UIButton *)sender
{
    NSLog(@"Done");
    
    UIImage *imgFinal = [imgvPhoto finalImage];
//    
//    UIImageWriteToSavedPhotosAlbum(imgFinal, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    

    NSData *data = UIImageJPEGRepresentation(imgFinal, 0.5);
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0]; // Get documents folder
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    
    NSString *getName = [[NSUserDefaults standardUserDefaults]valueForKey:@"EditImageName"];
    
    dataPath = [dataPath stringByAppendingFormat:@"/%@",getName];
    
    NSLog(@"FilePath:%@",dataPath);
    
    [data writeToFile:dataPath atomically:YES];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSection"];
    
    //                 [self.navigationController pushViewController:vc animated:YES];
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:vc animated:YES completion:NULL];
}


#pragma mark - Other Methods
- (void)               image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rotation"
                                                    message:@"Image Saved Successfully."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end