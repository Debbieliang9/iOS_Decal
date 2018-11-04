//
//  WSConfig.swift
//  MealSavvy
//

import Foundation

class SSConfig {
    
    static let serverAddress = "https://dev.toolowapp.com"
    
#if DEBUG
    static let port = 5005
#else
    static let port = 5005
#endif
    
    enum URLs {
        static let socket = "\(serverAddress):\(port)"
    }

    enum Keys {
        static let data    = "data"
        static let success = "success"
    }

    enum EventNames {
        static let checkEmailPhone      = "auth:check_email_phone"
        static let signup               = "auth:signup"
        static let signin               = "auth:signin"
        static let getUserInfo          = "user:info"
        static let updateUserInfo       = "user:update_profile"        
        static let searchFavorites      = "common:search_base_service"
        static let getCuisines          = "cuisines:get_all"
        static let searchCuisines       = "cuisines:search"
        static let supplierDetail       = "supplier:detail"
        static let getRestaurants       = "restaurants:get_all"
        static let getFavoites          = "favorite:get_all"
        static let logout               = "auth:logout"
        static let getCuisinesSub       = "cuisine:get_sub"
        static let forgotPassword       =  "auth:forgot_password"
        static let getProfileByEmail    =  "user:get_profile_by_email"
        static let getTimeSlot          = "service:time_slot"
        static let getPaymentHistory   = "user:get_payment_history"
        static let cancelOrder          = "service:booking:accepted"
        static let bookingStatus        = "service:booking:status"
        static let serviceBooking       = "service:booking"        
        static let serviceSubscriptionRedeem = "service:subscription_redeem"
        static let subscriptionMealPlan = "service:subscription_meal_plan"
        
        static let getHelp              = "user:help" 
    }
    
    enum Messages {
        static let invalidData = "Invalid Data"
        static let unkownError = "Unknown Error"
    }
}

