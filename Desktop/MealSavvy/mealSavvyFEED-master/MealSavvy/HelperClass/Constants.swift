//
//  Constants.swift
//  Faloos
//
//  Created by Andon

import UIKit

//Rest API
let CRYPTO_URL = "https://api.cryptonator.com/api"
let APP_URL = "https://itunes.apple.com/app/1276608207"
let ADMIN_EMAIL = ["as259532@gmail.com"]

let MSG_TIMESTAMP_FMT = "dd MMM yyyy @ HH:mm"
let APPLINK_URL = "https://fb.me/369443586826097"
let PREVIEWIMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/faloos-dev.appspot.com/o/appicon%2FiTunesArtwork%402x.png?alt=media&token=5dbf153e-439e-4109-8c46-45025f01a528"

let HEADER_HEIGHT = 25
let CELL_HEIGHT:CGFloat = 78
let FOOTER_HEIGHT = 10
let MAX_AVATAR_SIZE = 252

let NUMBER_CELL = 4

let VISA = "visa"
let MASTERCARD = "mastercard"
let AMERICAN_EXPRESS = "american_express"
let DINERS_CLUB = "diners_club"
let DISCOVER = "discover"
let JCB = "jcb"

let PAYMENT_TYPE_PERSONAL = "personal"
let PAYMENT_TYPE_BUSINESS = "business"
let PAYMENT_TYPE_ORTHER = "other"
let DATE_FORMAT_STRING = "yyyy-MM-dd"

let PaymentProcessorTypeNet = "Authorize.net"


let MIN_CASHOUT_AMOUNT:CGFloat = 50.0
let MIN_DEPOSIT_AMOUNT:CGFloat = 20.0

let CARD_CELL_HEIGHT:CGFloat = 46.0
let DISTANCE_LIMIT = 100000.0

let kServerFee:Double = 4.0

let kDatabaseProcessTime = 3

let kMaxPhoneLength = 11
let kMaxBTCLength = 6 //the length of btc price string
let kJPEGImageQuality:CGFloat = 0.1 // between 0..1

let kImageResolution:CGFloat = 1440.0

let kMaxConcurrentImageDownloads = 10 // the count of images donloading at the same time
let kUsersKey = "users"
let kStocksKey = "stocks"
let kOrdersKey = "orders"
let kFeedbacksKey = "feedbacks"

let NOTIFICATION_UPDATE_BALANCE:String = "NOTIFICATION_UPDATE_BALANCE"

let kFilesKey = "files"

let OFFER_PREFIX = "#!*#"

let kServicesKey = "services"
let kQuotesKey = "quotes"
let kCategoriesKey = "categories"
let kContractsKey = "contracts"
let kFavoritesKey = "favorites"
let kVerifyKey = "verified"
let kOffersKey = "offers"
let kMessagesKey = "chats"
let kReviewsKey = "reviews"
let kReportItemsKey = "reportItems"

let kDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
let kDayFormat = "dd MMM yyyy"

enum STATUS_CODE {
    case success
    case connection_failed
    case invalid_request
    case blank_value
    case update_failed
}

enum MessageType {
    case photo
    case text
    case offer
    case location
}

enum MessageOwner {
    case sender
    case receiver
}

enum USER_TYPE: Int {
    case agent = 0
    case photographer = 1
    case editor = 2
    case admin = 3
}

enum MEDIA_TYPE: Int {
    case photo = 0
    case pano = 1
    case video = 2
    case other = 3
}

enum CONTRACT_TYPE: Int {
    case fixed = 0
    case hourly = 1
}

enum QUOTE_STATUS: Int {
    case sent = 0
    case replied = 1
}

enum CONTRACT_STATUS: Int {
    case submitted = 0
    case active = 1
    case reviewing = 2
    case completed = 3
}

enum PROPERTY_TYPE: Int {
    case commerical = 0
    case high_resolution = 1
    case revision = 2
    case black_white_edition = 3
    case add_watermark = 4
}

enum FRIEND_STATUS: Int {
    case none = 0
    case selected = 1
    case sent = 2
    case incoming = 3
    case accepted = 4
    case rejected = 5
    case fsFriend = 6
    case fbFriend = 7
    case fsUser = 8
    case transaction = 9
}

