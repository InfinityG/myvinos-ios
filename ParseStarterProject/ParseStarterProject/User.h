//
//  User.h
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "qrencode.h"
#import "FormTableController.h"
#import "FormTableControllerLogIn.h"
#import "FormTableControllerForgot.h"



@interface User : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>{
    
    BOOL userOpen;
    BOOL userFound;
    BOOL userLoggedIn;
    BOOL userJustSignedUp;
    
    NSMutableArray *topUps;
    NSMutableArray *topUpsToBuy;
    UILabel *summeryLabel;
    UILabel *summeryPurchase;

    FormTableController *signUpTable;
    FormTableControllerLogIn *logInTable;
    FormTableControllerForgot *forgotTable;
    
    NSURLConnection *connectionSignUp;
    NSURLConnection *connectionLogIn;
    NSURLConnection *connectionToken;
    NSURLConnection *connectionUser;
    NSURLConnection *connectionTopUp;
    NSURLConnection *connectionHistory;
    NSURLConnection *connectionForgot;
    NSURLConnection *connectionReset;
    
    NSMutableData *dataSignUp;
    NSMutableData *dataLogIn;
    NSMutableData *dataToken;
    NSMutableData *dataUser;
    NSMutableData *dataTopUp;
    NSMutableData *dataHistory;
    NSMutableData *dataForgot;
    NSMutableData *dataReset;
    
    NSMutableDictionary *jsonDataSignUp;
    NSMutableDictionary *jsonDataLogIn;
    NSMutableDictionary *jsonDataToken;
    NSMutableDictionary *jsonDataUser;
    NSMutableDictionary *jsonDataTopUp;
    NSMutableDictionary *jsonDataHistory;
    NSMutableDictionary *jsonDataForgot;
    NSMutableDictionary *jsonDataReset;
    
    UIWebView *myPaymentPage;
    
    NSMutableArray *vinosButs;
     NSMutableArray *userButs;
    
    UIView *memberView;
    UIView *buttonsView;
    UIView *signUpView;
    
    UIView *highlightView;
    
     UIButton *infoBut;
    UIView *contactInfoView;
    
    UIScrollView *creditHistoryView;
    UIScrollView *deliveryHistoryView;
    
    UIView *creditInfoView;
    UITextView *welcomeTxt;
    NSArray *welcomeTxtArr;
    
    UILabel *memberTitle;
    UILabel *refCode;
    
    
    id myDelegate;
        
    NSTimer *paymentTimeLimitTimer;
    UIButton *historyBut;
    
    NSTimer *tokenTimer;
    UIImageView *QRcodeImg;
    
    UIButton *loginButM;
    UIButton *signUpButM;
    
    UIButton *goToCollection;
    
   // UIButton *deckBut;
    
    UIView *menuView;
    
    UIButton *buyCreditsCCbut;
    
    UIView *userMenuView;
    
    
    UIButton *menuCloseBut;
    
}
@property (retain, nonatomic) FormTableController *signUpTable;
@property (retain, nonatomic) FormTableControllerLogIn *logInTable;
@property (retain, nonatomic) FormTableControllerForgot *forgotTable;

@property (retain, nonatomic) NSMutableArray *topUps;
@property (retain, nonatomic) NSMutableArray *topUpsToBuy;
@property (retain, nonatomic) UILabel *summeryLabel;
@property (retain, nonatomic) UILabel *summeryPurchase;

@property (retain, nonatomic) NSURLConnection *connectionSignUp;
@property (retain, nonatomic) NSURLConnection *connectionLogIn;
@property (retain, nonatomic) NSURLConnection *connectionToken;
@property (retain, nonatomic) NSURLConnection *connectionUser;
@property (retain, nonatomic) NSURLConnection *connectionTopUp;
@property (retain, nonatomic) NSURLConnection *connectionHistory;
@property (retain, nonatomic) NSURLConnection *connectionForgot;
@property (retain, nonatomic) NSURLConnection *connectionReset;

@property (strong, nonatomic) NSMutableData *dataSignUp;
@property (strong, nonatomic) NSMutableData *dataLogIn;
@property (strong, nonatomic) NSMutableData *dataToken;
@property (strong, nonatomic) NSMutableData *dataUser;
@property (strong, nonatomic) NSMutableData *dataTopUp;
@property (strong, nonatomic) NSMutableData *dataHistory;
@property (strong, nonatomic) NSMutableData *dataForgot;
@property (strong, nonatomic) NSMutableData *dataReset;


@property (retain, nonatomic) NSMutableData *collectionData;
@property (retain, nonatomic) NSMutableDictionary *jsonDataSignUp;
@property (retain, nonatomic) NSMutableDictionary *jsonDataLogIn;
@property (retain, nonatomic) NSMutableDictionary *jsonDataToken;
@property (retain, nonatomic) NSMutableDictionary *jsonDataUser;
@property (retain, nonatomic) NSMutableDictionary *jsonDataTopUp;
@property (retain, nonatomic) NSMutableDictionary *jsonDataHistory;
@property (retain, nonatomic) NSMutableDictionary *jsonDataForgot;
@property (retain, nonatomic) NSMutableDictionary *jsonDataReset;

@property (retain, nonatomic) UIWebView *myPaymentPage;


@property (strong, nonatomic) NSMutableArray *vinosButs;
@property (strong, nonatomic) NSMutableArray *userButs;

@property (strong, nonatomic) UIView *memberView;
@property (strong, nonatomic) UIView *buttonsView;
@property (strong, nonatomic) UIView *signUpView;

@property (strong, nonatomic) UIView *highlightView;

@property (strong, nonatomic) UIButton *infoBut;
@property (strong, nonatomic) UIView *contactInfoView;

@property (strong, nonatomic) UIScrollView *creditHistoryView;
@property (strong, nonatomic) UIScrollView *deliveryHistoryView;

@property (strong, nonatomic) UIView *creditInfoView;
@property (strong, nonatomic) UITextView *welcomeTxt;
@property (strong, nonatomic) NSArray *welcomeTxtArr;

@property (strong, nonatomic) UILabel *memberTitle;
@property (strong, nonatomic) UILabel *refCode;


@property (strong, nonatomic) id myDelegate;

@property (strong, nonatomic) NSTimer *paymentTimeLimitTimer;
@property (strong, nonatomic) UIButton *historyBut;

@property (strong, nonatomic) NSTimer *tokenTimer;
@property (strong, nonatomic) UIImageView *QRcodeImg;

@property (strong, nonatomic) UIButton *loginButM;
@property (strong, nonatomic) UIButton *signUpButM;

@property (strong, nonatomic) UIButton *goToCollection;
@property (strong, nonatomic) UIView *menuView;
//@property (strong, nonatomic) UIButton *deckBut;

@property (strong, nonatomic) UIButton *buyCreditsCCbut;

@property (strong, nonatomic) UIView *userMenuView;

@property (strong, nonatomic) UIButton *menuCloseBut;

-(void)setData:(NSDictionary*)myUser;

-(void)openUser;
-(void)closeUser;
-(void)signUp;
-(void)closeForms;
-(void)forgotPassword;

- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth;
-(void)openUserBuy;
-(void)addTopUp:(NSDictionary*)foundTopUp;
-(BOOL)isUserLoggedIn;

-(void)getUser;

@end
