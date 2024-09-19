from eng_alphabet import EngAlphabet

alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
# list((alphabet, alphabet))

eng_alphabet = EngAlphabet('EN', list(alphabet))

num = eng_alphabet.letters_num()
is_letter_in_alphabet = eng_alphabet.is_en_letter('A')
is_other_letter_in_alphabet = eng_alphabet.is_en_letter('Щ')
example = eng_alphabet.example()

eng_alphabet.print()
print(is_letter_in_alphabet)
print(is_other_letter_in_alphabet)
print(example)
