//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by 赵国腾 on 15/7/25.
//  Copyright (c) 2015年 Eli Ganem. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary*)tr_tableRepresentation;

@end
