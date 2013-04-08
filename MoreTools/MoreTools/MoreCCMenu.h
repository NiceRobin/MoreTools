//
//  MoreCCMenu.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-3.
//
//

#import <Foundation/Foundation.h>
#ifdef cocos2d_program

#import "cocos2d.h"
@interface MoreCCMenu : CCLayer <CCRGBAProtocol> {
    tCCMenuState state_;
	CCMenuItem	*selectedItem_;
	GLubyte		opacity_;
	ccColor3B	color_;
}
/** conforms to CCRGBAProtocol protocol */
@property (nonatomic,readonly) GLubyte opacity;
/** conforms to CCRGBAProtocol protocol */
@property (nonatomic,readonly) ccColor3B color;
@end

@class MorePopMenuItem;
@protocol MorePopMenuItemDelegate <NSObject>
@optional
-(void)bubbleMenuItemSelect:(MorePopMenuItem*)me;
-(void)bubbleMenuItemUnselect:(MorePopMenuItem*)me;
@end

@interface MorePopMenuItem : CCMenuItemSprite{
    id<MorePopMenuItemDelegate> delegate;
    float rate;
}
@property(nonatomic,assign)id<MorePopMenuItemDelegate> delegate;
-(void)setPopRate:(float)r;
@end
#endif