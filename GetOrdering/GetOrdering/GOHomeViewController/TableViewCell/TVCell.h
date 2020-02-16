//
//  TVCell.h
//  GetOrdering
//
//  Created by shahbaz tariq on 1/22/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCell : UITableViewCell
- (IBAction)btnTrending:(id)sender;

@property(weak,nonatomic)IBOutlet UILabel * lblTradingName;
@property(weak,nonatomic)IBOutlet UILabel * lblIsOpen;
@property(weak,nonatomic)IBOutlet UILabel * lblBusinessType;
@property(weak,nonatomic)IBOutlet UILabel * lblFoodType;
@property(weak,nonatomic)IBOutlet UILabel * lblViewsCount;


@property(weak,nonatomic)IBOutlet UIButton * btnImage;
@property(weak,nonatomic)IBOutlet UIButton * btnCall;
@property(weak,nonatomic)IBOutlet UIButton * btnWebsite;
@property(weak,nonatomic)IBOutlet UIButton * btnLocation;
@property(weak,nonatomic)IBOutlet UILabel * lblDistance;

@property(weak,nonatomic)IBOutlet UIImageView * ImgViewProductLogo;

@property(weak,nonatomic)IBOutlet UIButton * btnOptions;
@property(weak,nonatomic)IBOutlet UIButton * btnFood;
@property(weak,nonatomic)IBOutlet UIButton * btnOpenClose;
@property(weak,nonatomic)IBOutlet UIButton * btnLocationOnDistance;
@property(weak,nonatomic)IBOutlet UIButton * btnHeading;

@property(weak,nonatomic)IBOutlet UIImageView * ImgViewFav;
@property(weak,nonatomic)IBOutlet UIButton * btnFavorites;

@property(weak,nonatomic)IBOutlet UIButton * btnGoOnMenu;

@end
