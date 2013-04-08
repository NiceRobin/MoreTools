//
//  MoreCCActionBundle.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-3.
//
//

#import <Foundation/Foundation.h>
#ifdef cocos2d_program
#import "cocos2d.h"
@interface MoreCCActionBundle : NSObject{
    id action;
    CCNode *node;
}
@property(nonatomic,retain)id action;
@property(nonatomic,retain)CCNode *node;
+(id)bundleWithAction:(id)ac node:(CCNode*)nd;
-(id)initWithAction:(id)ac node:(CCNode*)nd;
-(void)run;
@end
#endif