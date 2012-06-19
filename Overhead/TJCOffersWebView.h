/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: (null)
 */

#import "TJCUIWebPageView.h"
#import "Overkill-Structs.h"

@class TJCUINavigationBarView, UIViewController, NSString;

__attribute__((visibility("hidden")))
@interface TJCOffersWebView : TJCUIWebPageView {
@private
	TJCUINavigationBarView* navBar_;
	NSString* publisherUserID_;
	UIViewController* parentVController_;
	BOOL enableNavBar;
	BOOL flagOrientationManaged;
	NSString* currencyID_;
	NSString* isSelectorVisible_;
}
@property(retain, nonatomic) TJCUINavigationBarView* navBar;
@property(retain, nonatomic) NSString* isSelectorVisible_;
@property(retain, nonatomic) NSString* currencyID_;
@property(assign, nonatomic) UIViewController* parentVController_;
@property(retain, nonatomic) NSString* publisherUserID_;
+(id)allocWithZone:(NSZone*)zone;
+(id)sharedTJCOffersWebView;
-(void)dealloc;
-(void)giveBackNotification;
-(void)backtoGameAction:(id)action;
-(void)connection:(id)connection didFailWithError:(id)error;
-(void)connectionDidFinishLoading:(id)connection;
-(id)connection:(id)connection willSendRequest:(id)request redirectResponse:(id)response;
-(void)webViewDidFinishLoad:(id)webView;
-(void)webViewDidStartLoad:(id)webView;
-(BOOL)webView:(id)view shouldStartLoadWithRequest:(id)request navigationType:(int)type;
-(void)webView:(id)view didFailLoadWithError:(id)error;
-(void)refreshWebView;
-(void)loadView;
-(void)alertView:(id)view clickedButtonAtIndex:(int)index;
-(id)setUpOffersURLWithServiceURL:(id)serviceURL;
-(void)setCustomNavBarImage:(id)image;
-(void)refreshWithFrame:(CGRect)frame enableNavBar:(BOOL)bar;
-(id)initWithFrame:(CGRect)frame enableNavBar:(BOOL)bar;
-(id)init;
-(oneway void)release;
-(id)autorelease;
-(unsigned)retainCount;
-(id)retain;
-(id)copyWithZone:(NSZone*)zone;
@end
