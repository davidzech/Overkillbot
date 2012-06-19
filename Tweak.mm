typedef struct CGPoint3f {
	float x;
	float y;
	float z;
} CGPoint3f;

typedef struct ESPColor
{
    float r;
    float g;
    float b;
    float a;
} ESPColor;


typedef enum
{
    teamEnemy =0,
    teamFriendly =1,
    teamBonus =2
} target_team;

typedef enum
{
    targetPerson0,
    targetPerson1,
    targetPerson2,
    targetBot3,
    targetBot4
} target_type;


BOOL aimbot;
BOOL esp;
BOOL nospread;
BOOL wall;


#import <OpenGLES/ES1/gl.h>
#import "Overhead/Target.h"
#import "Overhead/Obstacle.h"
#import "Overhead/WeaponsCampView.h"
#import "Overhead/Supply.h"
#import "Overhead/Texture2D.h"
#import <math.h>

CGPoint getHeadBone(Target *target, NSMutableDictionary *zones);

CGPoint getHeadBone(Target *target, NSMutableDictionary *zones)
{
    target_type type = (target_type)[target type];
    if(type == targetBot3 || type == targetBot4 )
    {
        return [target absoluteTargetPosition];
    }
    
    CGPoint ret;
    NSUInteger index;
    
    NSArray *boneArray = [zones objectForKey:[NSString stringWithFormat:@"%i", [target type]]];
    
    Target *bestT;
    
    for (Target *t in boneArray)
    {
        if([t vulnerability] >= 2.0)
        {
            bestT = t;
        }
    }
    
    index = [boneArray indexOfObject:bestT];
    
    CGRect area = ((Foundation*)[[target arrayOfRects_targetZone] objectAtIndex:index]).area;
    ret.x = area.origin.x + area.size.width/2;
    ret.x-= 4;
    ret.y = area.origin.y + area.size.height/2;
    
    return ret;
}


/* HOOOK OBSTACLE */

%hook Obstacle

-(int)insideObstacle:(CGPoint3f)point onBound:(int)bound
{
    return (wall) ? NO : %orig;
}

%end


/* END HOOK OBSTACLE */



/* HOOK TARGET */

%hook Target

%new
-(CGRect)getArea
{
    NSArray *array = [self arrayOfRects_targetZone];
    float bottom,left,right,top;
    CGRect first = [(Foundation*)[array objectAtIndex:0] area];
    bottom = first.origin.x;
    left = first.origin.y + first.size.height;
    right = first.origin.y;
    top = first.origin.x + first.size.width;
    for(Foundation *f in array)
    {
        CGRect area = f.area;
        if(area.origin.x < bottom) bottom = area.origin.x;
        if(area.origin.y + area.size.height > left) left = area.origin.y+area.size.height;
        if(area.origin.y < right) right = area.origin.y;
        if(area.origin.x + area.size.width > top) top = area.origin.x + area.size.width;
        
    }
    
    CGRect rect = CGRectMake(bottom,right,fabs(bottom-top),fabs(right-left));
    return rect;
}

%end

/* END HOOK TARGET */


%hook WeaponsCampView

%new
-(void)loadTextString:(NSString*)text
{
    id font = [MSHookIvar<NSMutableArray*>(self, "fonts") objectAtIndex:0];
    id image = [font performSelector:NSSelectorFromString(@"writeTextToTexture:") withObject:text];
    Texture2D *tex = [[[%c(Texture2D) alloc] initWithImage:image] autorelease];
    NSMutableDictionary *dTexts = MSHookIvar<NSMutableDictionary*>(self, "dTexts");
    [dTexts setObject:tex forKey:text];
}


-(void)drawText:(id)text atPosition:(CGPoint)position withAlignment:(int)alignment r:(float)r g:(float)g b:(float)b alpha:(float)alpha scale:(float)scale rotation:(float)rotation effectKey:(id)key effectType:(id)type
{
    NSMutableDictionary *dict = MSHookIvar<NSMutableDictionary*>(self, "dTexts");
    if([dict objectForKey:text] == nil)
        [self loadTextString:text];
    %orig;
}

%new
-(void)drawESP:(CGRect)rect color:(ESPColor)color
{
    if(!esp) return;
    GLfloat squareVertices[] = {
        rect.origin.x, rect.origin.y,
        rect.origin.x, rect.origin.y+rect.size.height,
        rect.origin.x+rect.size.width, rect.origin.y+rect.size.height,
        rect.origin.x+rect.size.width, rect.origin.y
    };
    
    glDisable(GL_TEXTURE_2D);
    glBlendFunc(0x302, 0x303);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glLineWidth(3.0);
    glColor4f(color.r, color.g, color.b, color.a);
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glPushMatrix();
    glLoadIdentity();
    glShadeModel(0x1d01);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
    glEnable(0xB20);
    
    glHint(0xC52, 0x1102);
    glEnable(0xDE1);
    glBlendFunc(1, 0x303);
    glPopMatrix();

}

