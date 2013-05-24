//
//  MoreCCUtility.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-7.
//
//

#import <Foundation/Foundation.h>

#ifdef cocos2d_program
#import "cocos2d.h"
@interface MoreAction :NSObject
+(id)moreDelay:(float)time doAction:(id)nact;
+(id)moreDestroySelfAction;
+(id)moreShakeActionWithDuration:(ccTime)d maxR:(float)r;
@end

typedef void (^MoreIntegerCountingActionUpdateBlock)();

@interface MoreIntegerCountingAction : CCActionInterval{
    int start;
    int end;
    int addon;
    int current;
    
    MoreIntegerCountingActionUpdateBlock updateBlock;
}
+(id)actionWithDuration:(ccTime)d start:(int)op end:(int)ed update:(MoreIntegerCountingActionUpdateBlock)bl;
-(id)initWithDuration:(ccTime)d start:(int)op end:(int)ed update:(MoreIntegerCountingActionUpdateBlock)bl;
@end

CGPoint positionOfChild(CGSize contentSize, CGPoint basepos, CGPoint me);
NSString* integerWithComma(int n);

#endif