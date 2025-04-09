<cfcomponent output="false">
	
	<cfset variables.username = "">
	<cfset variables.password = "">
	<cfset variables.server = "">
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="client_id" required="false" type="string">
		<cfargument name="client_secret" required="false" type="string">
		<cfargument name="sandbox" required="false" type="boolean" default="false">
		
		<cfset variables.username = arguments.client_id>
		<cfset variables.password = arguments.client_secret>
		
		<cfif arguments.sandbox>
			<cfset variables.server = "https://api-3t.sandbox.paypal.com/nvp">
			<cfset variables.paypal_url = "https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=">
			<cfset variables.apiUserName = 'thereadingheart-facilitator_api1.gmail.com'>
			<cfset variables.apiPwd = '2L6F2BAJG9QRLDR8'>
			<cfset variables.apiSignature = 'AHinipQaaYju.vNP8AxyCHJsIMehAs6au3gc71I7iathY4O2J7wGGZ1a'>
		<cfelse>
			<cfset variables.server = "https://api-3t.paypal.com/nvp">
			<cfset variables.paypal_url = "https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=">
			<!--- Set API live credentials --->
			<cfset variables.apiUserName = 'thereadingheart_api1.gmail.com'>
			<cfset variables.apiPwd = 'GNMJCX6GKDRH7LVA'>
			<cfset variables.apiSignature = 'AFcWxV21C7fd0v3bYYYRCpSSRl31AXT8wNIgdm59DogkSqAURSooo9yW'>
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="capture" access="public" output="false">
		<cfargument name="card_type" required="true" type="string">
		<cfargument name="card_number" required="true" type="string">
		<cfargument name="card_exp_month" required="true" type="string">
		<cfargument name="card_exp_year" required="true" type="string">
		<cfargument name="card_firstname" required="true" type="string">
		<cfargument name="card_lastname" required="true" type="string">
		<cfargument name="amount" required="true" type="numeric">
		
		<cfargument name="currency" required="false" type="string" default="USD">
		<cfargument name="description" required="false" type="string" default="">
		
		<cfset data = { "intent" = "sale" }>
		<cfset data["payer"] = {
		    "payment_method"="credit_card",
		    "funding_instruments" = [
		      {
		        "credit_card" = {
		          "type"= arguments.card_type,
		          "number"= " " & arguments.card_number,
		          "expire_month"= " " & arguments.card_exp_month,
		          "expire_year"= " " & arguments.card_exp_year,
		          "first_name"= arguments.card_firstname,
		          "last_name"= arguments.card_lastname
		        }
		      }
		    ]
		}>
		<cfset data["transactions"] = [
		    {
		      "amount"={
		        "total"= (NumberFormat(arguments.amount, "9.99") & "|||"),
		        "currency"= arguments.currency
		      },
			"description" = arguments.description
		    }
		]>
		<cfset req = serializeJSON(data)>
  
		<!--- convert string total to numeric (an unelegant workaround for CF's poor JSON serialization )) --->
		<cfset req = Replace(req, 'total":"', 'total":')>
		<cfset req = Replace(req, '|||"', '')>
		<cfset req = serializeJSON(data)>
		 
		<!--- another workaround for ColdFusion serialize JSON bug that converts numeric strings to floats --->
		<cfset req = Replace(req, '" ', '"', "ALL")>
		
		<cfreturn makePaymentRequest(data = req)>
	</cffunction>
	<!--- private methods --->
	<cffunction name="getAuthToken" access="private" output="false">
		<cfhttp url="#variables.server#/v1/oauth2/token" method="post" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded">
			<cfhttpparam type="header" name="Accept-Language" value="en_US">
			<cfhttpparam type="formfield" name="grant_type" value="client_credentials">
		</cfhttp>
		
		<cfset response = deserializeJSON(cfhttp.FileContent)>
		
		<cfreturn response.access_token>
	</cffunction>
	<cffunction name="makePaymentRequest" access="private" output="false">
		<cfargument name="data" required="true" type="string">
		<cfset var accessToken = getAuthToken()>
		
		<cfhttp url="#variables.server#/v1/payments/payment" method="post" timeout="120">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="body" value="#req#">
		</cfhttp>
		
		<cfreturn cfhttp.FileContent>
	</cffunction>

	<!--- Billing type - one time setExpressCheckout --->
	<cffunction name="CallShortcutExpressCheckout" access="public" output="false">
		<cfargument name="paymentAmount" required="true" type="any">
		<cfargument name="currencyCodeType" required="true" type="string">
		<cfargument name="paymentType" required="true" type="string">
		<cfargument name="returnURL" required="true" type="string">
		<cfargument name="cancelURL" required="true" type="string">

		<cfset session.currencyCodeType = arguments.currencyCodeType>
		<cfset session.paymentType = arguments.paymentType>
		
		<cfhttp url="#variables.server#" method="post" result="result">
			<cfhttpparam type="FormField" name="METHOD" value="SetExpressCheckout">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_AMT" value="#arguments.paymentAmount#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_PAYMENTACTION" value="#arguments.paymentType#">
			<cfhttpparam type="FormField" name="RETURNURL" value="#arguments.returnURL#">
			<cfhttpparam type="FormField" name="CANCELURL" value="#arguments.cancelURL#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_CURRENCYCODE" value="#arguments.currencyCodeType#">
			<cfhttpparam type="FormField" name="VERSION" value="64">
			<cfhttpparam type="FormField" name="PWD" value="#variables.apiPwd#">
			<cfhttpparam type="FormField" name="USER" value="#variables.apiUserName#">
			<cfhttpparam type="FormField" name="SIGNATURE" value="#variables.apiSignature#">		
		</cfhttp>
		
		<cfset payPalResponseStruct = structNew()>
		<cfset payPalResponseStruct['ACK'] = 'FAIL'>
		
		<cfif result.statuscode eq '200' OR result.statuscode eq '200 OK'>			
			<cfloop list="#result.fileContent#" index="elem" delimiters="&">
				<cfset payPalResponseStruct[listFirst(elem,"=")] = listLast(elem,"=")>
			</cfloop>
		</cfif>
		
		<cfreturn payPalResponseStruct>
	</cffunction>

	<!--- redirects to paypal --->
	<cffunction name="RedirectToPayPal" access="public" output="false">
		<cfargument name="token" required="true" type="string">

		<cfset paypalURL = variables.paypal_url & arguments.token>
		<cflocation url="#paypalURL#" addToken="no">
	</cffunction>

	<!---Billing type - multiple setExpressCheckout --->
	<cffunction name="CallRecurringPaymentsProfile" access="public" output="false">
		<cfargument name="paymentAmount" required="true" type="any">
		<cfargument name="currencyCodeType" required="true" type="string">
		<cfargument name="paymentType" required="true" type="string">
		<cfargument name="returnURL" required="true" type="string">
		<cfargument name="cancelURL" required="true" type="string">

		<cfset session.currencyCodeType = arguments.currencyCodeType>
		<cfset session.paymentType = arguments.paymentType>
		
		<cfhttp url="#variables.server#" method="post" result="result">
			<cfhttpparam type="FormField" name="METHOD" value="SetExpressCheckout">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_AMT" value="#arguments.paymentAmount#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_PAYMENTACTION" value="#arguments.paymentType#">
			<cfhttpparam type="FormField" name="L_BILLINGTYPE0" value="RecurringPayments">
			<cfhttpparam type="FormField" name="L_BILLINGAGREEMENTDESCRIPTION0" value="ReadingHeartDonation">
			<cfhttpparam type="FormField" name="RETURNURL" value="#arguments.returnURL#">
			<cfhttpparam type="FormField" name="CANCELURL" value="#arguments.cancelURL#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_CURRENCYCODE" value="#arguments.currencyCodeType#">
			<cfhttpparam type="FormField" name="VERSION" value="64">
			<cfhttpparam type="FormField" name="PWD" value="#variables.apiPwd#">
			<cfhttpparam type="FormField" name="USER" value="#variables.apiUserName#">
			<cfhttpparam type="FormField" name="SIGNATURE" value="#variables.apiSignature#">		
		</cfhttp>
		
		<cfset payPalResponseStruct = structNew()>
		<cfset payPalResponseStruct['ACK'] = 'FAIL'>
		
		<cfif result.statuscode eq '200' OR result.statuscode eq '200 OK'>			
			<cfloop list="#result.fileContent#" index="elem" delimiters="&">
				<cfset payPalResponseStruct[listFirst(elem,"=")] = listLast(elem,"=")>
			</cfloop>
		</cfif>

		<cfreturn payPalResponseStruct>
	</cffunction>

	<!---get prfile details after express checkout --->
	<cffunction name="GetProfileDetails" access="public">
		<cfargument name="token" required="true" type="any">

		<cfhttp url="#variables.server#" method="post" result="result">
			<cfhttpparam type="FormField" name="METHOD" value="GetExpressCheckoutDetails">
			<cfhttpparam type="FormField" name="TOKEN" value="#arguments.token#">
			<cfhttpparam type="FormField" name="VERSION" value="64">
			<cfhttpparam type="FormField" name="PWD" value="#variables.apiPwd#">
			<cfhttpparam type="FormField" name="USER" value="#variables.apiUserName#">
			<cfhttpparam type="FormField" name="SIGNATURE" value="#variables.apiSignature#">		
		</cfhttp>
		
		<cfset profileDetailsResponseStruct = structNew()>
		<cfset profileDetailsResponseStruct['ACK'] = 'FAIL'>
		
		<cfif result.statuscode eq '200' OR result.statuscode eq '200 OK'>			
			<cfloop list="#result.fileContent#" index="elem" delimiters="&">
				<cfset profileDetailsResponseStruct[listFirst(elem,"=")] = listLast(elem,"=")>
			</cfloop>
		</cfif>

		<cfreturn profileDetailsResponseStruct>
	</cffunction>

	<!---Confirm payment one time--->
	<cffunction name="ConfirmPayment" access="public">
		<cfargument name="finalAmount" required="true" type="any">

		<cfhttp url="#variables.server#" method="post" result="result">
			<cfhttpparam type="FormField" name="METHOD" value="DoExpressCheckoutPayment">
			<cfhttpparam type="FormField" name="TOKEN" value="#session.token#">
			<cfhttpparam type="FormField" name="PAYERID" value="#session.payerId#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_PAYMENTACTION" value="#session.paymentType#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_AMT" value="#arguments.finalAmount#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_CURRENCYCODE" value="#session.currencyCodeType#">		
			<cfhttpparam type="FormField" name="IPADDRESS" value="#cgi.SERVER_NAME#">			
			<cfhttpparam type="FormField" name="VERSION" value="64">
			<cfhttpparam type="FormField" name="PWD" value="#variables.apiPwd#">
			<cfhttpparam type="FormField" name="USER" value="#variables.apiUserName#">
			<cfhttpparam type="FormField" name="SIGNATURE" value="#variables.apiSignature#">		
		</cfhttp>
		
		<cfset confirmPaymentResponseStruct = structNew()>
		<cfset confirmPaymentResponseStruct['ACK'] = 'FAIL'>
		
		<cfif result.statuscode eq '200' OR result.statuscode eq '200 OK'>			
			<cfloop list="#result.fileContent#" index="elem" delimiters="&">
				<cfset confirmPaymentResponseStruct[listFirst(elem,"=")] = listLast(elem,"=")>
			</cfloop>
		</cfif>

		<cfreturn confirmPaymentResponseStruct>
	</cffunction>

	<!---Confirm reccuring payment--->
	<cffunction name="CreateRecurringPaymentsProfile" access="public">
		<cfargument name="finalAmount" required="true" type="any">

		<cfset ProfileDesc = "ReadingHeartDonation">
                
        <cfset DateNow = dateTimeFormat(now(), 'yyyy-mm-dd HH:nn:ss')>
                
		<cfif session.frequency eq "Month">
			<cfset BillingPeriod = "Month">
			<cfset BillingFrequency = 1>
			<cfset Date = dateAdd('m',1,DateNow)>
			<cfset ProfileStartDate = DateNow>
		<cfelseif session.frequency eq "Quarterly">
			<cfset BillingPeriod = "Month">
			<cfset BillingFrequency = 3>
			<cfset Date = dateAdd('m',3,DateNow)>
			<cfset ProfileStartDate = DateNow>
		<cfelseif session.frequency eq "biannual">
			<cfset BillingPeriod = "Month">
			<cfset BillingFrequency = 6>
			<cfset Date = dateAdd('m',6,DateNow)>
			<cfset ProfileStartDate = DateNow>
		</cfif>                

		<cfhttp url="#variables.server#" method="post" result="result">
			<cfhttpparam type="FormField" name="METHOD" value="CreateRecurringPaymentsProfile">
			<cfhttpparam type="FormField" name="TOKEN" value="#session.token#">
			<cfhttpparam type="FormField" name="PAYERID" value="#session.payerId#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_PAYMENTACTION" value="#session.paymentType#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_AMT" value="#arguments.finalAmount#">
			<cfhttpparam type="FormField" name="PAYMENTREQUEST_0_CURRENCYCODE" value="#session.currencyCodeType#">		
			<cfhttpparam type="FormField" name="PROFILESTARTDATE" value="#ProfileStartDate#">	
			<cfhttpparam type="FormField" name="DESC" value="#ProfileDesc#">	
			<cfhttpparam type="FormField" name="BILLINGPERIOD" value="#BillingPeriod#">	
			<cfhttpparam type="FormField" name="BILLINGFREQUENCY" value="#BillingFrequency#">	
			<cfhttpparam type="FormField" name="MAXFAILEDPAYMENTS" value="3">	
			<cfhttpparam type="FormField" name="TOTALBILLINGCYCLES" value="0">	
			<cfhttpparam type="FormField" name="AMT" value="#arguments.finalAmount#">	
			<cfhttpparam type="FormField" name="INITAMT" value="#arguments.finalAmount#">	
			<cfhttpparam type="FormField" name="IPADDRESS" value="#cgi.SERVER_NAME#">			
			<cfhttpparam type="FormField" name="VERSION" value="64">
			<cfhttpparam type="FormField" name="PWD" value="#variables.apiPwd#">
			<cfhttpparam type="FormField" name="USER" value="#variables.apiUserName#">
			<cfhttpparam type="FormField" name="SIGNATURE" value="#variables.apiSignature#">		
		</cfhttp>
		
		<cfset confirmPaymentResponseStruct = structNew()>
		<cfset confirmPaymentResponseStruct['ACK'] = 'FAIL'>
		
		<cfif result.statuscode eq '200' OR result.statuscode eq '200 OK'>			
			<cfloop list="#result.fileContent#" index="elem" delimiters="&">
				<cfset confirmPaymentResponseStruct[listFirst(elem,"=")] = listLast(elem,"=")>
			</cfloop>
		</cfif>

		<cfreturn confirmPaymentResponseStruct>
	</cffunction>

</cfcomponent>