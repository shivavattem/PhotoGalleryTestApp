//
//  FullImageViewController.m
//  TestApp
//
//  Created by shiva on 18/06/2017.
//  Copyright © 2017 ACUMEN. All rights reserved.
//

#import "FullImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MessageUI/MessageUI.h>

@interface FullImageViewController () <MFMailComposeViewControllerDelegate,UIAlertViewDelegate> {
    NSString *imageUrl;
}

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageUrl = [[_imageDetailsDct objectForKey:@"media"] objectForKey:@"m"];
    [_detailsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _scrollView.zoomScale = 1;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _detailsImageView;
}

#pragma mark - Button Actions
- (IBAction)shareBtnAction:(id)sender {
    // Email Content
    // To address
    if ([MFMailComposeViewController canSendMail]) {
        NSArray *toRecipents = [NSArray arrayWithObject:@"support@test.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        
        NSString *htmlMsg = @"<html><body><p>This is your message</p></body></html>";
        
        NSData *jpegData = UIImageJPEGRepresentation(_detailsImageView.image, 1.0);
        
        NSString *fileName = @"test";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [mc addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
        [mc setSubject:@"sending image"];
        [mc setMessageBody:htmlMsg isHTML:YES];
        
        mc.mailComposeDelegate = self;
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Unable to send maessage" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)openInBroswerAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imageUrl]];
}

- (IBAction)saveBtnAction:(id)sender {
    UIImageWriteToSavedPhotosAlbum(_detailsImageView.image,nil,nil,nil);
}

@end
