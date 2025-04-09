<!--- 
Filename: index.cfm
Description: This file has the form, on submission, form data is processed inside file paypalExpressCheckout.cfm
--->


<html>
<head>

</head>
<body class="main">
	<!--wrapper starts-->
    <div class="wrapper">

        <!---Main Container --->
        <div id="main">
            <div class="container">
            	<section id="primary" class="with-sidebar">    
                    <form name="submit_payment" id="submit_payment" action="paypalExpressCheckout.cfm" method="POST">
                    <div class="dt-sc-hr"></div>
                    <div class="payment-container">
                        <div class="widget select-amount">
                                <div style="text-align: center;">
                               
                                <h1>Donation</h1>
                                </div>
                                    <h3 style="margin-top: 15px !important; margin-bottom: 10px !important;">I want to give</h3>
                                    <input class="amount" type="radio" name="payment_amount" id="payment_amount" value="1000.00">
                                    <label for="payment_amount" class="donation-amount">$1000</label>  
                                    <input class="amount" type="radio" name="payment_amount" id="radio-2" value="500.00">
                                    <label for="radio-2" class="donation-amount">$500</label>   
                                    <input class="amount" type="radio" name="payment_amount" id="radio-3" value="250.00">
                                    <label for="radio-3" class="donation-amount">$250</label>   
                                    <input class="amount" type="radio" name="payment_amount" id="radio-4" value="100.00">
                                    <label for="radio-4" class="donation-amount" >$100</label>   
                                    <input class="amount" type="radio" name="payment_amount" id="radio-5" value="50.00">
                                    <label for="radio-5" class="donation-amount">$50</label>   
                                    <input class="amount" type="radio" name="payment_amount" id="radio-6" value="20.00" checked>
                                    <label for="radio-6" class="donation-amount" >$20</label>    
                                    <div class="other-amount">
                                    <input placeholder="Other Amount" name="other_amount" id="other_amount" class="other-amount-right" type="text" style="padding: 0; padding-left: 12px;">
                                </div>
                            <div style="margin-top: 8px;">
                                $10.00 is the minimum online donation. All donations are tax deductible. 
                            </div>
                        </div>
                        <div class="widget">
                            <h3 style="margin-top: 15px !important; margin-bottom: 10px !important;">Frequency</h3>
                            <div style="display: inline-block;">
                                <input class="frequency ui-checkboxradio ui-helper-hidden-accessible" type="radio" name="frequency" id="frequency-onetime" checked="true" value="OneTime">
                                <label for="frequency-onetime" class="ui-checkboxradio-label ui-corner-all ui-button ui-widget ui-checkboxradio-radio-label ui-checkboxradio-checked ui-state-active">One Time</label>
                                <input class="frequency ui-checkboxradio ui-helper-hidden-accessible" type="radio" name="frequency" id="frequency-monthly" value="Month">
                                <label for="frequency-monthly" class="ui-checkboxradio-label ui-corner-all ui-button ui-widget ui-checkboxradio-radio-label">Monthly</label>
                                <input class="frequency ui-checkboxradio ui-helper-hidden-accessible" type="radio" name="frequency" id="frequency-quarterly" value="Quarterly">
                                <label for="frequency-quarterly" class="ui-checkboxradio-label ui-corner-all ui-button ui-widget ui-checkboxradio-radio-label">Quarterly</label>
                                <input class="frequency ui-checkboxradio ui-helper-hidden-accessible" type="radio" name="frequency" id="frequency-biannual" value="biannual">
                                <label for="frequency-biannual" class="ui-checkboxradio-label ui-corner-all ui-button ui-widget ui-checkboxradio-radio-label">Bi-annual</label>
                                <label style="clear: both; margin-top: 20px; cursor: pointer;" class="dedicated-label">
                                <input class="isDedicated" name="isDedicated" id="isDedicated" type="checkbox">
                                <span class="dedication-label">
                                <span class="ng-binding label-text">Dedicate this gift to a friend or loved one</span>
                                </span>
                                </label>
                            </div>
                        </div>
                        <div class="paypal-payment-div">
                            <div style="text-align: center;">
                                <a style="cursor: pointer;" onclick="document.getElementById('submit_payment').submit();"><img style="cursor: pointer;" class="rco-ui-imagelink" src="https://www.readingheart.org/images/donatePayPal.png" alt="Donate with Paypal"></a>
                            </div>
                        </div>
                    </div>
                    </form>
               </section>
 
                </section>   
                </section>
                <!--primary ends-->
            </div>   
        </div>
</body>
</html>
