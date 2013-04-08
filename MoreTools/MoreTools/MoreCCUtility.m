//
//  MoreCCUtility.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-7.
//
//

#import "MoreCCUtility.h"

#ifdef cocos2d_program
@implementation MoreAction
+(id)moreDelay:(float)time doAction:(id)nact;{
    return [CCSequence actionOne:[CCDelayTime actionWithDuration:time] two:nact];
}
+(id)moreDestroySelfAction{
    return [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
}
+(id)moreShakeActionWithDuration:(ccTime)d maxR:(float)r{
    float tim = d / 4.0f;
    float angle = M_PI * CCRANDOM_0_1() * 2.0f;
    ccVertex2F direction = (ccVertex2F){cosf(angle),sinf(angle)};
    id a1 = [CCMoveBy actionWithDuration:tim position:ccp(direction.x * r, direction.y * r)];
    id a2 = [CCMoveBy actionWithDuration:tim position:ccp(direction.x * -r, direction.y * -r)];
    id a3 = [CCMoveBy actionWithDuration:tim position:ccp(direction.x * -r, direction.y * -r)];
    id a4 = [CCMoveBy actionWithDuration:tim position:ccp(direction.x * r, direction.y * r)];
    return [CCSequence actions:a1, a2, a3, a4, nil];
}
@end

@implementation MoreIntegerCountingAction
+(id)actionWithDuration:(ccTime)d start:(int)op end:(int)ed update:(MoreIntegerCountingActionUpdateBlock)bl{
    return [[[self alloc] initWithDuration:d start:op end:ed update:bl] autorelease];
}
-(id)initWithDuration:(ccTime)d start:(int)op end:(int)ed update:(MoreIntegerCountingActionUpdateBlock)bl{
    if (self = [super initWithDuration:d]) {
        start = op;
        end = ed;
        updateBlock = Block_copy(bl);
    }
    return self;
}
-(void)startWithTarget:(id<CCLabelProtocol> )aTarget{
    [super startWithTarget:aTarget];
    addon = end - start;
    updateBlock();
}
-(void)update:(ccTime)t{
    id <CCLabelProtocol> tar = target_;
    int old = current;
    current = start + addon * t;
    [tar setString:[NSString stringWithFormat:@"%d",current]];
    if (current != old) {
        updateBlock();
    }
}
-(void)dealloc{
    Block_release(updateBlock);
    [super dealloc];
}
@end

CGPoint positionOfChild(CGSize parentContentSize, CGPoint parentPos, CGPoint childPosition){
    return ccpSub(ccp(parentContentSize.width / 2.0f, parentContentSize.height / 2.0f), ccpSub(parentPos, childPosition));
}
NSString* integerWithComma(int n){
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:n]];
    [formatter release];
    return formatted;
}
#endif