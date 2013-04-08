//
//  MoreData.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-7.
//
//

#import <Foundation/Foundation.h>
#import "MoreMacros.h"

@interface MoreSimpleSaveData : NSObject{
    NSMutableDictionary *content;
    NSString *name;
}
@property(nonatomic,readonly)NSString *name;
+(id)singleton;

-(void)loadSaveData:(NSString*)n;

-(void)saveAll;

-(id)load:(id)key;
-(void)save:(id)obj key:(id <NSCopying>)key;
@end

void writeLog(NSString* content);
void clearLog();