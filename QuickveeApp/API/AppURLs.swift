//
//  AppURLs.swift
//
//
//  Created by Jamaluddin Syed on 7/20/23.
//

import Foundation

struct AppURLs {
    // live
    static let base_url = "https://api-ci.quickvee.us/"
    
    //test
   // static let base_url = "https://qa-api-ci.quickvee.us/"

    
    static let ORDERS_LIST = "\(base_url)orders/order_list"
    static let ORDER_DETAILS = "\(base_url)orders/order_details"
    static let ORDERS_STATUS = "\(base_url)orders/change_order_status"
    static let NEW_ORDERS_COUNT = "\(base_url)orders/new_order_count"
    
    static let ORDER_ITEM_REFUND = "\(base_url)orders/save_line_item_refund"
    static let FILTER_CATEGORY = "\(base_url)Categoryapi/category_list"
    static let ITEMWISE_SALE = "\(base_url)Report_api/itemwise_sale"
    static let ORDERTYPE_SALE = "\(base_url)Report_api/order_type"
    static let SALES_OVERVIEW = "\(base_url)Report_api/new_sale_overview"
    static let TAXES_SALE = "\(base_url)Report_api/taxes"
    static let HOME_ALL_DATA = "\(base_url)Dashboard/allData"
    static let ALL_STORES = "\(base_url)app/all_stores"
    
    static let LOGIN = "\(base_url)App/new_login_via_storename"
    static let FORGOT_PASSWORD = "\(base_url)app/forgot_password"
    
    static let REGISTER = "\(base_url)app/register_merchant"
    
    static let UPDATE_BUSINESS_HOURS = "\(base_url)Settingapi/update_business_hours"
    static let GET_BUSINESS_HOURS = "\(base_url)Settingapi/get_business_hours"
    
    static let EDIT_COUPON = "\(base_url)Couponapi_live/edit_coupon"
    static let ADD_COUPON = "\(base_url)Couponapi_live/add_coupon"
    static let GET_COUPON_DETAILS = "\(base_url)Couponapi_live/get_coupon_details"
    static let COUPON_SHOW_ONLINE = "\(base_url)Couponapi_live/show_online"
    static let COUPON_DELETE = "\(base_url)Couponapi_live/delete_coupon"
    
    static let ADD_EDIT_VENDOR = "\(base_url)app/add_edit_vendor"
    static let VENDOR_PAYMENT_LIST = "\(base_url)app/vendor_payment_list"
    static let VENDOR_BY_ID = "\(base_url)app/get_vendorById"
    static let VENDOR_PAYMENT_DETAILS = "\(base_url)app/vendor_payment_report"
    
    static let CHANGE_PASSWORD = "\(base_url)profile/change_password"
    
    static let TAX_LIST = "\(base_url)Settingapi/tax_list"
    static let ADD_TAX = "\(base_url)Settingapi/addnewtax"
    static let DELETE_TAX = "\(base_url)Settingapi/deletetax"
    
    static let UPDATE_STORE_ALERTS = "\(base_url)Settingapi/update_store_alerts"
    
    static let PROFILE = "\(base_url)profile"
    static let UPDATE_PROFILE = "\(base_url)profile/update_profile"
    static let LOGOUT = "\(base_url)App/logout"
    
    static let STORE_DETAILS = "\(base_url)Settingapi/store_details"
    static let STORE_LOGO = "\(base_url)upload/"
    static let STORE_BANNER = "\(base_url)upload/banner/"
    
    static let UPDATE_STORE_OPTIONS = "\(base_url)Settingapi/update_store_option"
    static let UPDATE_STORE_SETUP = "\(base_url)Settingapi/update_store_setup"
    
    // static let INVENTORY_CATEGORY_LIST = "https://qa-elasticsearch.quickvee.us/Categoryapi/category_list"
    static let INVENTORY_CATEGORY_LIST = "\(base_url)Categoryapi/category_list"
    static let INVENTORY_ADD_CATEGORY = "\(base_url)Categoryapi/add_category"
    static let INVENTORY_EDIT_CATEGORY = "\(base_url)Categoryapi/"
    static let INVENTORY_DELETE_CATEGORY = "\(base_url)Categoryapi/delete_category"
    static let INVENTORY_CATEGORY_BY_ID = "\(base_url)Categoryapi/get_categoryById"
    
