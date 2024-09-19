class Alphabet:
    """
    Parent Alphabet class
    We can:
    - Print all the letters of the alphabet
    - Count the number of letters
    """

    def __init__(self, language: str, letters: list):
        self.language = language or 'UK'
        self.letters = letters or []

    def print(self):
        # for i in self.letters:
        #     print(f"Letter: {i}")
        # Another option
        print(f"Letter in letters: {' '.join(self.letters)}")
        # Another option
        # for index, i in enumerate(self.letters):
        #     print(f"Letter: {i} on {index}")

    def letters_num(self):
        return len(self.letters)
