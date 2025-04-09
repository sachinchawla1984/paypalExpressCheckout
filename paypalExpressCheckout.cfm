<!--- Include Config file--->
<cfinclude template="paypalExpressCheckoutConfig.cfm">

<!---Set Values in Session scope to use after response from Paypal --->
<cfset session.donation_for = donation_for>
<cfset session.frequency = payment_Frequency>
<cfset session.dedicate_option = dedicate_option>
<cfset session.dedicated_name = dedicated_name>
<cfset session.payment_Amount = paymentAmount>


<!--- Create an object for Paypal CFC and initialize values with client_id, secret and environment to set the paypal URL--->
<cfset paypalObject = createObject("component", "cfc.paypal")>
<cfset paypalObject.init(
                            client_id=client_id,
                            client_secret=client_secret,
                            sandbox=sandbox
                        )>

<!---
If Payment is recurring then invoke CallRecurringPaymentProfile Method else CallShortcutExpressCheckout
 --->
<cfif len(payment_Frequency) AND (payment_Frequency eq 'Month' OR payment_Frequency eq 'Quarterly' OR payment_Frequency eq 'biannual')>
    <cfset shortcutExpChcktResponse = paypalObject.CallRecurringPaymentsProfile(
                                                                                paymentAmount = paymentAmount, 
                                                                                currencyCodeType = currencyCodeType, 
                                                                                paymentType = paymentType, 
                                                                                returnURL = returnURL, 
                                                                                cancelURL = cancelURL
                                                                                )>
<cfelse>
    <cfset shortcutExpChcktResponse = paypalObject.CallShortcutExpressCheckout(
                                                                                paymentAmount = paymentAmount, 
                                                                                currencyCodeType = currencyCodeType, 
                                                                                paymentType = paymentType, 
                                                                                returnURL = returnURL, 
                                                                                cancelURL = cancelURL
                                                                                )>
</cfif>

<!---If response is SUCCESS from paypal then redirects to review page else show error message --->
<cfif structKeyExists(shortcutExpChcktResponse, 'ACK') AND (shortcutExpChcktResponse.ACK eq 'SUCCESS' OR shortcutExpChcktResponse.ACK eq 'SUCCESSWITHWARNING')>
    <cfset session.token = URLDecode(shortcutExpChcktResponse.TOKEN)>
    <cfset paypalObject.RedirectToPayPal(token = URLDecode(shortcutExpChcktResponse.TOKEN))>
<cfelseif structKeyExists(shortcutExpChcktResponse, 'L_ERRORCODE0')>
    <!---Display a user friendly Error on the page using any of the following error information returned by PayPal--->
    <cfset ErrorCode = urldecode(shortcutExpChcktResponse["L_ERRORCODE0"])>
    <cfset ErrorShortMsg = urldecode(shortcutExpChcktResponse["L_SHORTMESSAGE0"])>
    <cfset ErrorLongMsg = urldecode(shortcutExpChcktResponse["L_LONGMESSAGE0"])>
    <cfset ErrorSeverityCode = urldecode(shortcutExpChcktResponse["L_SEVERITYCODE0"])>

    SetExpressCheckout API call failed.
    Detailed Error Message: #ErrorLongMsg#
    Short Error Message: #ErrorShortMsg#
    Error Code: #ErrorCode#
    Error Severity Code: #ErrorSeverityCode#
<cfelse>
    SetExpressCheckout API call failed.
    Handshake Failure.
</cfif>