//
//  Card.h
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIView<UIGestureRecognizerDelegate>{
    BOOL cardOpen;
    int numberOfItems;
    
    UIView *cardHolder;

    NSMutableDictionary *data;
    id myDelegate;
    
    UILabel *title;
    UITextView *description;
    NSMutableArray *bottleIcons;
    UILabel *bottleCounter;
    
    UILabel *price;
    
    CGPoint lastLocation;

    UIPanGestureRecognizer * panRecognizer;
    
    UILabel *maxPriceTxt;
    
    UITapGestureRecognizer *bottleTap;
    NSMutableArray *bottleGestures;
}

@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) id myDelegate;

@property (strong, nonatomic) UIView *cardHolder;

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UITextView *description;
@property (strong, nonatomic) NSMutableArray *bottleIcons;
@property (strong, nonatomic) NSMutableArray *bottleGestures;

@property (strong, nonatomic) UILabel *bottleCounter;

@property (strong, nonatomic) UILabel *price;

@property (strong, nonatomic) UIPanGestureRecognizer * panRecognizer;
@property (strong, nonatomic) UILabel *maxPriceTxt;

@property (strong, nonatomic) UITapGestureRecognizer *bottleTap;

-(void)setData:(NSDictionary*)myColor;
-(void)closeMyCard;
-(void)activateCard;

-(int)getNumberOfItems;

-(void)deactivateCard;

-(void)closeMyCardForce;

@end
