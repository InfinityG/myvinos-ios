//
//  ParseStarterProjectViewController.h
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseStarterProjectViewController : UIViewController <UIGestureRecognizerDelegate,UIAlertViewDelegate>


-(void)openDeck:(id)myDeck;
- (void) showSelectionScreen;

-(void)fullScreenCard;
-(void)closeFullscreenCard;

-(void)updateCardsInDecks:(id)myCard;
-(void)addCardToDelivery:(id)myCard;


-(void)updateUserMainStats;

- (void)openCloseUser;

-(void)startLoadingNow:(NSString*)lStatus;
-(void)stopLoading;

-(void)forwardLoc;

-(void)makeDelNow;

-(BOOL)checkForLoggedIn;

-(void)delieveryDeckSuccess;

-(void)activateDeliveryDeck;

-(void)updateMapGPS;

-(void)showDeliverScreen;

- (void) showDeliverScreenStraight;

-(NSInteger)getOrderPriceDeck;

-(void)openCloseUserBuy;

-(void)updateTempVinosAmount:(int)amount;

-(void)promptSelection;

@end
