//
//  LFGFetchUserData.m
//  LFG
//
//  Created by Ferran Alejandre on 2/14/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgFetchUserData.h"

@implementation lfgFetchUserData

-(void) fetchData:(NSNumber *)latitude
       longitude:(NSNumber *)longitude
         distance:(NSNumber *)dist{
    
    NSURL *url = [NSURL URLWithString:@"http://solucionesalejandre.com/service.php"];
    
    NSString *post = [NSString stringWithFormat:@"lat="];
    post = [post stringByAppendingString:[latitude stringValue]];
    
    post = [post stringByAppendingString:@"&long="];
    post = [post stringByAppendingString:[longitude stringValue]];
    
    post = [post stringByAppendingString:@"&dist="];
    post = [post stringByAppendingString:[dist stringValue]];
    
    post = [post stringByAppendingString:@"&apiKey=aAfGtEHtRcVDBhYjaGdhYsDj_PoLfGtAxZWMnCUg3WyUhfF"];
    
    post = [post stringByAppendingString:@"&apiKeyPassword=4J5S8ErTyyuYkiL5sSa956Sf2_cvVa74sd4voI896DgtRhjKS"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded:charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
                                              
                               NSData *xmlData = [[NSData alloc] initWithData: data];
                               
                               self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
                               self.xmlParser.delegate = self;
                               [self.xmlParser setShouldResolveExternalEntities:NO];
                               
                               BOOL noData = FALSE;
                               
                               if([self.xmlParser parse]){
                                   for (int userIndex = 0;
                                        userIndex < [self.rootElement.subElements count];
                                        userIndex++) {
                                                      
                                       lfgXMLElement *userObj = [self.rootElement.subElements
                                                                 objectAtIndex:userIndex];
                                       
                                       NSString *userId = @"";
                                       
                                       NSMutableDictionary *userDataTmp = [[NSMutableDictionary alloc] init];
                                       
                                       for (int nodeIndex = 0;
                                            nodeIndex < [userObj.subElements count];
                                            nodeIndex++) {
                                           
                                           lfgXMLElement *nodeObj = [userObj.subElements
                                                                      objectAtIndex:nodeIndex];
                                           
                                           if([nodeObj.name isEqualToString:@"userId"]){
                                               userId = nodeObj.text;
                                           }else if([nodeObj.name isEqualToString:@"distance"]){
                                               NSNumber *distance = [NSNumber
                                                                     numberWithDouble:[nodeObj.text doubleValue]];
                                               [userDataTmp setObject:distance forKey:@"distance"];
                                           }else if([nodeObj.name isEqualToString:@"userName"]){
                                               [userDataTmp setObject:nodeObj.text forKey:@"userName"];
                                           }else if([nodeObj.name isEqualToString:@"lat"]){
                                               [userDataTmp setObject:nodeObj.text forKey:@"lat"];
                                           }else if([nodeObj.name isEqualToString:@"lng"]){
                                               [userDataTmp setObject:nodeObj.text forKey:@"lng"];
                                           }
                                       }
                                       
                                       if([userObj.name isEqualToString:@"noData"]){
                                           [userDataTmp setObject:userObj.text forKey:@"noData"];
                                           noData = TRUE;
                                       }
                                       
                                       [userData setObject:userDataTmp forKey:userId];
                                       userDataTmp = nil;
                                    }
                    
                                    [[NSNotificationCenter defaultCenter]
                                     postNotificationName:@"userDataUpdated"
                                     object:userData];

                               }else{
                                   [[NSNotificationCenter defaultCenter]
                                    postNotificationName:@"userDataUpdated"
                                    object:nil];
                               }

    }];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser{
    self.rootElement = nil;
    self.currentElementPointer = nil;
}

-(void)         parser:(NSXMLParser *)parser
       didStartElement:(NSString *)elementName
          namespaceURI:(NSString *)namespaceURI
         qualifiedName:(NSString *)qName
            attributes:(NSDictionary *)attributeDict{
    
    if(self.rootElement == nil){
        //Theres no root element. Create it and point to it
        self.rootElement = [[lfgXMLElement alloc] init];
        self.currentElementPointer = self.rootElement;
    }else{
        /* Already have root. Create new element and add it as one of
        the subelements of the current element */
        lfgXMLElement *newElement = [[lfgXMLElement alloc] init];
        newElement.parent = self.currentElementPointer;
        [self.currentElementPointer.subElements addObject:newElement];
        self.currentElementPointer = newElement;
    }
    
    self.currentElementPointer.name = elementName;
    self.currentElementPointer.attributes = attributeDict;
}

-(void)     parser:(NSXMLParser *)parser
   foundCharacters:(NSString *)string{
    if([self.currentElementPointer.text length] > 0){
        self.currentElementPointer.text = [self.currentElementPointer.text stringByAppendingString:string];
    }else{
        self.currentElementPointer.text = string;
        
    }
}

-(void)         parser:(NSXMLParser *)parser
         didEndElement:(NSString *)elementName
          namespaceURI:(NSString *)namespaceURI
         qualifiedName:(NSString *)qName{
    
    self.currentElementPointer = self.currentElementPointer.parent;
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser{
    self.currentElementPointer = nil;
}
@end
