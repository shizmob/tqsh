#!/usr/bin/env bash

function main {
    play illurock.mp3
    think "Well, professor Eileen's lecture was interesting."
    think "But to be honest, I couldn't concentrate on it very much."
    think "I had a lot of other thoughts on my mind."
    think "And they all ended up with a question."
    think "A question, I've been meaning to ask someone."
    think "When we came out of the university, I saw her."

    show sylvie_normal
    think "She was a wonderful person. I've known her ever since we were children."
    think "And she's always been a good friend."
    think "But..."
    think "Recently..."
    think "I think..."
    think "... that I wanted more. More than just talking."
    think "More than just walking home together when our classes ended."
    choice "And I decided..." \
        "To ask her right away." rightaway \
        "To ask her later." later
}

function rightaway {
     think "And I decided to ask her right away."

     show sylvie_smile
     say Sylvie "Oh, hi, do we walk home together?"
     say renpytom "Yes..."
     think "I said and my voice was already shaking."

     show sylvie_normal
     think "We reached the meadows just outside our hometown."
     think "Autumn was so beautiful here."
     think "When we were children, we often played here."

     say renpytom "Hey... Um..."
     show sylvie_smile
     think "She turned to me and smiled."
     think "I'll ask her..."

     say renpytom "Umm... will you..."
     say renpytom "Will you be my artist for a visual novel?"

     show sylvie_surprised
     think "Silence."
     think "She is shocked. And then..."

     show sylvie_smile
     say Sylvie "Sure, but what's a visual novel?"

     choice "" \
         "It's a story with pictures." vn \
         "It's a hentai game." hentai
}

function later {
     think "And I decided to ask her later."
     show
     think "And so I decided to ask her later. But I was indecisive."
     think "I couldn't ask her that day, and I couldn't ask her later."
     think "I guess I'll never know."

     think "~~~ BAD ENDING ~~~"
}

