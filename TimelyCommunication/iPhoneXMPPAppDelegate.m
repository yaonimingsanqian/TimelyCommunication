#import "iPhoneXMPPAppDelegate.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "ContactsViewController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "Config.h"
#import "LoginViewController.h"
#import "User.h"
#import <CFNetwork/CFNetwork.h>
#import "MessageFactory.h"
#import "MainPageUIViewController.h"
#import "TextMessage.h"
#import "ConversationMgr.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
  static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
  static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface iPhoneXMPPAppDelegate()
{
    User *stockUser;
}

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation iPhoneXMPPAppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;

@synthesize window;

- (UIViewController*)createVCAccordingTag :(int)tag
{
    UIViewController *controller = nil;
    switch (tag)
    {
        case 100:
            controller = [[MainPageUIViewController alloc]init];
            break;
        case 101:
        {
            controller = [[ContactsViewController alloc]init];
            break;
        }
            
        default:
            controller = [[UIViewController alloc]init];
            break;
    }
    return controller;
}
- (UINavigationController*)createTabBarItem :(NSString*)title :(NSString*)imageName :(int)tag
{
    UIViewController *conversationList = [self createVCAccordingTag:tag];
    
    conversationList.view.backgroundColor=[UIColor whiteColor];
    conversationList.tabBarItem=[[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:conversationList];
    UILabel *naviTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, 100, 20)];
    naviTitle.tag = 100;
    naviTitle.text = title;
    // navi.navigationBar.tintColor = [UIColor blackColor];
    [navi.navigationBar addSubview:naviTitle];
    return navi;
}
- (void)turnToMainPage
{
    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    
    self.conversationNavi = [self createTabBarItem:@"会话" :@"chat.png" :100];
    self.contactNavi = [self createTabBarItem:@"通讯录" :@"contact.png" :101];
    self.searchNavi = [self createTabBarItem:@"发现" :@"search.png" :102];
    self.meNavi = [self createTabBarItem:@"我" :@"me.png" :103];
    
    NSMutableArray *controllers=[[NSMutableArray alloc]initWithObjects:self.conversationNavi,self.self.contactNavi,self.searchNavi,self.meNavi,nil];
    [tabBarController setViewControllers:controllers];
    tabBarController.delegate=self;
    self.window.rootViewController = nil;
    self.window.rootViewController = tabBarController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.client = [[SMClient alloc] initWithAPIVersion:@"0" publicKey:@"516d1971-6d5e-40c1-995b-27e9034f94bc"];
	[self setupStream];
	self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    NSString *pass = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    if(username&&pass)
    {
        [self turnToMainPage];
        stockUser = [[User alloc]init];
        stockUser.password = pass;
        stockUser.username = [[username componentsSeparatedByString:@"@"] objectAtIndex:0];
        [stockUser login:^(NSDictionary *success) {
            
        } :^(NSError *error) {
            
        }];
        return YES;
        
    }
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)dealloc
{
	[self teardownStream];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	xmppStream = [[XMPPStream alloc] init];
	
	#if !TARGET_IPHONE_SIMULATOR
	{
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
	#endif
	xmppReconnect = [[XMPPReconnect alloc] init];
	[xmppReconnect         activate:xmppStream];
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppStream setHostName:@"192.168.1.104"];
	[xmppStream setHostPort:5222];
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppReconnect         deactivate];
	[xmppStream disconnect];
	xmppStream = nil;
	xmppReconnect = nil;
}

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
    NSLog(@"上线了");
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)anonymousConnection
{
    NSString *tjid = [[NSString alloc] initWithFormat:@"anonymous@%@", kServerName];
    [xmppStream setMyJID:[XMPPJID jidWithString:tjid]];
    if ([xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil])
    {
        isRegister = YES;
    }
}
- (void)sendMsg:(BaseMesage *)msg
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:msg.msgContent];
	
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *jid = [[msg.to stringByAppendingString:@"@"] stringByAppendingString:kServerName];
    [message addAttributeWithName:@"to" stringValue:jid];
    [message addAttributeWithName:@"from" stringValue:msg.from];
    [message addAttributeWithName:@"time" stringValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
	
    [message addChild:body];
	
    [xmppStream sendElement:message];
}
- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}

	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;

	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting" 
		                                                    message:@"See console for error details." 
		                                                   delegate:nil 
		                                          cancelButtonTitle:@"Ok" 
		                                          otherButtonTitles:nil];
		[alertView show];

		DDLogError(@"Error connecting: %@", error);

		return NO;
	}

	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket 
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}
- (void)registerUser
{
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    NSError *error=nil;
    if (![xmppStream registerWithPassword:myPassword error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
    
    
    if(isRegister)
    {
        isRegister = NO;
        [self registerUser];
        return;
    }
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterSuccess object:nil];
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
     [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterFailed object:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    BaseMesage *msg = [MessageFactory createMsg:message];
    if(([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground))
    {
        [msg postLocalNotifaction];
    }
   
    NSString *user = [[msg.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    if([msg isKindOfClass:[TextMessage class]] && ![[ConversationMgr sharedInstance] isConversationExist:user])
    {
        [[ConversationMgr sharedInstance] saveConversation:user];
    }
    [msg doSelfThing];
}
@end
