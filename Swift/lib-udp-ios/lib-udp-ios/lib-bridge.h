#import <Foundation/Foundation.h>

typedef void (^CallbackBlock)(NSString *message);

@interface LibCpp : NSObject

-(void)triggerCallback;
-(void)setCallback:(CallbackBlock)debug
            receive:(CallbackBlock)receive
            start:(CallbackBlock)start;
-(void)sendUDPMessage:(NSString *)IP port:(int)port message:(NSString *)message;
-(void)preReceiveUDPMessage:(int)port;
-(void)receiveUDPMessage;
-(void)socketClose;

@end
