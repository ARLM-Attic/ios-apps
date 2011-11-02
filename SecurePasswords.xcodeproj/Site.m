//
//  Site.m
//  SecurePasswords
//
//  Created by mac on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Site.h"
#import "NSString+XMLEncoding.h"




@implementation Site

@synthesize site;
@synthesize userName;
@synthesize password;
@synthesize note;

-(void) dealloc {
    [site release];
    [userName release];
    [password release];
    [note release];
    [super dealloc];
}


-(NSMutableArray*) parseXml:(NSData *)xml
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];
    siteList = [[NSMutableArray alloc] init];

    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    [parser release];
    
     return siteList;
     
}

//create xml for one site
-(NSString*) createXml
{
    NSMutableString *xml = [[NSMutableString alloc]init];
    [xml appendFormat:@"<%@ %@=\"%@\" %@=\"%@\" %@=\"%@\"", PASSWORD_ELEMENT, SITE_ATTRIBUTE,
     [site xmlSimpleEscapeString], USER_ATTRIBUTE, [userName xmlSimpleEscapeString], PASSWORD_ATTRIBUTE,
     [password xmlSimpleEscapeString]];
   
    //add note element if note is not nil
    if( note != nil)
    {
        [xml appendFormat:@"><%1$@>%2$@</%1$@></%3$@>", NOTE_ELEMENT, [note xmlSimpleEscapeString], PASSWORD_ELEMENT];
    }
    else 
    {
        [xml appendString:@"/>"];
    }

    //remove null strings
    NSString *cleanXml = (NSMutableString*) [xml stringByReplacingOccurrencesOfString:@"(null)" withString:@""];

    [xml release];
    return cleanXml;
}

//create list of site and site objects when start tags are found
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

   
    if ( [elementName isEqualToString:PASSWORD_ELEMENT])
    {
        currentSite = [[Site alloc] init];
        currentSite.site = [attributeDict objectForKey:SITE_ATTRIBUTE];
        currentSite.userName = [attributeDict objectForKey:USER_ATTRIBUTE];
        currentSite.password = [attributeDict objectForKey:PASSWORD_ATTRIBUTE];
        return;
    }
    
    if ( [elementName isEqualToString:NOTE_ELEMENT])
    {
        currentNote = [[NSMutableString alloc] init];
    }

}   

//only text is in notes, so only add it if we have encoutered a note element previously
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (currentNote != nil )
    {
        [currentNote appendString:string];
    }
}

//save Site object to array when closing element is found
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ( [elementName isEqualToString:PASSWORD_ELEMENT] ) {
        [siteList addObject:currentSite];
        [currentSite release];
        return;
    }
    
    if ( [elementName isEqualToString:NOTE_ELEMENT] )
    {
        currentSite.note = currentNote;
    }
    
}


@end
