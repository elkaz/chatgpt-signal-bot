# ChatGPT Signal Bot
Have a convo with ChatGPT using Signal.

## Getting started

Build the Dockerfile
```
docker build -t signal-bot .
```
Create a Docker volume to store the Signal bot account details. This will avoid registering and verifying your Signal account each time you restart the container.
```
docker create volume signal-bot-volume
```

Run the docker container in interactive mode, as you will need to provide a CAPTCHA and subsequent SMS code. And to mount the volume created in the previous step. You'll also need to provide the follow args:
* ACCOUNT - an international mobile number for your signal bot.
* RECIPIENT - the international number for the account that will interact with the bot. Future release will derive this from the message so multiple users can chat with your single bot instance.
* OPENAI_API_KEY - an API key from your OpenAI account. https://beta.openai.com/account/api-keys
```
docker run --env ACCOUNT=+4100000000 --env RECIPIENT=+4111111111 --env OPENAI_API_KEY=sk-YM7dsD7j... -v signal-bot-volume:/root/.local/share/signal-cli/data -it signal-bot 
```
### Getting the CAPTCHA code
The Signal CAPTCHA can is generated here: https://signalcaptchas.org/registration/generate.html - use devtools (F12) to get the CAPTCHA code from the URL. The embedded script will automatically strip the `signalcaptcha://` prefix.