struct FSColor {
    static let redColor = UIColor.init(red: 255/256.0, green: 2/256.0, blue: 0, alpha: 1)
    static let pinkColor = UIColor(red: 240.0/255.0, green: 50.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    static let borderColor = UIColor(red: 235.0/255.0, green: 240.0/255.0, blue: 235.0/255.0, alpha: 0.5)
    static let buttonColor = UIColor(red: 1.0/255.0, green: 205.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    static let placeHolderColor = UIColor(red: 11.0/255.0, green: 11.0/255.0, blue: 11.0/255.0, alpha: 0.47)

    static let greenColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    static let grayColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
    static let textColorBlackAlpha = UIColor(red: 0, green: 0, blue: 0, alpha: 0.54)
    static let creditPriceStart = 3.99
    
    static let grayBackgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
}

struct FSMessage {
    
    static let USERNAME_EXIST = "That username has already taken by another user. Please use another username."
    static let NO_USER = "No user exists in REmedium."
    static let USER_REMOVED = "Your account no longer exists. Please contact to Admin or create new one."    
    static let REQUEST_OFFER_PRICE = "Please input offer price."
    static let USER_LOGOUT = "User logged out"
    static let PAYMENT_SENT = "Payment sent successfully."
    
    static let ESCROW_EXPLAIN = "FUNDS ARE NOW IN ESCROW AND WILL BE RELEASED UPON DELIVERY TO BUYER"
    static let COMPLETE_EXPLAIN = "FUNDS IN TRANSIT TO BUYER"
    
    static let CUSTOM_OFFER = "Send Custom Offer"
    
    static let ORDER_NOT_STARTED = "Thank you for order.\n The order not started"
    
    static let AGENT_WAITING = "Agent is waiting for your approval."
    
    static let SAVE_LOCATION = "Would you save this address?"
    
    static let OFFER_SENT = "Your offer is successfully sent."
    static let ORDER_SENT = "Your order is successfully sent."

    static let QUOTE_SENT = "Requested quote successfully."
    
    static let CONTRACT_COMPLETE = "Congrats for completing the contract!"
    
    static let SEARCH_PHOTOGRAPHER = " Photographers are available at"
    static let NO_AVAILABLE = "Sorry, no photographers available at"
    
    static let ADD_FILE = "Please add file."
    
    static let SELECT_USER_TYPE = "Please select the user type."
    
    static let SELECT_PHOTOGRAPHER = "Please select the photographer."
    
    static let SHARE_FACEBOOK_SUCCESS = "Successfully Shared on Facebook."
    static let SHARE_LINKEDIN_SUCCESS = "Successfully Shared on LinkedIN."
    static let SHARE_TWITTER_SUCCESS = "Successfully Shared on Twitter."

    static let ADD_PRODUCT_IMAGE = "Please add your product images. It’ll be shown to consumers."
    static let REQUEST_PRODUCT_IMAGE = "Please add your item images."
    static let PRODUCT_PUBLISH_PROCESS = "We are publishing your item..."
    static let SERVICE_DELETE = "Are you sure you want to delete this service?"
    static let PRODUCT_NOT_NEGOTIABLE = "This product is not negotiable."
    
    static let OFFER_SENT_CONFIRM = "Offer is sent. Please check your message."
    
    static let IMAGE_DELETE = "Delete the image"
    static let NETWORK_ERROR = "Please check your network connection."

    static let SEND_REQUEST = "Are you sure you want to send this Request?"
    static let SEND_PAYMENT = "Are you sure you want to send this Payment?"
    static let INPUT_PHONE = "Please enter phone number."
    static let VERIFY_PHONE = "Would you like to verify your phone number?"

    static let CONFIRM_PAYMENT = "Are you sure you want to accept this Payment?"
    static let CONFIRM_REJECT = "Are you sure you want to reject this Payment?"
    
    static let CONFIRM_RESTART = "This app would need to restart in order for this change to occur."
    static let CONFIRM_CANCEL = "Are you sure you want to cancel?"

    static let INPUT_FULLNAME = "Please enter full name."
    static let INPUT_TITLE = "Please enter title."
    static let INPUT_DESCRIPTION = "Please enter description."
    static let INPUT_BUDGET = "Please input budget you want."
    
    static let ALREADY_REPLY_QUOTE = "You have already replied this quote."
    
    static let INPUT_SERVICE_TITLE = "Please enter title of service."
    static let INPUT_SERVICE_DESCRIPTION = "Please enter description of service."
    static let INPUT_PRICE = "Please enter price of service."
    
    static let REQUIRE_DEBIT = "Debit card is required to sell items via REmedium."
    
    static let INPUT_CARDNUM = "Please enter card number."
    static let INPUT_EXPMONTH = "Please enter expired month."
    static let INPUT_EXPYEAR = "Please enter expired year."
    static let INPUT_CVV = "Please enter cvv."
    
    static let ADD_PAYMENT_CARD = "Linked payment card successfully."
    static let ASK_CONNECT_CARD = "Please link your payment card to hire."

    static let INPUT_USERNAME = "Please enter user name."
    static let INPUT_ADDRESS = "Please enter address"
    static let INPUT_EMAIL = "Email address is not valid."
    static let EMAIL_INVALID = "Email address is not valid."
    static let VERIFY_EMAIL_SENT = "Verification Email was sent!"
    static let PASSWORD_RESET_EMAIL = "Password Reset Email was sent!"
    static let PASSWORD_EMPTY = "Please input the password."
    static let PASSWORD_CONFIRM = "Confirm password is not same."    

    static let CARD_INVALID = "Please enter the correct card information"
    
    static let ACCEPT_OFFER = "Congratulations!\n Your contract is started."

    static let FRIEND_ACCEPT = "Are you sure you want to accept this user as a friend?"
    static let FRIEND_REJECT = "Are you sure you want to reject this user as a friend?"
    static let FRIEND_CANCEL = "Are you sure you want to cancel this request?"
    static let FRIEND_ADD = "Are you sure you want to add this user as a friend?"
    static let FRIEND_FACEBOOK = " of your Facebook friends are already using Faloos!"
    static let FACEBOOK_INVITE = "Faloos is better with friends! Invite your Facebook friends here."

    static let UPLOADING_AVATAR = "Please wait. On changing profile image now."
    static let CAMERA_NOT_WORK = "Camera is not available."
    static let PHOTOLIBRARY_NOT_WORK = "Photo library is not available."
    
    static let forgotPasswordSuccessTitle = "Password sent"
    static let forgotPasswordSuccessMessage = "A new password is emailed to you. Please check spam/junk folder if you can’t see email in your inbox."
    static let forgotPasswordSuccessButtonTitle = "GOT IT"
}
