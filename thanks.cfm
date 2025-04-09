<cfoutput>
    
    <link href="https://www.readingheart.org/style.css" rel="stylesheet" type="text/css">
<link href="https://www.readingheart.org/css/shortcodes.css" rel="stylesheet" type="text/css">
<link href="https://www.readingheart.org/css/responsive.css" rel="stylesheet" type="text/css">
<link href="https://www.readingheart.org/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="https://www.readingheart.org/css/shortcodes.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="https://www.readingheart.org/css/layerslider.css" type="text/css">


<!--prettyPhoto-->
<link href="https://www.readingheart.org/css/prettyPhoto.css" rel="stylesheet" type="text/css" media="all" />   

<!--[if IE 7]>
<link href="css/font-awesome-ie7.css" rel="stylesheet" type="text/css">
<![endif]-->
<!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<!--Fonts-->

<link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Bubblegum+Sans' rel='stylesheet' type='text/css'>
<link href='https://fonts.googleapis.com/css?family=Bubblegum+Sans' rel='stylesheet' type='text/css'>

<!--jquery-->
<script src="https://www.readingheart.org/js/modernizr-2.6.2.min.js"></script>

<link rel="stylesheet" href="https://www.readingheart.org/css/jquery-ui.css">
<link rel="stylesheet" href="https://www.readingheart.org/font-awesome-4.7.0/css/font-awesome.css">    
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://www.readingheart.org/js/jquery.validate.js" type="text/javascript"></script>
<link rel="stylesheet" href="https://www.readingheart.org/css/payment.css">
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<!--- Include Config file--->
<cfinclude template="paypalExpressCheckoutConfig.cfm">
    
    <div id="main">
        <!--breadcrumb-section starts-->
            <div class="breadcrumb-section" style="margin-bottom: 30px;">
            <div class="container">
                <h1>Thank you for your payment</h1>
                <div class="breadcrumb">
                    <a href="donate.cfm">Home</a>
                    <span class="fa fa-angle-double-right"></span>
                    <span class="current">Thank you</span>
                </div>
            </div>
        </div>
        <!--breadcrumb-section ends-->
        <!--container starts-->
        <div class="container">
            <cfif StructKeyExists(URL, "ac") AND url.ac eq 'success'>
                <cfset Freq = session.frequency>
                <cfif Freq eq "Month">
                    <cfset Freq_Day = 30>
                    <cfset Freq_Text = "Monthly">
                <cfelseif Freq eq "Quarterly">
                    <cfset Freq_Day = 90>
                    <cfset Freq_Text = "Quarterly">
                <cfelseif Freq eq "biannual">
                    <cfset Freq_Day = 180>
                    <cfset Freq_Text = "Bi-annual">
                <cfelse>
                    <cfset Freq_Day = 0>
                </cfif>
                 
                <cfif StructKeyExists(session, "credit_card")>
                    <cfset paypal_fname = session.fname>
                    <cfset paypal_lname = session.lname>
                    <cfset paypal_amount = session.paid_card_amount>
                <cfelse>
                    <cfset paypal_fname = session.paypal_fname>
                    <cfset paypal_lname = session.paypal_lname>
                    <cfset paypal_amount = session.payment_Amount>
                </cfif>

                <div style="margin-bottom: 50px; padding-left: 30px; padding-right: 30px;">
                    <div style="margin-bottom: 20px;">Dear #paypal_fname# #paypal_lname#,</div>
                    <div style="margin-bottom: 20px;">
                        Thank you, for your very kind donation of $#paypal_amount# which we received today. Your generosity will make an 
                        immediate difference in the lives of many kids.
                    </div>
                        
                    <div style="margin-bottom: 20px;">Thanks again for your kindness,<br/>
                        Danay and the Reading Heart family</div>
          
                        <cfif Freq_Day gt 0>
                            <div style="margin-bottom: 20px; font-size: 11px; line-height: 14px;">
                                #Freq_Text# donations are be billed every #Freq_Day# days until canceled. You can cancel at anytime by sending an email to 
                                info@readingheart.org or contacting us at 415-881-7323. 
                            </div>
                        </cfif>
                        
                        <div style="margin-bottom: 20px; font-size: 11px; line-height: 14px;">
                            Reading Heart is registered as a 501(c)(3) non-profit organization. Contributions to Reading Heart are tax-deductible to the extent permitted by 
                            law. For professional advice please consult your tax advisor.
                        </div>
                    </div>
                </div>
            <cfelse>
                <cflocation url="#baseUrl#/upworkcf/donate.cfm">
            </cfif>
                
        </div>
        <!--container ends-->
    </div>
</cfoutput>