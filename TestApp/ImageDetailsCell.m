//
//  ImageDetailsCell.m
//  TestApp
//
//  Created by shiva on 17/06/2017.
//  Copyright © 2017 ACUMEN. All rights reserved.
//

#import "ImageDetailsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ImageDetailsCell

- (void)updateWellnessContent:(NSDictionary*)imageDct {
    NSString *titleStr = imageDct[@"title"];
    _titleLbl.text = (titleStr.length > 0 ? titleStr : @"");
    titleStr = imageDct[@"tags"];
    _tagLbl.text = (titleStr.length > 0 ? titleStr : @" ");

    NSString *imageUrl = [[imageDct objectForKey:@"media"] objectForKey:@"m"];
    [_image sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

@end
