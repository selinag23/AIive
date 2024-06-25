# AIive ReadMe Document
UM-SJTU JI 2024SU ECE4410J 

Team AIive

# Getting Started

> Documentation on how to build and run your project. For now, simply list and provide a link to all 3rd-party tools, libraries, SDKs, APIs your project will rely on directly, that is, you don't need to list libraries that will be installed automatically as dependencies when installing the libraries you rely on directly. List both front-end and back-end dependencies.

### Front End

### Back End

##### Contact Database
- SQLAlchemy
- OAuth 2.0
- Elasticsearch
- OpenAI API



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


**Example**
~~~ 
curl -b cookies.txt -c cookies.txt -X GET https://OUR_SERVER/recommendations/'

{
    "attribute_error": {
        "acousticness": 0.1342,
        "danceability": 0.2567,
        "energy": 0.1144,
        "instrumentalness": 0.021,
        "liveness": 0.0324,
        "loudness": 0.0084,
        "speechiness": 0.0528,
        "tempo": 0.0446,
        "valence": 0.1538
    },
    "attribute_recommendations": [
        "spotify:track:3joo84oco9CD4dBsKNWRRW",
        "spotify:track:5DxlyLbSTkkKjJPGCoMo1O",
        ...
    ],
    "genre_recommendations": [
        "spotify:track:4MzXwWMhyBbmu6hOcLVD49",
        "spotify:track:0bYg9bo50gSsH3LtXe2SQn",
        ...
    ],
    "artist_recommendations": [
        "spotify:track:2EjXfH91m7f8HiJN1yQg97",
        "spotify:track:5o8EvVZzvB7oTvxeFB55UJ",
        ...
    ],
    "url": "/recommendations/"
}
~~~

## Third-Party SDKs





# View UI/UX

> Leave this section blank for now.  You will populate it with your UI/UX design in a latter assignment.




# Team Roster

**Aya Shinkawa:**

**Anheng Wang:**

**Peiran Wang:**

**Ruiqi Xu:**

**Xin Gong:**

**Yan Lu:**
