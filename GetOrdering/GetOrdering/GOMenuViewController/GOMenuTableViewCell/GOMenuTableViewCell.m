//
//  GOMenuTableViewCell.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOMenuTableViewCell.h"

@implementation GOMenuTableViewCell
@synthesize lblMenuItem,menuItemImageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
