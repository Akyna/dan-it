import csv
from typing import List

from app.model.student import Student, StudentSchema

students_db: List[Student] = []


# with open('students.csv', 'r') as students:
#     csv_reader = csv.DictReader(students, delimiter=',')
#     for student in csv_reader:
#         print(student)


def loadData() -> None:
    try:
        with open('app/db/students.csv', 'r') as students:
            csv_reader = csv.DictReader(students, delimiter=',')
            # global students_db
            # students_list = [
            #     Student(int(student['id']), student['first_name'], student['last_name'], int(student['age']))
            #     for student in csv_reader
            # ]
            # students_db += students_list

            # OR
            schema = StudentSchema()
            for student in csv_reader:
                result = schema.load({
                    # "id": student['id'], # we create ID in class
                    "first_name": student['first_name'],
                    "last_name": student['last_name'],
                    "age": student['age'],
                })
                students_db.append(result)

                # OR
                # students_db.append(
                #     Student(int(student['id']), student['first_name'], student['last_name'], int(student['age']))
                # )
    except FileNotFoundError as dd:
        pass
