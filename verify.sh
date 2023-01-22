#!/bin/bash

registerAndVerify() {

    if [ -f /root/.local/share/signal-cli/data/accounts.json ]
    then
        echo "Account already registered."
    else
        # Register account
        echo 'Visit https://signalcaptchas.org/registration/generate.html and get CAPTCHA code from failed link in devtools (F12)';
        read -p 'Enter CAPTCHA: ' captcha;
        signal-cli -a "${ACCOUNT}" register --captcha ${captcha#"signalcaptcha://"};

        # Verify account
        read -p 'Enter code from SMS: ' code;
        signal-cli -a "${ACCOUNT}" verify $code
    fi
    
    python3 main.py
}

registerAndVerify