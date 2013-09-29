//
//  HelloWorldLayer.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-3.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "MoreTools.h"
#import "MoreCCArchiveSupports.h"
#import "SimpleAudioEngine.h"

#pragma mark - HelloWorldLayer

@implementation HelloWorldLayer
+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}
-(void)downFinish{
    
}
-(id) init{
	if( (self=[super init]) ) {
        [[MoreArchiveLoader singleton] openArchiveFile:MainBundleFile(@"Test.data") key:@"10086"];
        
        CCSprite *spr = [[CCSprite alloc] initWithArchName:@"b-0@2x.png" inArchiveFile:MainBundleFile(@"Test.data")];
        spr.position = WIN_CENTER;
        [self addChild:spr];
        
        [spr runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:0.5f opacity:0] two:[CCFadeTo actionWithDuration:0.5f opacity:255]]]];
        
        dispatch_queue_t myQueue = dispatch_queue_create("com.yoo.test", NULL);
        dispatch_async(myQueue, ^{
            NSURL *url = [NSURL URLWithString:@"http://ww4.sinaimg.cn/large/69da054djw1e7gblytkn6j20h90crjsl.jpg"];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imageData];
            [self downFinish];
            //dispatch_async(dispatch_get_main_queue(), ^{
                CCSprite *newone = [CCSprite spriteWithCGImage:image.CGImage key:@"too"];
                newone.scale = 0.5;
                [self addChild:newone];
            //});
        });
        
	}
	return self;
}
- (void) dealloc{
	[super dealloc];
}
@end
