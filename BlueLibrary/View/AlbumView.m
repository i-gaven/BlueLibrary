//
//  AlbumView.m
//  BlueLibrary
//
//  Created by 赵国腾 on 15/7/25.
//  Copyright (c) 2015年 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView {
    
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [coverImage removeObserver:self forKeyPath:@"image"];
}

- (id)initWithFrame:(CGRect)frame albumCover:(NSString*)albumCover {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification"
                                                           object:self
                                                         userInfo:@{@"imageView":coverImage,
                                                                     @"coverUrl":albumCover}];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"image"]) {
        
        [indicator stopAnimating];
    }
}

@end
