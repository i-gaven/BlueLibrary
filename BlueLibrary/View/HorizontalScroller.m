//
//  HorizontalScroller.m
//  BlueLibrary
//
//  Created by 赵国腾 on 15/7/25.
//  Copyright (c) 2015年 Eli Ganem. All rights reserved.
//

#import "HorizontalScroller.h"

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 100
#define VIEWS_OFFSET 100

@interface HorizontalScroller () <UIScrollViewDelegate>

@end

@implementation HorizontalScroller {
    UIScrollView *scroller;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        scroller.delegate = self;
        [self addSubview:scroller];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        
        [scroller addGestureRecognizer:tapRecognizer];
    }
    
    return self;  
}


- (void)scrollerTapped:(UITapGestureRecognizer*)gesture {
    
    CGPoint location = [gesture locationInView:gesture.view];
    
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++) {
        
        UIView *view = scroller.subviews[index];
        
        if (CGRectContainsPoint(view.frame, location)) {
            
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

- (void)centerCurrentView {
    
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    
    [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

- (void)reload {
    
    if (self.delegate == nil) return;
    
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    CGFloat xValue = VIEWS_OFFSET;
    
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++) {

        xValue += VIEW_PADDING;
        
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        
        view.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        
        [scroller addSubview:view];
        xValue += VIEW_DIMENSIONS+VIEW_PADDING;
        
    }
    
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        
        NSInteger initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        
        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
    }
    
}

- (void)didMoveToSuperview {
    [self reload];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerCurrentView];
}

@end
