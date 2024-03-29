//
//  Deck.h
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#import "Deliver.h"
#import <UIKit/UIKit.h>


@interface Deck : UIView<UIAlertViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate>{
    
    BOOL deckOpen;
    NSMutableArray *cards;
    
    UIView *boxHolder;
     UIView *fakeBoxHolder;
    UIView * blackCard;
    UIView * backCard;
    
    UIScrollView * scrollView;
    
    NSMutableArray *data;
    
    NSMutableArray *colorFilter;
    NSMutableArray *moodFilter;
    NSMutableString *colorF;
    NSMutableString *moodF;
    
    id myDelegate;
    CGPoint lastLocation;
    
    NSString *title;
     NSString *type;
    NSString *imageUrl;
    NSString *description;
    
    CGPoint contentOffPrev;
    
    
    
    
    
    UILabel *filterTxt;
    UIButton *deckBut;
    UIButton *filterBut;
    NSMutableArray *colorButs;
     NSMutableArray *colorButsLabels;
    NSMutableArray *moodButs;
    
    UIPanGestureRecognizer * panRecognizer;
    
    
    
    id currentOpenCard;
    
   Deliver *deliver;


    
}


@property (strong, nonatomic) NSMutableArray *cards;

@property (strong, nonatomic) UIView *boxHolder;
@property (strong, nonatomic)  UIView *fakeBoxHolder;
@property (strong, nonatomic) UIView * blackCard;
@property (strong, nonatomic) UIView * backCard;

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) NSMutableArray *colorFilter;
@property (strong, nonatomic) NSMutableArray *moodFilter;
@property (strong, nonatomic) NSMutableString *colorF;
@property (strong, nonatomic) NSMutableString *moodF;

@property (retain, nonatomic) id myDelegate;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *description;


@property (retain, nonatomic) UILabel *filterTxt;
@property (retain, nonatomic) UIButton *deckBut;
@property (retain, nonatomic) UIButton *filterBut;
@property (strong, nonatomic) NSMutableArray *colorButs;
@property (strong, nonatomic) NSMutableArray *colorButsLabels;
@property (strong, nonatomic) NSMutableArray *moodButs;

@property (strong, nonatomic) UIPanGestureRecognizer * panRecognizer;



@property (strong, nonatomic) id currentOpenCard;

@property (strong, nonatomic) Deliver *deliver;


-(void)setLastLocation;
-(void)moveDeckX:(float)moveX;
-(void)endDeckX:(float)moveX;

-(void)activateDeck;
-(void)deactivateDeck;

/*
-(void)setData:(NSDictionary*)cardsData;
*/
-(void)addCardData:(NSDictionary*)cardData;

-(void)openCard:(id)myCard;
-(void)closeCard:(id)myCard;

-(void)nextCardDeck:(id)myCard;
-(void)previousCardDeck:(id)myCard;


-(void)orderCard:(id)myCard;
-(void)flipCard:(id)myCard;

-(NSString*)filterColor:(id)myCf;
-(NSString*)filterMood:(id)myMf;

-(NSString*)getTitle;
 -(id)getData;

- (id)initWithFrame:(CGRect)frame setTitle:(NSString*)myTitle setImageUrl:(NSString*)imageUrl setImageDes:(NSString*)imageDes setType:(NSString*)myType;

-(NSInteger)getOrderQuantity;
-(NSInteger)getOrderPrice;

-(BOOL)isScrollingNow;

-(void)updateDeliveryDeckTitle;


-(BOOL)checkForLoggedInDeck;


-(void)deliverNow;

-(void)clearDeckAll;

-(void)showBlackCard;

-(void)deliverNowScreen;

-(void)openCloseDeck;

-(void)forceCloseCardAndActiveDeck;

-(NSString*)getDeckType;

-(void)openCloseUserBuyDeck;
-(void)updateUserMainStatsDeck;
-(void)delieveryDeckSuccessDeck;

-(void)startLoadingNowDeck:(NSString*)txt;

-(void)stopLoadingDeck;

-(void)openCloseUserDeck;

@end
