//
//  RoundButton.m
//  GetOrdering
//
//  Created by shahbaz tariq on 1/20/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

- (void)setup{
    self.layer.cornerRadius = 20.0;
    self.layer.masksToBounds = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
