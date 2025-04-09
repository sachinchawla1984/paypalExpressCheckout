<!--- 
Filename: paypalExpressCheckoutConfig.cfm
Description: This is the config file and needs to be included to access all settings like:
                i) Default value of form fields
                ii) BaseURL, Paypal Return URL and Paypal Cancel URL
                iii) Sandbox and Production client_id and client_secret that needs to be send via an API call
--->


<!---Check if URL is http or https --->
<cfif cgi.HTTPS eq 'On'>
    <cfset protocol = 'https://'>
<cfelse>
    <cfset protocol = 'http://'>
</cfif>


<!---Set Path for current directory --->
<cfset thisFolder = listLast(expandPath('.'),'\')>

<!---Set default value for the Payment form fields --->
<cfparam name="payment_Frequency" default="OneTime">
<cfparam name="paymentAmount" default="20.00">
<cfparam name="currencyCodeType" default="USD">
<cfparam name="paymentType" default="Sale">
<cfparam name="donation_for" default="">
<cfparam name="dedicate_option" default="">
<cfparam name="dedicated_name" default="">

<cfif isDefined('form.frequency')>
    <cfset payment_Frequency = FORM.frequency>
    <cfset paymentAmount = isDefined('form.other_amount') AND FORM.other_amount NEQ "" ? FORM.other_amount : FORM.payment_amount>
    <cfdump  var="#paymentAmount#">
</cfif>

<!---Base URL used for form redirection --->
<cfparam name="baseUrl" default = "#protocol##cgi.HTTP_HOST#">

<!---Return and Cancel URL needs to be send to Paypal --->
<cfparam name="returnURL" default="#baseUrl#/#thisFolder#/paypalExpressCheckoutReview.cfm">
<cfparam name="cancelURL" default="#baseUrl#/#thisFolder#/donate.cfm">


<!--- Set value for Environment Sandbox = true OR Sandbox = false for Production--->
<cfset sandbox = true>


<!---Set Client_id and Client_Secret for Sandbox and Production Environment --->
<cfif sandbox>
    <cfset client_id='AXaIb9088cfgPKOed_N7rrH3z4GBkl_kET3Ai9Qm'>
    <cfset client_secret='EAqeX8Zh0EJxYV71YEMIIJvdsr4oZ5831vWOhtGn'>
<cfelse>
    <cfset client_id='AXaIb9088cfgPKOed_N7rrH3z4GBkl_kET3Ai9Qm'>
    <cfset client_secret='EAqeX8Zh0EJxYV71YEMIIJvdsr4oZ5831vWOhtGn'>
</cfif>
