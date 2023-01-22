import os
import time
import openai

api_key = os.getenv("OPENAI_API_KEY")
account = os.getenv("ACCOUNT")
recipient = os.getenv("RECIPIENT")

def parse(stream):
    stream = stream.strip().splitlines()
    bodies = []
    append = False
    body_index = 0
    for line in stream:
        if line.startswith("Envelope from:") or line.startswith("With profile key"):
            append = False
        if line.startswith("Body: "):
            body_index += 1
            bodies.append([])
            append = True
        if append:
            bodies[body_index - 1].append(line.replace("Body: ", "") if line.startswith("Body: ") else line)

    messages = []
    for body in bodies:
        messages.append(' '.join(body))

    return messages

def send_message(message):
    import os
    os.popen(f'signal-cli -a {account} send -m "{message}" {recipient}')

def send_typing():
    import os
    os.popen(f'signal-cli -a {account} sendTyping {recipient}')

def receive_messages():
    import os
    stream = os.popen(f'signal-cli -a {account} receive')
    output = stream.read()
    return parse(output)

def on_message_received(message):
    send_typing()
    openai.api_key = os.getenv("OPENAI_API_KEY")
    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=f"{message}",
        temperature=0,
        max_tokens=200,
        top_p=1,
        frequency_penalty=0.0,
        presence_penalty=0.0,
        stop=["#"]
    )
    if len(response.choices) > 0 and len(response.choices[0].text) > 0:
        send_message(response.choices[0].text)
    else:
        send_message("I couldn't generate a response.")

while True:
    messages = receive_messages()
    if len(messages) > 0:
        for message in messages:
            on_message_received(message)

    time.sleep(1)

