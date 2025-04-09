PayPal Express Checkout Integration (ColdFusion)
    This integration provides an Express Checkout flow using PayPal’s NVP (Name-Value Pair) API via ColdFusion, supporting both one-time payments and recurring billing agreements.

Features
    Set up PayPal Express Checkout sessions

    Redirect users to PayPal for approval

    Support for recurring billing profiles

    Error handling and response parsing

    Configurable for sandbox or live mode

Configuration
    You’ll need to configure the following:

    apiUserName, apiPwd, apiSignature: Your PayPal API credentials

    variables.server: PayPal NVP API endpoint (sandbox or live)

    variables.paypal_url: Base URL for redirecting to PayPal checkout (sandbox or live)

    These are typically stored in a separate config file (paypalExpressCheckoutConfig.cfm), which is included before calling the payment logic.

Key Functions
1. CallRecurringPaymentsProfile
    Used for initiating a recurring payment agreement.

    Sets method to SetExpressCheckout

    Billing type is set to RecurringPayments

    Requires return and cancel URLs

    Response contains a PayPal TOKEN if successful

2. CallShortcutExpressCheckout
    Used for one-time payments.

    Also uses SetExpressCheckout

    No recurring billing fields

    Response returns a TOKEN for redirect if successful

3. RedirectToPayPal
    After getting a valid response with a token from PayPal, this function constructs the full redirect URL and sends the user to the PayPal approval page.

Session Usage
Session variables are used to retain important data between API calls and PayPal redirects:

    currencyCodeType, paymentType, payment_Amount

Optional donation metadata: donation_for, frequency, dedicate_option, etc.

Flow Summary
    Include Config: Load credentials and PayPal URLs from config.

    Create Object: Instantiate the PayPal CFC with credentials.

    Determine Payment Type:

    If recurring → call CallRecurringPaymentsProfile

    Else → call CallShortcutExpressCheckout

    Redirect to PayPal:

    If API response is success, redirect using token.

    If failure, display detailed error messages.