   static let INVENTORY_PRODUCT_LIST = "\(base_url)Productapi/new_product_list"
   //  static let INVENTORY_PRODUCT_LIST = "https://qa-elasticsearch.quickvee.us/Productapi/new_product_list"
    static let INVENTORY_PRODUCT_ADD = "\(base_url)Productapi/add_product"
    static let INVENTORY_PRODUCT_DUPLICATE = "\(base_url)Productapi/duplicate_product"
    static let INVENTORY_PRODUCT_EDIT = "\(base_url)Productapi/edit_produt"
   // static let INVENTORY_PRODUCT_BY_ID = "https://qa-elasticsearch.quickvee.us/Productapi/get_productdata_ById"
    static let INVENTORY_PRODUCT_BY_ID = "\(base_url)Productapi/get_productdata_ById"
    static let INVENTORY_UPDATE_STATUS = "\(base_url)Productapi/product_show_status_update"
    static let INVENTORY_PRODUCT_DELETE = "\(base_url)Productapi/delete_product"
    
    static let INVENTORY_ATTRIBUTE_LIST = "\(base_url)Varientsapi/varients_list"
    static let INVENTORY_ADD_ATTRIBUTE = "\(base_url)Varientsapi/add_varient"
    
    //static let INVENTORY_VARIANT_LIST = "https://qa-elasticsearch.quickvee.us/Productapi/variant_list"
    static let INVENTORY_VARIANT_LIST = "\(base_url)Productapi/variant_list"
    static let INVENTORY_VARIANT_LIST_PAGINATION = "\(base_url)productapi/variant_list_pagination"
    static let INVENTORY_UPDATE_PRODUCT_VARIANT = "\(base_url)productapi/update_product_variant"
    static let INVENTORY_VARIANT_BY_ID = "\(base_url)productapi/get_variantdata_ById"
    static let INVENTORY_VARIANT_UPDATE = "\(base_url)productapi/update_product_variant"
    static let INVENTORY_SAVE_INSTANT_PO = "\(base_url)productapi/save_instant_po"
    
    static let INVENTORY_SETTINGS  = "\(base_url)Profile_setup/inventory_register_setting"
    static let INVENTORY_SYNC_DATA  = "\(base_url)App/sync_app"
    static let PASSCODE_LOGIN = "\(base_url)App/employee_list"
    static let INVENTORY_PASSCODE = "\(base_url)productapi/"
    
    static let SALES_HISTORY = "\(base_url)productapi/saleshistory"
    
    static let ADD_BULK_PRICING = "\(base_url)Productapi/add_bulk_pricing"
    static let GET_BULK_PRICING = "\(base_url)productapi/get_bulk_pricing_ById"
    static let DELETE_BULK_PRICING = "\(base_url)productapi/delete_bulk_pricing"
    static let UPDATE_BULK_PRICING = "\(base_url)productapi/edit_bulk_pricing"
    
    static let ADD_PURCHASE_QUANTITY = "\(base_url)Productapi/update_purchase_qty"
    
    static let FCM_TOKEN = "\(base_url)App/save_fcm_token/1"
    
    static let LOYALTY_LIST = "\(base_url)Loyalty_program_api/loyalty_program_list"
    static let UPDATE_LOYALTY_PROGRAM = "\(base_url)Loyalty_program_api/save_loyalty_program"
    
    static let BONUS_BY_ID = "\(base_url)Loyalty_program_api/bouns_point_promotions_list"
    static let BONUS_UPDATE = "\(base_url)Loyalty_program_api/add_bouns_point_promotions"
    static let DELETE_BONUS = "\(base_url)Loyalty_program_api/delete_loyalty_program"
    
