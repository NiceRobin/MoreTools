//
//  MoreCCActionBundle.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-3.
//
//

#import "MoreCCActionBundle.h"
#ifdef cocos2d_program
@implementation MoreCCActionBundle
@synthesize action;
@synthesize node;
+(id)bundleWithAction:(id)ac node:(CCNode*)nd{
    return [[[self alloc] initWithAction:ac node:nd] autorelease];
}
-(id)initWithAction:(id)ac node:(CCNode*)nd{
    if (self = [super init]) {
        action = [ac retain];
        node = [nd retain];
    }
    return self;
}
-(void)run{
    [node runAction:action];
}
-(void)dealloc{
    [action release];
    [node release];
    [super dealloc];
}
@end
#endif