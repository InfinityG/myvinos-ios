//
//  Deck.h
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryDeck : UIView{
    
    BOOL deckOpen;
    NSMutableArray *cards;
    
    UIView *boxHolder;
    
    
    NSMutableDictionary *data;
    
    NSMutableArray *cardsData;
    
    
    id myDelegate;
    CGPoint lastLocation; 
}
@property (strong, nonatomic) NSMutableArray *cards;

@property (strong, nonatomic) UIView *boxHolder;


@property (strong, nonatomic) NSMutableDictionary *data;

@property (strong, nonatomic) NSMutableArray *cardsData;


@property (retain, nonatomic) id myDelegate;

-(void)setLastLocation;
-(void)moveDeckX:(float)moveX;
-(void)endDeckX:(float)moveX;

-(void)activateDeck;
-(void)deactivateDeck;


-(void)setData:(NSDictionary*)cardsData;
-(void)openCard:(id)myCard;
-(void)closeCard:(id)myCard;

-(void)nextCardDeck:(id)myCard;
-(void)previousCardDeck:(id)myCard;


-(void)promptAddToDeliveryDeck:(id)myCard;
-(void)orderCard:(id)myCard;
-(void)dumpCard:(id)myCard;
-(void)addCard:(id)myCard;



@end
