//
//  FullImageViewController.h
//  TestApp
//
//  Created by shiva on 18/06/2017.
//  Copyright © 2017 ACUMEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController

@property (nonatomic, strong) NSDictionary *imageDetailsDct;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *detailsImageView;
- (IBAction)shareBtnAction:(id)sender;
- (IBAction)openInBroswerAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;

@end