    static let SET_REGISTER_SETTINGS = "\(base_url)Profile_setup/inventory_register_setting"
    static let UPDATE_REGISTER_SETTINGS = "\(base_url)Profile_setup/register_setting"
    
    static let UPDATE_SYSTEM_ACCESS = "\(base_url)Profile_setup/system_access"
    static let CHECK_END_SHIFT = "\(base_url)Shift_inout/check_eod"
    
    static let EMPLOYEE_LIST = "\(base_url)App/employee_list"
    static let EMPLOYEE_BY_ID = "\(base_url)App/getEmployeeByEmpid"
    static let ADD_EMPLOYEE = "\(base_url)App/addEdit_employee"
    static let DELETE_EMPLOYEE = "\(base_url)App/delete_employee"
    
    static let SETUP_INVENTORY = "\(base_url)Profile_setup/inventory_register_setting"
    static let UPDATE_SETUP_INVENTORY = "\(base_url)Profile_setup/inventory_setting"
    
    static let ADD_BRANDS_TAGS = "\(base_url)Productapi/add_brand_tag"
    static let UPDATE_BRANDS_TAGS = "\(base_url)Productapi/update_brand_tag"
    static let GET_BRANDS_TAGS = "\(base_url)Productapi/list_brand_tag"
    static let DELETE_BRANDS_TAGS = "\(base_url)Productapi/delete_brand_tag"
    
    static let MIX_N_MATCH_PRICING_LIST = "\(base_url)Mix_match_pricing_api/mix_match_pricing_list"
    static let ADD_MIX_N_MATCH_PRICING = "\(base_url)Mix_match_pricing_api/add_mix_match_pricing"
    static let DELETE_MIX_N_MATCH_PRICING = "\(base_url)Mix_match_pricing_api/delete_mix_match_pricing"
    static let ENABLE_MIX_N_MATCH_PRICING = "\(base_url)Mix_match_pricing_api/enable_mix_match_pricing"
    
    
    static let GIFT_CARD_LIST = "\(base_url)Gift_Ebt_api/get_giftcard"
    static let GIFT_CARD_ADD_REMOVE = "\(base_url)Gift_Ebt_api/adjust_giftcard"
    
    static let CUSTOMERS_LIST = "\(base_url)Customer_merchant_api/new_customer_list"
    static let CUSTOMERS_PAID_REFUND_MERCHANT_LIST = "\(base_url)Customer_merchant_api/new_mrtwise_customer_list_api"
    static let FIND_CUSTOMER = "\(base_url)App/find_customer"
    
    static let DELETE_CUSTOMERS = "\(base_url)Customer_merchant_api/delete_customer"
    static let DISABLE_CUSTOMERS = "\(base_url)Customer_merchant_api/disable_customer"
    static let ADD_CUSTOMERS = "\(base_url)App/save_customer_details"
    static let CUSTOMERS_ADD_REMOVE_LOYALTY_POINTS = "\(base_url)Loyalty_program_api/loyality_point_transaction"
    static let LOYALTY_PROGRAM_LIST = "\(base_url)Loyalty_program_api/loyalty_program_list"
    
    static let STOCKTAKE_LIST = "\(base_url)Stocktake_api/stocktake_list"
    static let STOCK_BY_ID = "\(base_url)Stocktake_api/get_stocktake_details_by_id"
    static let SAVE_STOCK = "\(base_url)Stocktake_api/create_stocktake"
    static let STOCK_DELETE = "\(base_url)Stocktake_api/delete_stocktake_item"
    static let STOCK_EMAIL = "\(base_url)Purchase_orders_api/email_po"
    static let VOID_STOCK = "\(base_url)Stocktake_api/void_stocktake"
    
    static let BOGO_LIST = "\(base_url)Bogoapi/bogo_list"
    static let ADD_BOGO = "\(base_url)Bogoapi/add_bogo"
    static let ENABLE_BOGO = "\(base_url)Bogoapi/bogo_status"
    static let DELETE_BOGO = "\(base_url)Bogoapi/delete_bogo"
    
    static let LOGURL = "https://www.quickvees.com/internet_log_ios.php"
}