-(void)renderGUI
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGPoint pos = CGPointMake(screenBounds.size.width-75,screenBounds.size.height/2);
    [self drawText:@"OverkillBot 0.1 by Nighthawk" atPosition:pos withAlignment:2
                 r:255 g:255 b:255 alpha:1.0 scale:0.6 rotation:-90.0 effectKey:@"" effectType:@""];
    
    NSMutableArray *objects = MSHookIvar<NSMutableArray*>(self, "_container");
    for (id object in objects)
    {
        if([object isMemberOfClass:%c(Target)])
        {
            CGRect rect;
            rect = [(Target*)object getArea];
            NSLog(@"%@", NSStringFromCGRect(rect));
            ESPColor color;
            if(MSHookIvar<BOOL>(self, "_isMultiplayer"))
            {
                NSLog(@"TEAM IS %i", [(Target*)object getTeam]);
                if([(Target*)object getTeam] == teamEnemy)
                {
                    color.r = 1.0;
                    color.g = 0.0;
                    color.b = 0.0;
                    color.a = 1.0;
                }
                if([(Target*)object getTeam] == teamFriendly)
                {
                    color.r = 0.0;
                    color.g = 0.0;
                    color.b = 1.0;
                    color.a = 1.0;
                }
                if([(Target*)object getTeam] == teamBonus)
                {
                    color.r = 1.0;
                    color.g = 1.0;
                    color.b = 1.0;
                    color.a = 1.0;
                }
            }
            else
            {
                color.r = 1.0;
                color.g = 1.0;
                color.b = 1.0;
                color.a = 1.0;
            }
            //NSLog(@"alpha %f", MSHookIvar<float>(object, "alpha"));
            float showTime = [(Target*)object showAtTime];
            int totalTime = MSHookIvar<int>(self, "_totalTime");
            //NSLog(@"total time is %i | showtime is %f", totalTime, showTime);
            if([(Target*)object isAlive] && !MSHookIvar<BOOL>(object, "isTemplate") && totalTime > showTime)
                [self drawESP:rect color:color];
        }
    }
    
    %orig;
}


-(void)handleFiring:(int)arguments
{
    NSMutableArray *objects = MSHookIvar<NSMutableArray*>(self, "_container");
    
    Target *bestTarget = nil;
    Supply *bestSupply = nil;
    
    if(nospread)
    {
    *&MSHookIvar<float>(self, "_accuracyShotOffset") = 0.0f;
    CGPoint *shootOffset = &MSHookIvar<CGPoint>(self, "_shootOffset");
    CGPoint *accuracyShot = &MSHookIvar<CGPoint>(self, "_accuracyShot");
    accuracyShot->x = 0.0;
    accuracyShot->y = 0.0;
    shootOffset->x = 0.0;
    shootOffset->y = 0.0;
    *&MSHookIvar<float>(self, "_cfg_accurancy_range") = 0.0;
    }
    
    for (id object in objects)
    {
        if([object isMemberOfClass:%c(Target)])
        {
            if(MSHookIvar<BOOL>(self, "_isMultiplayer"))
            {
                if([(Target*)object getTeam] == teamEnemy)
                    continue;
            }

            float showTime = [(Target*)object showAtTime];
            int totalTime = MSHookIvar<int>(self, "_totalTime");
            if(!bestTarget) //  set initial
            {
                if([(Target*)object isAlive] && totalTime >= showTime  ) //&& ![(Target*)object behindObstacle:MSHookIvar<NSMutableArray*>(self,"_container")]
                    bestTarget = (Target*)object;
                continue;
            }
            if([(Target*)object showAtTime] < [bestTarget showAtTime]  && totalTime >= showTime && [(Target*)object isAlive] && !MSHookIvar<BOOL>(bestTarget, "isTemplate") )
                bestTarget = (Target*)object;
        }
        if([object isMemberOfClass:%c(Supply)])
        {
            if(!bestSupply)
            {
                bestSupply = (Supply*)object;
            }
            if(![(Supply*)object isDestroyed])
            {
                bestSupply = (Supply*)object;
                break;
            }
        }
    }
    
    
    if(!aimbot)
    {
        %orig;
        return;
    }
    
    
    CGPoint *curAim = &MSHookIvar<CGPoint>(self, "_target");
    
    if(MSHookIvar<BOOL>(self, "_manualFire") || MSHookIvar<BOOL>(self, "_firing"))
    {
    if(!bestSupply || [bestSupply isDestroyed] || [bestSupply isCollected])
    {
        if(bestTarget && !MSHookIvar<BOOL>(bestTarget, "isTemplate") )
        {
            NSMutableDictionary *zones = MSHookIvar<NSMutableDictionary*>(bestTarget, "dTargetZones");

            CGPoint enemy = getHeadBone(bestTarget, zones);
            
            curAim->x = enemy.x;
            curAim->y = enemy.y;
        }
    }
    else
    {
        CGPoint supply = [bestSupply position];
        curAim->x = supply.x;
        curAim->y = supply.y;
    }
    }
    %orig;
}

%end

__attribute__((constructor)) void entrypoint()
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.nighthawk.overkillbot.plist"];
    if(!dictionary) return;
    
    aimbot = [[dictionary objectForKey:@"kAimbot"] boolValue];
    esp = [[dictionary objectForKey:@"kEsp"] boolValue];
    nospread = [[dictionary objectForKey:@"kSpread"] boolValue];
    wall = [[dictionary objectForKey:@"kWall"] boolValue];
}

