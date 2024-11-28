package com.example.flutter_app

import android.os.Bundle // Import the Bundle class
import io.flutter.embedding.android.FlutterFragmentActivity // Import FlutterFragmentActivity
import com.stripe.android.PaymentConfiguration // Import Stripe's PaymentConfiguration

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize Stripe with your publishable key
        PaymentConfiguration.init(
            applicationContext,
            "pk_test_51QNNzXGwVsEEJOB4MbtrJWtTP98bNU2OIEdb2oNs5dhEIeF1NWQYFv9fIuo8SgXHig9I841qeQdWcs43QgzFyLdc00J4BmmCIQ" // Replace with your actual Stripe publishable key
        )
    }
}
