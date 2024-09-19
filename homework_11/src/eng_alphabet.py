from alphabet import Alphabet


class EngAlphabet(Alphabet):
    """
    English Alphabet class
    We can:
    - Count the number of letters
    - Determine whether a letter belongs to the English alphabet
    - Get an example text in English.
    """

    _letters_num = 0

    def __init__(self, language: str, letters: list):
        super().__init__(language, letters)
        EngAlphabet._letters_num = super().letters_num()

    # @override As of python 3.12
    @classmethod
    def letters_num(cls):
        return cls._letters_num

    def is_en_letter(self, char: str):
        # Case sensitive
        # return self.letters.__contains__(char)
        # or
        return [char.lower() for char in self.letters].__contains__(char.lower())

    @staticmethod
    def example():
        return 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
