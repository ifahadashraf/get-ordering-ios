//
//  GOParentViewController.h
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GOParentViewController : UIViewController
{
    
}

@property(strong,nonatomic)IBOutlet UIButton *btnBack;
@property(strong,nonatomic)IBOutlet UIButton *btnMenu;
@property(strong,nonatomic)IBOutlet UILabel *lblHeading;

@property(strong,nonatomic)IBOutlet UIView * viewError;
@property(strong,nonatomic)IBOutlet UILabel * lblError;

-(void)addMainPagetopview;
-(void)addFavOPageBack;

@end
