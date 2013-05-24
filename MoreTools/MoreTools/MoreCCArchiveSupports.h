//
//  MoreCCArchiveSupports.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-27.
//
//

#import <Foundation/Foundation.h>
#ifdef cocos2d_program
#import "cocos2d.h"
#import "MoreArchiveLoader.h"

@interface CCTextureCache (MoreArchive)
-(CCTexture2D*)addArchiveTextureName:(NSString*)name archive:(NSString*)arName;
@end

@interface CCSprite (MoreArchive)
-(id)initWithArchName:(NSString*)fanme inArchiveFile:(NSString*)arName;
+(id)spriteWithArchName:(NSString*)fanme inArchiveFile:(NSString*)arName;
@end

@interface CCSpriteFrameCache (MoreArchive)
-(void)addArchiveFrameName:(NSString*)name textureName:(NSString*)tname archive:(NSString*)arName;
@end

@interface CCLabelBMFont (MoreArchive)

@end

#endif