# AIive ReadMe Document
UM-SJTU JI 2024SU ECE4410J 

Team AIive

# Getting Started

> Documentation on how to build and run your project. For now, simply list and provide a link to all 3rd-party tools, libraries, SDKs, APIs your project will rely on directly, that is, you don't need to list libraries that will be installed automatically as dependencies when installing the libraries you rely on directly. List both front-end and back-end dependencies.


### Front-End

- **[Semantic UI React](https://react.semantic-ui.com/)**: A development framework that helps create beautiful, responsive layouts using human-friendly HTML.
- **[Web Speech API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API)**: Provides an interface to control speech synthesis and recognition, allowing the app to understand and produce spoken language.
- **[Axios](https://axios-http.com/)**: A promise-based HTTP client for the browser and Node.js. It makes it easy to send asynchronous HTTP requests to REST endpoints and perform CRUD operations.
- **[CalendarKit](https://github.com/richardtop/CalendarKit)**: A Swift-based framework for creating a customizable calendar view in iOS apps.
- **[Reminder](https://developer.apple.com/tutorials/app-dev-training/adding-and-deleting-reminders)**: Apple's tutorial for adding and deleting reminders in an iOS app using EventKit.
- **[EventKit](https://medium.com/@rohit.jankar/using-swift-a-guide-to-adding-reminders-in-the-ios-reminder-app-with-the-eventkit-api-020b2e6b38bb)**: A framework that provides access to calendar and reminder data, allowing the app to create, edit, and delete events and reminders.

### Back-End 

- **[SQLAlchemy](https://www.sqlalchemy.org/)**: A SQL toolkit and Object-Relational Mapping (ORM) library for Python. It provides tools to work with relational databases in a more Pythonic way.
- **[SQLite](https://www.sqlite.org/index.html)**: A C library that provides a lightweight, disk-based database. It doesn't require a separate server process, making it easy to set up and use.
- **[OAuth 2.0](https://oauth.net/2/)**: An authorization framework that allows applications to obtain limited access to user accounts on an HTTP service.
- **[Elasticsearch](https://www.elastic.co/elasticsearch/)**: A distributed, RESTful search and analytics engine capable of storing and searching large volumes of data.
- **[OpenAI API](https://beta.openai.com/docs/)**: Provides access to OpenAI's language models, enabling natural language understanding and generation in your application.
- **[PostgreSQL](https://www.postgresql.org/)**: A powerful, open-source object-relational database system known for its reliability and feature set.
- **[Flask](https://flask.palletsprojects.com/)**: A lightweight WSGI web application framework for Python. It is designed to make getting started quick and easy, with the ability to scale up to complex applications.
- **[spaCy](https://spacy.io/)**: An open-source software library for advanced natural language processing in Python.
- **[NLTK](https://www.nltk.org/)**: The Natural Language Toolkit is a Python library for natural language processing.
- **[Gensim](https://radimrehurek.com/gensim/)**: A Python library for topic modeling and document similarity analysis using modern statistical machine learning.
- **[Hugging Face Transformers](https://huggingface.co/transformers/)**: A library that provides general-purpose architectures for Natural Language Understanding (NLU) and Natural Language Generation (NLG) with pretrained models.
- **[Google Cloud Speech-to-Text API](https://cloud.google.com/speech-to-text)**: Converts audio to text by applying powerful neural network models in an easy-to-use API.
- **[Microsoft Azure Speech API](https://azure.microsoft.com/en-us/services/cognitive-services/speech-to-text/)**: Converts spoken audio to text, translates spoken languages, and synthesizes speech from text.




# Model and Engine

> Put a copy of your Storymap here.  List all components of your engine architectures and how they tie together. Draw a block diagram showing your data and control flows in the engine. For each block, describe how the functionalities will be implemented. If your app doesn't have its own engine, describe how you will use the OS sub-systems or 3rd-party SDKs to build your app. You can re-use your engine architecture slides from the DRAFT portion of this assignment, but they should be accompanied by descriptive explanation, e.g., the talk to give accompanying each slide.

### Storymap
![StoryMap](https://github.com/selinag23/AIive/assets/116231204/a51476f9-e4b4-4409-8da3-9736f0984771)


### Engine Architechture

![Engine Architechture](https://github.com/selinag23/AIive/assets/171781619/bf22c8b4-5060-43fa-96a8-ab443ff51c1d)
#### Components of Engine Architecture

1. **AI Agent**
   - **Natural Language Communication Portal**
     - Interface for users to interact with the app using natural language.
   - **Search and Prepare for Storing Stuff to Database**
     - Processes inputs and prepares data for storage.
   - **Multi-Media Input**
     - Handles different types of inputs (text, voice, images).

2. **Calendar**
   - **Manage Events**
     - CRUD operations for calendar events.
   - **Event Personalize Recommendation**
     - Suggests events based on user preferences and behavior.
   - **Sync Databases to Server**
     - Ensures all calendar data is synchronized with the central server.

3. **Reminder**
   - **Make a To-Do List for Events**
     - Creates tasks related to calendar events.
   - **Remind Users Before the Deadline**
     - Sends notifications to remind users of upcoming deadlines.
   - **Intelligent Reminder**
     - Uses AI to optimize reminder settings based on user behavior.
   - **Advanced Settings for Reminder**
     - Provides additional customization for reminders.

4. **Contacts**
   - **Identify Instructions for Contact Database**
     - Processes user input to update contact information.
   - **Interaction with Calendar Event**
     - Links contacts with calendar events.
   - **Speed Up Searches**
     - Optimizes the search functionality for contacts.
   - **Additional Info Handling**
     - Manages supplementary contact information.
   - **Security and Access Control**
     - Ensures data privacy and controlled access to contact information.

5. **Diary/Memo**
   - **Add Memo & Diary**
     - Allows users to create and store memos and diary entries.
   - **Auto-Daily Diary**
     - Automatically generates diary entries based on user activities.
   - **Contacts-Memo Interaction**
     - Links diary/memo entries with relevant contacts.

#### How Components Tie Together

1. **AI Agent Integration**
   - **Natural Language Communication Portal** interacts with the **Calendar**, **Reminder**, **Contacts**, and **Diary/Memo** components to fetch, update, and display information based on user commands.
   - **Search and Prepare for Storing Stuff to Database** handles preprocessing of input data for all modules.
   - **Multi-Media Input** can be used across all components to accept different forms of user input.

2. **Calendar and Reminder Synchronization**
   - **Manage Events** in the **Calendar** component directly ties into **Make a To-Do List for Events** in the **Reminder** component.
   - **Sync Databases to Server** ensures that both **Calendar** and **Reminder** data are up-to-date on the server.
   - **Event Personalize Recommendation** uses data from both the **Calendar** and **Reminder** to suggest personalized events and reminders.

3. **Contacts and Other Modules Interaction**
   - **Identify Instructions for Contact Database** enables the **AI Agent** to update contact information.
   - **Interaction with Calendar Event** allows calendar events to be linked with specific contacts, enhancing **Calendar** and **Contacts** integration.
   - **Speed Up Searches** benefits from **AI Agent** optimizations for quick data retrieval.
   - **Security and Access Control** ensures that sensitive contact information is protected, affecting how data is accessed across the app.

4. **Diary/Memo Integration**
   - **Add Memo & Diary** and **Auto-Daily Diary** can receive input from the **AI Agent**.
   - **Contacts-Memo Interaction** links diary entries with relevant contacts, allowing cross-referencing between **Diary/Memo** and **Contacts**.

#### Data Flow and Synchronization
- The **Sync Databases to Server** functionality in the **Calendar** component ensures all data from the **Calendar**, **Reminder**, **Contacts**, and **Diary/Memo** is centralized and synchronized.
- **Security and Access Control** in the **Contacts** component ensures secure data flow and access control for sensitive information.


### Data Flow
![db](https://github.com/selinag23/AIive/assets/116231204/beaa2d5a-ecfc-4964-8fe2-50164c925af9)


# APIs and Controller

> Describe how your front-end would communicate with your engine: list and describe your APIs. This is only your initial design, you can change them again later, but you should start thinking about and designing how your front end will communicate with your engine. If you're using existing OS subsystem(s) or 3rd-party SDK(s) to implement your engine, describe how you will interact with these.


### Overview

**Request Parameters**
| Key        | Location | Type   | Description      |
| ---------- | -------- | ------ | ---------------- |
| `username` | Session Cookie| String | Current User |
| `event` | Session Cookie| String | Event Data |

**Response Codes**
| Code              | Description            |
| ----------------- | ---------------------- |
| `200 OK`     | Success                |
| `400 Bad Request` | Invalid parameters     |

**Returns**

*For logged-in users with 1 or more events created*
| Key        | Location       | Type   | Description  |
| ---------- | -------------- | ------ | ------------ |
| `reminders` | JSON | List of to-do events | Events remains to-be-done in events database |

*For logged-in users with 1 or more contacts created*
| Key        | Location       | Type   | Description  |
| ---------- | -------------- | ------ | ------------ |
| `contacts` | JSON |List of contacts basic info | headshot, name, brief description |



### Calendar API

**Create Event**
- **URL**: `/api/events`
- **Method**: `POST`
- **Description**: Creates a new calendar event.
- **Request Parameters**:
  | Key           | Location | Type   | Description               |
  | ------------- | -------- | ------ | ------------------------- |
  | `title`       | Body     | String | Title of the event        |
  | `description` | Body     | String | Description of the event  |
  | `start_time`  | Body     | String | Start time of the event   |
  | `end_time`    | Body     | String | End time of the event     |

**Modify Event**
- **URL**: `/api/events/:id`
- **Method**: `PUT`
- **Description**: Modifies an existing calendar event.
- **Request Parameters**:
  | Key           | Location | Type   | Description               |
  | ------------- | -------- | ------ | ------------------------- |
  | `id`          | URL      | String | ID of the event           |
  | `title`       | Body     | String | Title of the event        |
  | `description` | Body     | String | Description of the event  |
  | `start_time`  | Body     | String | Start time of the event   |
  | `end_time`    | Body     | String | End time of the event     |

**Delete Event**
- **URL**: `/api/events/:id`
- **Method**: `DELETE`
- **Description**: Deletes a calendar event.
- **Request Parameters**:
  | Key  | Location | Type   | Description   |
  | ---- | -------- | ------ | ------------- |
  | `id` | URL      | String | ID of the event |

**Get Events**
- **URL**: `/api/events`
- **Method**: `GET`
- **Description**: Retrieves all calendar events.
- **Response**:
  | Key      | Location | Type  | Description           |
  | -------- | -------- | ----- | --------------------- |
  | `events` | JSON     | Array | List of calendar events |

### Reminder API

**Create Reminder**
- **URL**: `/api/reminders`
- **Method**: `POST`
- **Description**: Creates a new reminder.
- **Request Parameters**:
  | Key           | Location | Type   | Description               |
  | ------------- | -------- | ------ | ------------------------- |
  | `event_id`    | Body     | String | ID of the associated event |
  | `remind_time` | Body     | String | Time to send the reminder  |

**Modify Reminder**
- **URL**: `/api/reminders/:id`
- **Method**: `PUT`
- **Description**: Modifies an existing reminder.
- **Request Parameters**:
  | Key           | Location | Type   | Description               |
  | ------------- | -------- | ------ | ------------------------- |
  | `id`          | URL      | String | ID of the reminder        |
  | `event_id`    | Body     | String | ID of the associated event |
  | `remind_time` | Body     | String | Time to send the reminder  |

**Delete Reminder**
- **URL**: `/api/reminders/:id`
- **Method**: `DELETE`
- **Description**: Deletes a reminder.
- **Request Parameters**:
  | Key  | Location | Type   | Description   |
  | ---- | -------- | ------ | ------------- |
  | `id` | URL      | String | ID of the reminder |

**Get Reminders**
- **URL**: `/api/reminders`
- **Method**: `GET`
- **Description**: Retrieves all reminders.
- **Response**:
  | Key        | Location | Type  | Description           |
  | ---------- | -------- | ----- | --------------------- |
  | `reminders`| JSON     | Array | List of reminders      |

### Contact API

**Add Contact**
- **URL**: `/api/contacts`
- **Method**: `POST`
- **Description**: Adds a new contact.
- **Request Parameters**:
  | Key      | Location | Type   | Description             |
  | -------- | -------- | ------ | ----------------------- |
  | `name`   | Body     | String | Name of the contact     |
  | `email`  | Body     | String | Email of the contact    |
  | `phone`  | Body     | String | Phone number of the contact |
  | `notes`  | Body     | String | Additional notes        |

**Query Contact**
- **URL**: `/api/contacts/:id`
- **Method**: `GET`
- **Description**: Retrieves contact information by ID.
- **Request Parameters**:
  | Key  | Location | Type   | Description       |
  | ---- | -------- | ------ | ----------------- |
  | `id` | URL      | String | ID of the contact |

**Delete Contact**
- **URL**: `/api/contacts/:id`
- **Method**: `DELETE`
- **Description**: Deletes a contact.
- **Request Parameters**:
  | Key  | Location | Type   | Description       |
  | ---- | -------- | ------ | ----------------- |
  | `id` | URL      | String | ID of the contact |

**Get All Contacts**
- **URL**: `/api/contacts`
- **Method**: `GET`
- **Description**: Retrieves all contacts.
- **Response**:
  | Key      | Location | Type  | Description           |
  | -------- | -------- | ----- | --------------------- |
  | `contacts` | JSON   | Array | List of contacts      |

### Diary API

**Add Entry**
- **URL**: `/api/diaries`
- **Method**: `POST`
- **Description**: Adds a new diary entry.
- **Request Parameters**:
  | Key           | Location | Type   | Description               |
  | ------------- | -------- | ------ | ------------------------- |
  | `content`     | Body     | String | Content of the diary entry |
  | `date`        | Body     | String | Date of the diary entry    |

**Get Entries**
- **URL**: `/api/diaries`
- **Method**: `GET`
- **Description**: Retrieves all diary entries.
- **Response**:
  | Key      | Location | Type  | Description           |
  | -------- | -------- | ----- | --------------------- |
  | `entries`| JSON     | Array | List of diary entries  |



## Third-Party SDKs

**OpenAI API**
- **Description**: Provides access to OpenAI's language models for natural language understanding and generation.
- **Interaction**: The front end will send text inputs to the OpenAI API and receive processed language outputs for various functionalities such as chat responses and command processing.

**Google Cloud Speech-to-Text API**
- **Description**: Converts audio to text using Google's powerful neural network models.
- **Interaction**: The app will use this API to convert user voice inputs into text, which can then be processed by the AI agent.

**Microsoft Azure Speech API**
- **Description**: Converts spoken audio to text, translates spoken languages, and synthesizes speech from text.
- **Interaction**: Similar to Google Cloud Speech-to-Text, this API will be used to handle voice inputs and outputs within the app.

**CalendarKit**
- **Description**: A framework for creating a customizable calendar view in iOS apps.
- **Interaction**: The front end will use CalendarKit to display calendar events and manage user interactions with the calendar.

**EventKit**
- **Description**: A framework for accessing and manipulating calendar and reminder data on iOS.
- **Interaction**: The app will use EventKit to integrate with the user's calendar and reminders, allowing seamless creation, modification, and deletion of events and reminders.





# View UI/UX

> Leave this section blank for now.  You will populate it with your UI/UX design in a latter assignment.


# Team Roster

**Aya Shinkawa:**

**Anheng Wang:**

**Peiran Wang:**

**Ruiqi Xu:**

**Xin Gong:**

**Yan Lu:**
