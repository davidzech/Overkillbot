/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: (null)
 */

#import <XXUnknownSuperclass.h> // Unknown library
#import "Overkill-Structs.h"

@class NSString;

__attribute__((visibility("hidden")))
@interface Extra : XXUnknownSuperclass {
@private
	float time;
	float defTime;
	float duration;
	NSString* name;
	NSString* bonusName;
	CGPoint position;
	int type;
	BOOL active;
	int team;
}
-(void)dealloc;
-(int)team;
-(BOOL)active;
-(void)setActive:(BOOL)active;
-(void)incrementTimeFor:(float)aFor;
-(void)decrementTimeFor:(float)aFor;
-(void)setType:(int)type;
-(id)name;
-(void)setTime:(float)time;
-(float)time;
-(float)defTime;
-(CGPoint)position;
-(float)duration;
-(float)percentage;
-(int)type;
-(id)bonusName;
-(id)initWithTeam:(int)team duration:(float)duration name:(id)name bonusName:(id)name4 position:(CGPoint)position type:(int)type;
-(id)initWithDuration:(float)duration name:(id)name position:(CGPoint)position type:(int)type;
-(id)initWithTime:(float)time name:(id)name position:(CGPoint)position type:(int)type;
@end
