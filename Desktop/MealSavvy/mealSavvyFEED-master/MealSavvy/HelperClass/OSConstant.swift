//
//  OSConstant.swift
//  OutNSocial
//
//  Created by Sumit  Appsinvo on 26/03/18.
//  Copyright © 2018 Sumit  Appsinvo. All rights reserved.
//

import UIKit


//MARK: *************** Constant ***************
struct Constant {
    //MARK: *************** Constant Color ***************
    static let kAPP_YELLOW_COLOR             = UIColor.getRGBColor(255, g: 209, b: 85)
    static let kAPP_GREEN_COLOR             = UIColor.getRGBColor(111, g: 137, b: 67)
    static let kAPP_DARK_GREY_COLOR         = UIColor.getRGBColor(151, g: 151, b: 151)
    static let kAPP_TEXT_BLACK_COLOR        = UIColor.black
    static let kAPP_TEXT_WHITE_COLOR        = UIColor.white
    static let kAPP_WHITE_BG_COLOR          = UIColor.getRGBColor(247, g: 247, b: 247)
    static let kAPP_BLACK_BG_COLOR          = UIColor.getRGBColor(21, g: 22, b: 29)
    //MARK: *************** Constant Image ***************
    
    //MARK: *************** Constant Variable Name ***************
    static let kBASE_URL                    = "http://appsinvo.com/startupspace/public/api/"
    static let kTOKEN                       = "1234"
    static let kIS_LOGIN                    = "isLogin"
    static let kPUBLIC_PROFILE              = "public_profile"
    static let kUSER_LOCATION               = "user_location"
    static let kUSER_PHOTOS                 = "user_photos"
    static let kUSER_FRIENDS                = "user_friends"
    static let kUSER_BRITHDAY               = "user_birthday"
    static let kBIRTHDAY                    = "birthday"
    static let kUSER_TYPE                   = "userType"
    static let kLINK                        = "link"
    static let kFIRST_NAME                  = "firstName"
    static let kLAST_NAME                   = "lastName"
    static let kDOB                         = "dob"
    static let kCOUNTRYCODE                = "countryCode"
    static let kAPPNAME                     = "Meal Savvy"
    static let IS_FIRST_LAUNCH              = "isFirstLaunch"
    static let kNAME                        = "name"
    static let kIMAGE                       = "image"
    static let kEMAIL                       = "email"
    static let kMETHOD                      = "method"
    static let kIMAGE_SELECTED              = "imageSelected"
    static let kIS_SELECTED                 = "isSelected"
    static let kQUESTION                    = "question"
    static let kOPTION1                     = "option1"
    static let kOPTION2                     = "option2"
    static let kOPTION3                     = "option3"
    static let kOPTION4                     = "option4"
    static let kANSWER                      = "answer"
    static let kEMAIL_PHONE                 = "emailPhone"
    static let kOTP                         = "otp"
    static let kUSER_NAME                   = "userName"
    static let kPASSWORD                    = "password"
    static let kGOOGLE_ID                   = "googlePlusId"
    static let kFACEBOOK_ID                 = "facebookId"
    static let kTWITTER_ID                  = "twitter_id"
    static let kAGE_RANGE_ID                = "age_range_id"
    static let kIDENTITY_ID                 = "identify_id"
    static let kINTEREST_ID                 = "interest_id"
    static let kVENUE_INTEREST_ID           = "venue_interest_id"
    static let kMY_IMPORTANT_ID             = "my_important_id"
    static let kID                          = "id"
    static let kDATA                        = "data"
    static let kIS_VALID                    = "isValid"
    static let kLOGIN_TYPE                  = "login_type"
    static let kSOCIAL_TYPE                 = "social_type"
    static let kZIP_CODE                    = "zipCode"
    static let kUSER_ID                     = "userId"
    static let kERROR_CODE                  = "errorCode"
    static let kERROR_MSG                   = "errorMsg"
    static let kLATITUDE                    = "latitude"
    static let kLONGITUDE                   = "longitude"
    static let kDEVICE_TOKEN                = "deviceToken"
    static let kLANGUAGE                    = "language"
    static let kFULL_NAME                   = "fullName"
    static let kGENDRER                     = "gender"
    static let KPHONE                       = "phone"
    static let kADDRESS                     = "address"
    static let kUSER                        = "user"
    static let kSELECTED_OPTION             = "isSelected"
    static let kOLD_PASSWORD                = "oldPassword"
    static let kNEW_PASSWORD                = "newPassword"
    static let kIS_LIKE                     = "isLike"
    static let kLIKE_COUNT                  = "likeCount"
    static let kCOMMENT_COUNT               = "commentCount"
    static let kPHOTO                       = "photo"
    static let kVIDEO                       = "video"
    static let kUSER_IMG                    = "userImage"
    static let kGROUP_ID                    = "groupId"
    static let kGROUP_NAME                  = "groupName"
    static let kSEARCH                      = "search"
    static let kPAGE                        = "page"
    static let kTIME                        = "time"
    static let kQUESTION_ID                 = "questionId"
    static let kIS_PARTICIPATE              = "isParticipate"
    static let kPARTICIPATE                 = "participate"
    static let kPARTICIPATE_COUT            = "participateCount"
    static let kIS_ANSWER                   = "isAnswer"
    static let kIS_CURRECT                  = "isCorrect"
    static let kANSWER_COUT                 = "answerCount"
    static let kANSWER_ID                   = "answerId"
    static let kREGION                      = "region"
    static let kTITLE                        = "title"
    static let kMESSAGES                     = "messages"
    static let kBAGE                        = "bage"
    static let kNOTIFICATION                = "notification"
    static let kDESCRIPTION                 = "description"
    
    static let user                         = "user"
}

struct DateFormat {
    static let date     = "yyyy-MM-dd"
    static let dateTime = "yyyy-MM-dd HH:mm:ss"
}

struct NotificationNames {
    static let socketConnected = Notification.Name("socketConnected")
}

class OSConstant: NSObject {

}

