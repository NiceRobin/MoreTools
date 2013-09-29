//
//  MoreArchiveLoader.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-27.
//
//

#import <Foundation/Foundation.h>
#import "MoreData.h"

#define same_time_opened_archives   10
#define key_version_info            @"Archive_Version"
@interface MoreArchiveLoader : NSObject{
    NSMutableDictionary *handleSet;
}
+(MoreArchiveLoader*)singleton;
+(void)end;

-(void)openArchiveFile:(NSString*)arName key:(NSString*)key;
-(void)closeArchiveFile:(NSString*)arName;
-(NSData*)getData:(NSString*)name inArchiveFile:(NSString*)arName;


@end
