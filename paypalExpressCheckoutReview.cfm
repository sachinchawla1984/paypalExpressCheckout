<!--- Include Config file--->
<cfinclude template="paypalExpressCheckoutConfig.cfm">


<!---On successful response from Paypal we get a token in the URL.
    This token is further used to fetch user profile details like Email, Firstname, lastName etc.
    If payment is recurring then we further make a call to CreateRecurringPaymentsProfile method
    else ConfirmPayment
 --->
<cfif structKeyExists(URL,'token') AND len(url.token)>
    <cfset paypalObject = createObject("component", "cfc.paypal")>
    <cfset paypalObject.init(
                                client_id=client_id,
                                client_secret=client_secret,
                                sandbox=sandbox
                            )>    

    <!--- get payment profile detail --->
    <cfset profileDetailReponse = paypalObject.GetProfileDetails(token = url.token)>
    
    <cfif profileDetailReponse['ACK'] eq "SUCCESS" OR profileDetailReponse['ACK'] eq "SUCESSWITHWARNING">      
        <cfset session.payerId = URLDecode(profileDetailReponse["PAYERID"])>
        <cfif structKeyExists(profileDetailReponse, 'EMAIL')>
            <cfset email = URLDecode(profileDetailReponse["EMAIL"])>
            <cfset session.paypal_email = email>
        </cfif>
        
        <cfset payerId = URLDecode(profileDetailReponse["PAYERID"])>
        <cfset payerStatus = URLDecode(profileDetailReponse["PAYERSTATUS"])> 
        <cfif structKeyExists(profileDetailReponse, 'SALUTATION')>
            <cfset salutation = URLDecode(profileDetailReponse["SALUTATION"])> 
        </cfif>
        <cfset firstName = URLDecode(profileDetailReponse["FIRSTNAME"])> 
        <cfset session.paypal_fname = firstName>
        <cfif structKeyExists(profileDetailReponse, 'MIDDLENAME')>
            <cfset middleName = URLDecode(profileDetailReponse["MIDDLENAME"])> 
        </cfif>
        <cfset lastName = URLDecode(profileDetailReponse["LASTNAME"])>
        <cfset session.paypal_lname = lastName>
        <cfif structKeyExists(profileDetailReponse, 'SUFFIX')>
            <cfset suffix = URLDecode(profileDetailReponse["SUFFIX"])>
        </cfif>
        <cfset cntryCode = URLDecode(profileDetailReponse["COUNTRYCODE"])>
        <cfif structKeyExists(profileDetailReponse, 'BUSINESS')>
            <cfset business = URLDecode(profileDetailReponse["BUSINESS"])>
        </cfif>
        <cfset shipToName = URLDecode(profileDetailReponse["SHIPTONAME"])>
        <cfset shipToStreet = URLDecode(profileDetailReponse["SHIPTOSTREET"])>
        <cfif structKeyExists(profileDetailReponse, 'SHIPTOSTREET2')>
            <cfset shipToStreet2 = URLDecode(profileDetailReponse["SHIPTOSTREET2"])>
        </cfif>
        <cfset shipToCity = URLDecode(profileDetailReponse["SHIPTOCITY"])>
        <cfset shipToState = URLDecode(profileDetailReponse["SHIPTOSTATE"])>
        <cfset shipToCntryCode = URLDecode(profileDetailReponse["SHIPTOCOUNTRYCODE"])>
        <cfset shipToZip = URLDecode(profileDetailReponse["SHIPTOZIP"])> 
        <cfset addressStatus = URLDecode(profileDetailReponse["ADDRESSSTATUS"])>
        <cfif structKeyExists(profileDetailReponse, 'INVNUM')>
            <cfset invoiceNumber = URLDecode(profileDetailReponse["INVNUM"])>
        </cfif>
        <cfif structKeyExists(profileDetailReponse, 'PHONENUM')>
            <cfset phonNumber = URLDecode(profileDetailReponse["PHONENUM"])>
        </cfif>  
        
        <cfset finalPaymentAmount =  session.payment_Amount>

        <cfif session.frequency eq 'Month' OR session.frequency eq "Quarterly" OR session.frequency eq "biannual">
            <!--- reccuring payment --->
            <cfset paymentResponse = paypalObject.CreateRecurringPaymentsProfile(finalAmount = finalPaymentAmount)>
        <cfelse>
            <!--- one time payment --->
            <cfset paymentResponse = paypalObject.ConfirmPayment(finalAmount = finalPaymentAmount)>
        </cfif>
        
        <cfif structKeyExists(paymentResponse, 'ACK') AND (paymentResponse['ACK'] eq "SUCCESS" OR paymentResponse['ACK'] eq "SUCESSWITHWARNING")>
            <cfif structKeyExists(paymentResponse,"PAYMENTINFO_0_PAYMENTSTATUS")>
                <cfset paymentStatus = paymentResponse["PAYMENTINFO_0_PAYMENTSTATUS"]>
            </cfif>
            <cfif structKeyExists(paymentResponse,"PAYMENTINFO_0_TRANSACTIONID")>
                <cfset paymentTransactionId = paymentResponse["PAYMENTINFO_0_TRANSACTIONID"]>
            </cfif>
            <cfif structKeyExists(paymentResponse,"PAYMENTINFO_0_PENDINGREASON")>
                <cfset paymentPendingReason = paymentResponse["PAYMENTINFO_0_PENDINGREASON"]>
            </cfif>

            <cfset paypal_email = session.paypal_email>
            <cfset paypal_fname = session.paypal_fname>
            <cfset paypal_lname = session.paypal_lname>                
            <cfset payment_amount = session.payment_Amount>                
            <cfset payment_Frequency = session.frequency>
            <cfset payment_type = "Paypal">
            <cfset dedicate_option = session.dedicate_option>
            <cfset dedicated_name = session.dedicated_name>
            <cfset donation_for = session.donation_for>

            <cfif payment_Frequency eq "Month">
                <cfset Payment_Frequency = "Monthly">
            <cfelseif payment_Frequency eq "Quarterly">
                <cfset payment_Frequency = "Quarterly">
            <cfelseif payment_Frequency eq "biannual">
                <cfset payment_Frequency = "Bi-annual">
            <cfelse>
                <cfset payment_Frequency = "One Time">
            </cfif>

            Payment Done Successfully!!!
            
            <cflocation url="thanks.cfm?ac=success" addtoken="no">
            
        <cfelse>
            <!--- locate to error page error.cfm 
            <cflocation url="error.cfm?ac=error" addtoken="no">
            --->
        </cfif>
    <cfelse>
        <!---Display a user friendly Error on the page using any of the following error information returned by PayPal--->
        <cfset ErrorCode = urldecode(profileDetailReponse["L_ERRORCODE0"])>
        <cfset ErrorShortMsg = urldecode(profileDetailReponse["L_SHORTMESSAGE0"])>
        <cfset ErrorLongMsg = urldecode(profileDetailReponse["L_LONGMESSAGE0"])>
        <cfset ErrorSeverityCode = urldecode(profileDetailReponse["L_SEVERITYCODE0"])>

        GetExpressCheckoutDetails API call failed.
        Detailed Error Message: #ErrorLongMsg#
        Short Error Message: #ErrorShortMsg#
        Error Code: #ErrorCode#
        Error Severity Code: #ErrorSeverityCode#
    </cfif>
<cfelse>

    <!---
    <cflocation url="donate.cfm" addtoken="no">
    --->
</cfif>
