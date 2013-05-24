//
//  MoreArchiveLoader.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-27.
//
//

#import "MoreArchiveLoader.h"

static MoreArchiveLoader *instance_ = nil;

@interface MoreArchiveInfoBundle : NSObject{
    NSFileHandle *handle;
    NSDictionary *fileInfos;
}
@property(nonatomic,retain)NSFileHandle *handle;
@property(nonatomic,retain)NSDictionary *fileInfos;
+(id)bundleWithHandle:(NSFileHandle*)h fileInfo:(NSDictionary*)dict;
-(id)initWithHandle:(NSFileHandle*)h fileInfo:(NSDictionary*)dict;
@end

@implementation MoreArchiveInfoBundle
@synthesize handle;
@synthesize fileInfos;
+(id)bundleWithHandle:(NSFileHandle*)h fileInfo:(NSDictionary*)dict{
    return [[[self alloc] initWithHandle:h fileInfo:dict] autorelease];
}
-(id)initWithHandle:(NSFileHandle*)h fileInfo:(NSDictionary*)dict{
    if (self = [super init]) {
        handle = [h retain];
        fileInfos = [dict retain];
    }
    return self;
}

-(void)dealloc{
    [handle release];
    [fileInfos release];
    [super dealloc];
}
@end

@implementation MoreArchiveLoader
+(MoreArchiveLoader*)singleton{
    if (!instance_) {
        instance_ = [[MoreArchiveLoader alloc] init];
    }
    return instance_;
}
-(id)init{
    if (self = [super init]) {
        handleSet = [[NSMutableDictionary alloc] initWithCapacity:same_time_opened_archives];
    }
    return self;
}
-(void)dealloc{
    for (MoreArchiveInfoBundle *bundle in [handleSet allValues]) {
        [bundle.handle closeFile];
    }
    [handleSet release];
    [super dealloc];
}
-(void)openArchiveFile:(NSString*)arName{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:arName];
    unsigned long long offset = [handle seekToEndOfFile];
    [handle seekToFileOffset:offset - sizeof(uint32_t)];
    NSData *date = [handle readDataOfLength:sizeof(uint32_t)];
    offset -= sizeof(uint32_t);
    uint32_t total;
    [date getBytes:&total range:NSMakeRange(0, sizeof(uint32_t))];
    [handle seekToFileOffset:offset - total];
    NSData *dictData = [handle readDataOfLength:total];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
    [handleSet setValue:[MoreArchiveInfoBundle bundleWithHandle:handle fileInfo:dict] forKey:arName];
}
-(void)closeArchiveFile:(NSString*)arName{
    MoreArchiveInfoBundle *bundle = [handleSet objectForKey:arName];
    if (bundle) {
        [bundle.handle closeFile];
        [handleSet removeObjectForKey:arName];
    }
}
-(NSData*)getData:(NSString*)name inArchiveFile:(NSString *)arName{
    MoreArchiveInfoBundle *bundle = [handleSet objectForKey:arName];
    NSFileHandle *handle = bundle.handle;
    NSRange fileRange = [[bundle.fileInfos objectForKey:name] rangeValue];
    [handle seekToFileOffset:fileRange.location];
    return [handle readDataOfLength:fileRange.length];
}
+(void)end{
    [instance_ release];
    instance_ = nil;
}

@end
