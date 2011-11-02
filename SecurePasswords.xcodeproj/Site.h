//
//  Site.h
//  SecurePasswords
//
//  Created by mac on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ROOT_ELEMENT @"securepasswords"
#define PASSWORD_ELEMENT @"password"
#define NOTE_ELEMENT @"note"
#define USER_ATTRIBUTE @"username"
#define PASSWORD_ATTRIBUTE @"password"
#define SITE_ATTRIBUTE @"site"

@interface Site : NSObject <NSXMLParserDelegate> {
    NSString    *site;
    NSString    *userName;
    NSString    *password;
    NSString    *note;
    
    //internal variables for xml parsing
    NSMutableArray *siteList;
    Site *currentSite;
    NSMutableString *currentNote;
    
}

@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *note;

-(NSMutableArray*) parseXml:(NSData *)xml;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

-(NSString*) createXml;

@end
