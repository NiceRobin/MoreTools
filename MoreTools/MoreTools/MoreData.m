//
//  MoreData.m
//  MoreTools
//
//  Created by Nice Robin on 13-4-7.
//
//

#import "MoreData.h"
static MoreSimpleSaveData *MoreSimpleSaveDataInstance_ = nil;
@implementation MoreSimpleSaveData
@synthesize name;
+(id)singleton{
    if (!MoreSimpleSaveDataInstance_) {
        MoreSimpleSaveDataInstance_ = [[MoreSimpleSaveData alloc] init];
    }
    return MoreSimpleSaveDataInstance_;
}
-(void)loadSaveData:(NSString*)n{
    name = [n copy];
    
    content = [NSMutableDictionary dictionaryWithContentsOfFile:DocumentDirectoryFile(name)];
    [content retain];
}
-(id)load:(id)key{
    return [content objectForKey:key];
}
-(void)save:(id)obj key:(id <NSCopying>)key{
    [content setObject:obj forKey:key];
}

-(void)saveAll{
    [content writeToFile:DocumentDirectoryFile(name) atomically:YES];
}
-(void)dealloc{
    [content release];
    [name release];
    [super dealloc];
}
@end

NSData *moreAES(NSData *input, NSString *key, CCOperation op){
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF16StringEncoding];
    
    NSUInteger length = input.length;
    size_t size = length + kCCBlockSizeAES128;
    void *buffer = malloc(size);
    
    size_t encryptedLength = 0;
    
    CCCryptorStatus result = CCCrypt(op, kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL,
                                     [input bytes], input.length,
                                     buffer, size,
                                     &encryptedLength);
    NSData *ret = nil;
    if (result == kCCSuccess) {
        ret = [NSData dataWithBytes:buffer length:encryptedLength];
        free(buffer);
    }else{
        free(buffer);
    }
    return ret;
}

void writeLog(NSString* content){
    NSString *path = DocumentDirectoryFile(@"MoreLog.log");
    FILE *fpointer = fopen([path cStringUsingEncoding:NSASCIIStringEncoding], "a");
    
    time_t now;
    time(&now);
    struct tm *timeNow;
    timeNow = localtime(&now);
    fprintf(fpointer, "\n- %d-%d-%d %d:%d:%d\n",timeNow -> tm_year + 1900, timeNow -> tm_mon + 1, timeNow -> tm_mday, timeNow -> tm_hour, timeNow -> tm_min, timeNow -> tm_sec);
    fputs([content cStringUsingEncoding:NSASCIIStringEncoding], fpointer);
    fprintf(fpointer, "\n-\n");
    fclose(fpointer);
}
void clearLog(){
    NSString *path = DocumentDirectoryFile(@"MoreLog.log");
    FILE *fpointer = fopen([path cStringUsingEncoding:NSASCIIStringEncoding], "w");
    fclose(fpointer);
}