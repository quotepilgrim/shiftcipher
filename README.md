# The cardinal grid shift cipher

This is a tool for enciphering and deciphering text messages using a cipher that
I have invented. The idea came to me when I was thinking of a way to obfuscate
the save data of a game that I am working on. The cipher takes three parameters:
the message to be enciphered, a set of gridshift rules and a keyword.

The user interface of the program is a bit rough around the edges. At the
moment, copying and pasting only works by using the corresponding buttons.
Selecting text is not possible, nor is changing the cursor position to
anywhere other than after the last character. Swap is a bit of a useless
button that I added to quickly check that deciphering the ciphertext would
actually result in the original plaintext -- it harms nobody to be there,
but I'll probably remove it later.

The font used is a font that I have created for the remake of my game
[Armed with Springs](https://github.com/quotepilgrim/armed-w-springs)
that I am currently working on.

## How does it work?

Here's an attempt at a description of how to apply the cipher to a message by
hand:

Start by building two 6x6 alphabet squares, containing all the letters from the
Latin alphabet and the digits 0 through 9. These are the source and target squares.
A keyword can be provided to reorder the characters in the target square. For 
instance, if the keyword "clockwise" is provided, the target square in its initial
state will look like this:

```
C L O K W I
S E A B D F
G H J L M N
P Q R T V X
Y Z 0 1 2 3
4 5 6 7 8 9
```

The gridshift rules consist of the letters "n", "e", "s", or "w", optionally
followed by any of the numbers 1 through 6, where each letter is one rule
indicating a direction in which to shift the target square. The numbers
following a letter, if any, indicate that only the numbered columns or rows
(depending on whether the shift is horizontal or vertical)
should be shifted in that direction, while the remaining columns/rows are
shifted in the opposite direction. For instance, the string "nesw" defines
four rules: 1. shift north, 2. shift east, 3. shift south, 4. shift west; while
w13n26 defines two rules: 1. shift first and third rows west -- everything else
east, 2. shift second and sixth columns north -- everything else south. When
defining numbered rules, it's a good idea to limit yourself to three numbers,
since w1345 does the same thing as e26.

Once equipped with the source and target square and the gridshift rules,
follow the steps below, starting from the first character and rule:

First, shift the target square by the current gridshift rule. Then, find the
current character from the plaintext in the source square. If the character
does not exist in the source square, write it to the ciphertext and move on
to the next character without doing anything else. Once you find the current
character in the source square, take note of its coordinates, then find the
character in the target square with the same coordinates and write that to
the ciphertext. Then move on to the next rule and plaintext character and
repeat the process. If the rule you just applied was the last one, go back
to the first one. Keep repeating until you reach the end of the plaintext.

Decoding the ciphertext is done by the same process, except instead of
looking up characters in the source square and finding the corresponding
character in the target square, you look up in the target square and find
in the source square. (The gridshift rules are still applied to the target
square).
