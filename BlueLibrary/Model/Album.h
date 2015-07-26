//
//  Album.h
//  BlueLibrary
//
//  Created by 赵国腾 on 15/7/25.
//  Copyright (c) 2015年 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject<NSCoding>

@property (nonatomic, copy, readonly) NSString *title, *artist, *genre, *coverUrl, *year;

- (id)initWithTitle:(NSString*)title
             artist:(NSString*)artist
           coverUrl:(NSString*)coverUrl
               year:(NSString*)year;

@end
