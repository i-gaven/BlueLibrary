//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by 赵国腾 on 15/7/25.
//  Copyright (c) 2015年 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI () {
    
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    BOOL isOnline;
    
}

@end

@implementation LibraryAPI

+ (LibraryAPI*)sharedInstance {
    
    static LibraryAPI *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LibraryAPI alloc]init];
    });
    
    return _sharedInstance;
}

- (id)init{
    self = [super init];
    
    if (self) {
        
        persistencyManager = [[PersistencyManager alloc] init];
        
        httpClient = [[HTTPClient alloc] init];
        
        isOnline = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadImage:) name:@"BLDownloadImageNotification"
                                                   object:nil];
    }
    
    return self;  
    
}

- (NSArray*)getAlbums {
    
    return [persistencyManager getAlbums];
}

- (void)addAlbum:(Album*)album atIndex:(int)index {
    
    [persistencyManager addAlbum:album atIndex:index];
    
    if (isOnline) {
        
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
    
}

- (void)deleteAlbumAtIndex:(NSInteger)index {
    
    [persistencyManager deleteAlbumAtIndex:index];
    
    if (isOnline) {
        
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
        
    }
}

- (void)downloadImage:(NSNotification*)notification {

    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];

    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    if (imageView.image == nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                imageView.image = image;
                
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }
}

- (void)saveAlbums {
    
    [persistencyManager saveAlbums];
}

@end
