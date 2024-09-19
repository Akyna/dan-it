import requests
from faker import Faker

fake = Faker()

URL = 'http://127.0.0.1:3001/students'

FILE_PATH = 'results.txt'
with open(FILE_PATH, 'w') as new_file:
    pass  # Просто створюємо пустий файл і закриваємо його


def log_data(data):
    with open(FILE_PATH, 'a') as file:
        file.write(f'{data}\n')


def get_all_students():
    """Retrieve all existing students (GET)"""
    print('Retrieve all existing students (GET)')

    response = requests.get(URL)
    if response.status_code == 200:
        data = response.json()
        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def create_student():
    """Create student (POST)"""
    print('Create student (POST)')

    payload = {
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "age": fake.random_digit()
    }
    response = requests.post(URL, json=payload)
    if response.status_code == 201:
        data = response.json()
        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def show_student_by_last_name():
    """Retrieve information about all existing students (GET)"""
    print('Retrieve information about all existing students (GET)')

    response = requests.get(URL, params={'last_name': 'lysaght'})
    if response.status_code == 200:
        data = response.json()
        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def update_student_age(student_id: int, age: int):
    """Update the age of the student (PATCH)"""
    print('Update the age of the student (PATCH)')

    payload = {
        "age": age
    }
    response = requests.patch(f"{URL}/{student_id}", json=payload)
    if response.status_code == 201:
        data = response.json()
        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def show_student_by_id(student_id: int):
    """Retrieve information about the student by ID (GET)"""
    print('Retrieve information about the student by ID (GET)')

    response = requests.get(f"{URL}/{student_id}")
    if response.status_code == 200:
        data = response.json()
        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def update_third_student_data():
    """Update the fist name, last name and the age of the third student (PUT)"""
    print('Update the fist name, last name and the age of the third student (PUT)')

    payload = {
        "age": 34,
        "first_name": "John",
        "last_name": "Doe"
    }
    response = requests.put(f"{URL}/3", json=payload)
    if response.status_code == 201:
        data = response.json()
        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def delete_the_student_by_id(student_id: int):
    """Delete the user (DELETE)"""
    print('Delete the user (DELETE)')

    response = requests.delete(f"{URL}/{student_id}")
    if response.status_code == 201:
        data = response.json()

        print(data)
        log_data(data)
    else:
        print(f"Request failed with status code: {response.status_code}")


def main():
    get_all_students()
    create_student()
    create_student()
    create_student()
    show_student_by_last_name()
    update_student_age(student_id=2, age=100500)
    show_student_by_id(2)
    update_third_student_data()
    show_student_by_id(3)
    get_all_students()
    delete_the_student_by_id(1)
    get_all_students()


if __name__ == '__main__':
    main()
