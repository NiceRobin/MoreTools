//
//  MoreMacros.h
//  MoreTools
//
//  Created by Nice Robin on 13-4-3.
//
//

#ifndef MoreTools_MoreMacros_h
#define MoreTools_MoreMacros_h
// #define cocos2d_program
// file
#define DocumentDirectoryFile(file) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/%@",file]
#define MainBundleFile(file) [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@",file]

// device
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_RETINA   ([[UIScreen mainScreen] scale] == 2.0f)

// math
#define simpleRandom(from,to)  ((random() % (to + 1 - from)) + from)
#define simpleRandom0_1        ((random() / (float)RAND_MAX ))
#define radians(arg)           ((arg) * 0.01745329252f)
#define degrees(arg)           ((arg) * 57.29577951f)

// cocos2d
#ifdef cocos2d_program
#define WIN_SIZE    [[CCDirector sharedDirector] winSize]
#define WIN_CENTER  ccp(WIN_SIZE.width / 2.0f, WIN_SIZE.height / 2.0f)
#endif

// debugs
#include <execinfo.h>

#define Finger()    NSLog(@"%s Line:%d\n",__FUNCTION__, __LINE__)

#define Trace(arg)                                          \
do {                                                        \
    void *buffer[100];                                      \
    int nptrs = backtrace(buffer, arg);                     \
    char **strings = backtrace_symbols(buffer, nptrs);      \
    for (int j = 0; j < nptrs; j++){                        \
        NSLog(@"%s\n", strings[j]);                         \
    }                                                       \
    NSLog(@"-\n");                                          \
    free(strings);                                          \
} while (0);                                                \

#endif
