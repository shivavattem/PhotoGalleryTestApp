//
//  ImageDetailsCell.h
//  TestApp
//
//  Created by shiva on 17/06/2017.
//  Copyright © 2017 ACUMEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailsCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *tagLbl;
- (void)updateWellnessContent:(NSDictionary*)imageDct;

@end
