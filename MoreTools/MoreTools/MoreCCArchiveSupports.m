//
//  MoreCCArchiveSupports.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-27.
//
//

#import "MoreCCArchiveSupports.h"
#ifdef cocos2d_program
@implementation CCTextureCache (MoreArchive)
-(CCTexture2D*)addArchiveTextureName:(NSString *)name archive:(NSString *)arName{
    NSString *key = [NSString stringWithFormat:@"arch-%@%@",[arName lastPathComponent], name];
    CCTexture2D *tex = [textures_ objectForKey:key];
    if (!tex) {
        NSData *data = [[MoreArchiveLoader singleton] getData:name inArchiveFile:arName];
        UIImage *image = [[UIImage alloc] initWithData:data];
        tex = [[CCTexture2D alloc] initWithCGImage:image.CGImage resolutionType:kCCResolutionUnknown];
        [textures_ setObject:tex forKey:key];
        [tex release];
        [image release];
    }
    return tex;
}
@end

@implementation CCSprite (MoreArchive)
+(id)spriteWithArchName:(NSString*)fanme inArchiveFile:(NSString*)arName{
    return [[[self alloc] initWithArchName:fanme inArchiveFile:arName] autorelease];
}
-(id)initWithArchName:(NSString*)fanme inArchiveFile:(NSString*)arName{
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addArchiveTextureName:fanme archive:arName];
    return [self initWithTexture:tex];
}
@end

@implementation CCSpriteFrameCache (MoreArchive)
-(void)addArchiveFrameName:(NSString*)name textureName:(NSString*)tname archive:(NSString*)arName{
	if( ![loadedFilenames_ member:name]) {
        NSPropertyListFormat format;
		NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:[[MoreArchiveLoader singleton] getData:name inArchiveFile:arName] options:NSPropertyListMutableContainersAndLeaves format:&format error:nil];
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addArchiveTextureName:tname archive:arName];
		[self addSpriteFramesWithDictionary:dict textureReference:tex];
		[loadedFilenames_ addObject:name];
	}else{
		CCLOGINFO(@"cocos2d: CCSpriteFrameCache: file already loaded: %@", plist);
    }
}
@end

#endif