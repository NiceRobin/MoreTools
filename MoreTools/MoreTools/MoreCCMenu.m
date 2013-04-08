//
//  MoreCCMenu.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-3.
//
//

#import "MoreCCMenu.h"
#ifdef cocos2d_program

@implementation MoreCCMenu
@synthesize opacity = opacity_, color = color_;
-(id)init{
    if (self = [super init]) {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		self.isTouchEnabled = YES;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
		self.isMouseEnabled = YES;
#endif
        // menu in the center of the screen
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		self.isRelativeAnchorPoint = NO;
		[self setContentSize:s];
        
        selectedItem_ = nil;
		state_ = kCCMenuStateWaiting;
    }
    return self;
}
-(void) dealloc
{
	[super dealloc];
}

/*
 * override add:
 */
-(void) addChild:(CCMenuItem*)child z:(NSInteger)z tag:(NSInteger) aTag
{
	NSAssert( [child isKindOfClass:[CCMenuItem class]], @"Menu only supports MenuItem objects as children");
	[super addChild:child z:z tag:aTag];
}

- (void) onExit
{
	if(state_ == kCCMenuStateTrackingTouch)
	{
		[selectedItem_ unselected];
		state_ = kCCMenuStateWaiting;
		selectedItem_ = nil;
	}
	[super onExit];
}
#pragma mark Menu - Touches

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kCCMenuTouchPriority swallowsTouches:YES];
}

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
			
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( state_ != kCCMenuStateWaiting || !visible_ )
		return NO;
	
	for( CCNode *c = self.parent; c != nil; c = c.parent )
		if( c.visible == NO )
			return NO;
    
	selectedItem_ = [self itemForTouch:touch];
	[selectedItem_ selected];
	
	if( selectedItem_ ) {
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	
	[selectedItem_ unselected];
	[selectedItem_ activate];
	
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchCancelled] -- invalid state");
	
	[selectedItem_ unselected];
	
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *currentItem = [self itemForTouch:touch];
	
	if (currentItem != selectedItem_) {
		[selectedItem_ unselected];
		selectedItem_ = currentItem;
		[selectedItem_ selected];
	}
}

#pragma mark Menu - Mouse

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

-(NSInteger) mouseDelegatePriority
{
	return kCCMenuMousePriority+1;
}

-(CCMenuItem *) itemForMouseEvent: (NSEvent *) event
{
	CGPoint location = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
	
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
			
			CGPoint local = [item convertToNodeSpace:location];
			
			CGRect r = [item rect];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

-(BOOL) ccMouseUp:(NSEvent *)event
{
	if( ! visible_ )
		return NO;
    
	if(state_ == kCCMenuStateTrackingTouch) {
		if( selectedItem_ ) {
			[selectedItem_ unselected];
			[selectedItem_ activate];
		}
		state_ = kCCMenuStateWaiting;
		
		return YES;
	}
	return NO;
}

-(BOOL) ccMouseDown:(NSEvent *)event
{
	if( ! visible_ )
		return NO;
	
	selectedItem_ = [self itemForMouseEvent:event];
	[selectedItem_ selected];
    
	if( selectedItem_ ) {
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
    
	return NO;
}

-(BOOL) ccMouseDragged:(NSEvent *)event
{
	if( ! visible_ )
		return NO;
    
	if(state_ == kCCMenuStateTrackingTouch) {
		CCMenuItem *currentItem = [self itemForMouseEvent:event];
		
		if (currentItem != selectedItem_) {
			[selectedItem_ unselected];
			selectedItem_ = currentItem;
			[selectedItem_ selected];
		}
		
		return YES;
	}
	return NO;
}

#endif // Mac Mouse support

#pragma mark Menu - Opacity Protocol

/** Override synthesized setOpacity to recurse items */
- (void) setOpacity:(GLubyte)newOpacity
{
	opacity_ = newOpacity;
	
	id<CCRGBAProtocol> item;
	CCARRAY_FOREACH(children_, item)
    [item setOpacity:opacity_];
}

-(void) setColor:(ccColor3B)color
{
	color_ = color;
	
	id<CCRGBAProtocol> item;
	CCARRAY_FOREACH(children_, item)
    [item setColor:color_];
}
@end

#define MorePopMenuItemDefaultRate (0.08f)

@implementation MorePopMenuItem
@synthesize delegate;
-(void)onEnter{
    [super onEnter];
    rate = MorePopMenuItemDefaultRate;
}
-(void)selected{
    [normalImage_ setScale:1.0f - rate];
    for(CCNode *node in [normalImage_ children]){
        [node setScale:1.0f - rate];
    }
    [normalImage_ setPosition:ccpAdd(normalImage_.position, ccp((normalImage_.contentSize.width * rate)/2.0f,
                                                                (normalImage_.contentSize.height * rate)/2.0f))];
    if ([delegate respondsToSelector:@selector(bubbleMenuItemSelect:)]) {
        [delegate bubbleMenuItemSelect:self];
    }
    
    [super selected];
}
-(void)unselected{
    [normalImage_ setScale:1.0f];
    for(CCNode *node in [normalImage_ children]){
        [node setScale:1.0f];
    }
    [normalImage_ setPosition:ccpSub(normalImage_.position, ccp((normalImage_.contentSize.width * rate)/2.0f,
                                                                (normalImage_.contentSize.height * rate)/2.0f))];
    if ([delegate respondsToSelector:@selector(bubbleMenuItemUnselect:)]) {
        [delegate bubbleMenuItemUnselect:self];
    }
    
    [super unselected];
}
-(void)setPopRate:(float)r{
    rate = r;
}
@end
#endif
