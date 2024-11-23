# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

# from typing import Any, Text, Dict, List
#
# from rasa_sdk import Action, Tracker
# from rasa_sdk.executor import CollectingDispatcher
#
#
# class ActionHelloWorld(Action):
#
#     def name(self) -> Text:
#         return "action_hello_world"
#
#     def run(self, dispatcher: CollectingDispatcher,
#             tracker: Tracker,
#             domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
#
#         dispatcher.utter_message(text="Hello World!")
#
#         return []


from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from django.db import connection

class ActionRecommendBestCourse(Action):
    def name(self) -> Text:
        return "action_recommend_best_course"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        try:
            print("HEyyyy iam working ")
            # Raw SQL query to get the most popular course (highest enrolled students)
            query = """
                SELECT course.name, COUNT(batch_students.id) AS student_count
                FROM batch_students
                JOIN batch ON batch_students.batch_id = batch.id
                JOIN course ON batch.course_id = course.id
                GROUP BY course.id
                ORDER BY student_count DESC
                LIMIT 1;
            """

            with connection.cursor() as cursor:
                cursor.execute(query)
                result = cursor.fetchone()

            if result:
                best_course_name = result[0]  # Course name
                student_count = result[1]     # Number of students enrolled in that course

                # Returning the response
                response = (f"The best course based on student enrollment is '{best_course_name}'. "
                            f"It has {student_count} students enrolled.")
            else:
                response = "I couldn't find any popular courses right now."

        except Exception as e:
            response = f"An error occurred while fetching the course: {str(e)}"

        dispatcher.utter_message(text=response)
        return []
