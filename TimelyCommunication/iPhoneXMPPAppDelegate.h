#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "XMPPReconnect.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "SMClient.h"
#import "AgreenApplyMessage.h"
#import "BaseMesage.h"
@class SettingsViewController;


@interface iPhoneXMPPAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate>
{
	XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    
    BOOL isRegister;
	
	UIWindow *window;

}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

- (BOOL)connect;
- (void)anonymousConnection;
- (void)disconnect;
- (void)sendMsg :(BaseMesage*)msg;
- (void)pushAgreenMsg :(BaseMesage*)msg;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *conversationNavi;
@property (strong, nonatomic) UINavigationController *contactNavi;
@property (strong, nonatomic) UINavigationController *searchNavi;
@property (strong, nonatomic) UINavigationController *meNavi;
@property (strong, nonatomic) SMClient *client;

- (void)turnToMainPage;

@end
