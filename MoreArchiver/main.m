//
//  main.m
//  MoreArchiver
//
//  Created by Nice Robin on 13-4-27.
//
//

#import <Foundation/Foundation.h>


BOOL notHiddenFile(NSString* path){
    return ![[path lastPathComponent] hasPrefix:@"."];
}

void archiveFolder(NSString *path, NSString *parentKey, NSMutableDictionary *infoDict, NSFileHandle *outputHandle){
    NSRange range = [[infoDict objectForKey:parentKey] rangeValue];
    uint32_t location = range.location;
    uint32_t totalSize = range.length;
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    for (NSString *item in [mgr contentsOfDirectoryAtPath:path error:nil]) {
        if (notHiddenFile(item)) {
            NSDictionary *attr = [mgr attributesOfItemAtPath:[path stringByAppendingString:item] error:nil];
            if ([[attr objectForKey:NSFileType] isEqualTo:NSFileTypeDirectory]) {
                NSString *subPath = [path stringByAppendingFormat:@"%@/",item];
                NSString *subKey = [parentKey stringByAppendingFormat:@"%@/",item];
                
                NSRange range = NSMakeRange(location, 0);
                [infoDict setObject:[NSValue valueWithRange:range] forKey:subKey];
                archiveFolder(subPath, subKey, infoDict, outputHandle);
                uint32_t size = [[infoDict objectForKey:subKey] rangeValue].length;
                location += size;
                totalSize += size;
            }else{
                NSString *subPath = [path stringByAppendingString:item];
                NSString *subKey = [parentKey stringByAppendingString:item];
                
                NSData *fileData = [mgr contentsAtPath:subPath];
                [outputHandle writeData:fileData];
                
                uint32_t fileSize = [fileData length];
                
                NSRange fileRange = NSMakeRange(location, fileSize);
                [infoDict setObject:[NSValue valueWithRange:fileRange] forKey:subKey];
                location += fileSize;
                totalSize += fileSize;
                NSLog(@"add: %@",subKey);
            }
        }
    }
    if (totalSize) {
        [infoDict setObject:[NSValue valueWithRange:NSMakeRange(range.location, totalSize)] forKey:parentKey];
    }else{
        [infoDict removeObjectForKey:parentKey];
        NSLog(@"%@ is an empty folder",path);
    }
    
}

const NSString *version_string = @"More Archive V1.0";

int main(int argc, const char * argv[]){
    @autoreleasepool {
        if (argc == 3) {
            NSString *path = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
            NSString *outPut = [NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding];
            
            NSFileManager *mgr = [NSFileManager defaultManager];
            if (![mgr fileExistsAtPath:outPut]) {
                [mgr createFileAtPath:outPut contents:nil attributes:nil];
            }
            
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:outPut];

            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:500];
            
            NSData *version = [version_string dataUsingEncoding:NSASCIIStringEncoding];
            [handle writeData:version];
            [dict setObject:[NSValue valueWithRange:NSMakeRange(0, [version length])] forKey:@"Archive_Version"];
            
            NSString *rootKey = @"";
            [dict setObject:[NSValue valueWithRange:NSMakeRange([version length], 0)] forKey:rootKey];
            
            archiveFolder(path, rootKey, dict, handle);
            NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:dict];
            [handle writeData:dictData];
            
            uint32_t packSize = [dictData length];
            [handle writeData:[NSData dataWithBytes:&packSize length:sizeof(uint32_t)]];
            NSLog(@"done");
            [dict release];
            [handle closeFile];
        }
    }
    return 0;
}

