import random


def guess_number(attempts: int):
    secret_number = random.randint(1, 100)
    print(f"Вгадайте число від 1 до 100. У вас є {attempts} спроб.")
    attempt = 0

    while attempt < attempts:
        try:
            user_guess = int(input(f"Спроба {attempt + 1}: Ваше припущення: "))
            if user_guess == secret_number:
                print("Вітаємо! Ви вгадали правильне число.")
                break
            elif user_guess < secret_number:
                print("Занадто низько!")
            else:
                print("Занадто високо!")
        except ValueError:
            attempt -= 1
            # (attempt := attempt - 1)
            print("Ви ввели щось, що не схоже на число.")
        attempt += 1

    if attempt == attempts:
        print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {secret_number}.")


guess_number(5)
