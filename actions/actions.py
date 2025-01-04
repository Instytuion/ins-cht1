
# from typing import Any, Text, Dict, List
# from rasa_sdk import Action, Tracker
# from rasa_sdk.executor import CollectingDispatcher
# from django.db import connection
# import logging
# import os
# import django
# from dotenv import load_dotenv
# from asgiref.sync import sync_to_async

# load_dotenv()

# os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'chat_bot.settings')
# django.setup()

# # Logger setup
# logger = logging.getLogger(__name__)

# class ActionRecommendBestCourse(Action):
#     def name(self) -> Text:
#         return "action_get_best_course"
    
#     @sync_to_async
#     def fetch_best_course(self):
#         """Perform the database query to fetch the best course."""
#         try:
#             query = """
#                 SELECT 
#                     course.id,
#                     course.name,
#                     COUNT(batch_students.id) AS total_students
#                 FROM 
#                     courses_course AS course
#                 JOIN 
#                     courses_batch AS batch ON batch.course_id = course.id
#                 JOIN 
#                     courses_batchstudents AS batch_students ON batch_students.batch_id = batch.id
#                 GROUP BY 
#                     course.id, course.name
#                 ORDER BY 
#                     total_students DESC
#                 LIMIT 1;
#             """
#             with connection.cursor() as cursor:
#                 cursor.execute(query)
#                 result = cursor.fetchone()
#                 logger.info(f"Fetched course: {result}")  # Log the result
#             return result
#         except Exception as e:
#             logger.error(f"An error occurred while fetching the course: {str(e)}")
#             return None

#     async def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
#         try:
#             logger.info("Fetching the best course...")
#             result = await self.fetch_best_course()

#             if result and len(result) >= 3:
#                 best_course_name = result[1]
#                 student_count = result[2]
#                 response = (
#                     f"The best course based on student enrollment is '{best_course_name}' with {student_count} students enrolled."
#                 )
#             else:
#                 response = "I couldn't find any popular courses right now."

#         except Exception as e:
#             logger.error(f"An error occurred: {str(e)}")
#             response = f"An error occurred while fetching the course: {str(e)}"

#         dispatcher.utter_message(text=response)
#         return []



from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from django.db import connection
import logging
import os
import django
from dotenv import load_dotenv
from asgiref.sync import sync_to_async

# Load environment variables from .env file
load_dotenv()

# Set up Django settings and initialize Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'chat_bot.settings')  # Ensure this path is correct
django.setup()

# Logger setup
logger = logging.getLogger(__name__)

class ActionRecommendBestCourse(Action):
    def name(self) -> Text:
        return "action_get_best_course"
    
    @sync_to_async
    def fetch_best_course(self):
        """Perform the database query to fetch the best course."""
        try:
            query = """
                SELECT 
                    course.id,
                    course.name,
                    COUNT(batch_students.id) AS total_students
                FROM 
                    courses_course AS course
                JOIN 
                    courses_batch AS batch ON batch.course_id = course.id
                JOIN 
                    courses_batchstudents AS batch_students ON batch_students.batch_id = batch.id
                GROUP BY 
                    course.id, course.name
                ORDER BY 
                    total_students DESC
                LIMIT 1;
            """
            with connection.cursor() as cursor:
                cursor.execute(query)
                result = cursor.fetchone()
                logger.info(f"Fetched course: {result}")  # Log the result for debugging
            return result
        except Exception as e:
            logger.error(f"An error occurred while fetching the course: {str(e)}")
            return None

    async def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        try:
            logger.info("Fetching the best course...1231313")
            result = await self.fetch_best_course()
            logger.info("Best course: {}".format(result))
            print('result is :', result)
            if result and len(result) >= 3:
                best_course_name = result[1]
                student_count = result[2]
                response = (
                    f"The best course based on student enrollment is '{best_course_name}' with {student_count} students enrolled."
                )
            else:
                response = "I couldn't find any popular courses right now."

        except Exception as e:
            logger.error(f"An error occurred: {str(e)}")
            response = f"An error occurred while fetching the course: {str(e)}"

        dispatcher.utter_message(text=response)
        return []
