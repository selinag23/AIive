# AIive ReadMe Document
UM-SJTU JI 2024SU ECE4410J 

Team AIive
# Team Roster

**Aya Shinkawa:** Memo Function

**Anheng Wang:** Contact Function

**Peiran Wang:** Reminder Function
#### Design

1. Algorithm for Intelligent Reminder
   - Design the basic, natural, intuitive algorithm for intelligent reminder, as a prior before training Large Language Model.
  
2. Work for the team
   - Aggregate codes from all team members.
   - Offer ideas and suggestions.
   - Simulate, test and debug.


#### Coding

1. Intelligent Reminder
   - Synchronize the calendar events which needs to be reminded to reminder.
   - Based on the duration, title, tag and some other features of the events in the reminder, calculate reminding time using Large Language Model.
   - Delete reminders after being marked as done.
   - Notify the user when the reminding time is coming and delete the notification when marking reminders as done.

**Ruiqi Xu:** UI/UX Design
#### Design

1. Overall UX Flow Design
   - Conducted user research to understand the needs and pain points of the target audience.
   - Created detailed wireframes and flowcharts to map out the user journey and interactions.
   - Conducted usability testing to gather feedback and refine the UX flow, ensuring a seamless and intuitive experience for users.

2. Overall UI Prototype Design
   - Designed high-fidelity UI prototypes using industry-standard tool Figma.
   - Focused on creating a visually appealing and consistent interface that aligns with the branding guidelines.
   - Ensured accessibility standards were met, making the application usable for people.
   - Iterated on the design based on user feedback and testing results to optimize the user interface.
   - Collaborated with developers to ensure the feasibility of the design and smooth transition from prototype to implementation.

#### Coding

1. Front-End Implementation (SwiftUI)
   - Developed the entire front-end of the application using SwiftUI, Apple's framework for building user interfaces.
   - Implemented complex UI components to enhance user engagement and satisfaction.
   - Implemented basic CRUD functions and user interactions in the front-end.
   - Collaborated with the back-end team to define API requirements and troubleshoot integration issues.

**Xin Gong:** Team leader, AI agent, contact-AI application


#### Design
1. Team Leader
   - Proposed the general idea and vision for the project.
   - Monitor and assign tasks for all teammates for the project.
2. Engine
   - Wrote program architecture document for the project
   - Led the development and testing of the AI chat function.
   - Performed extensive testing to validate the application's functionality and user experience.
   - Established the OpenAI API connection for seamless integration with the chat interface.


#### Coding
1. AI Agent
   - Designed the conversational logic and natural language processing capabilities for the chat function.
   - Developed algorithms to extract contact and event information from user queries through chat.
   - Ensure accurate data retrieval and insertion into the database.
   - Analyzed chat inputs to connect instructions to the Events and Contacts database for data insertion and querying.
   - Integrated LLM capabilities to enhance the chatbot's responses and contextual understanding.

2. Contact-AI Application
   - Coordinated with the AI agent to enable seamless integration of AI-driven insights into the application.
   - Finding each contacts's attended events with SQL
   - Udating Contact's description with LLM to natural language.


**Yan Lu:** Calendar Function

# Getting Started

# Contact and Schedule Manager App

This iOS app allows users to manage contacts and schedules by interacting with a natural language interface powered by ChatGPT. It supports adding new contacts, reminders and schedules to a local database and querying existing information through conversational commands.

## Features

- **Contact Management:** Add, view, and search contacts using natural language.
- **Schedule Management:** Create, view, and search schedules using natural language.
- **AI Integration:** Utilize ChatGPT to parse and understand natural language inputs.

## Requirements

- **iOS 14.0** or later
- **Xcode 12.0** or later
- **Swift 5.0**
- **OpenAI API Key**

## Setup

### Prerequisites

1. **Xcode Installation:**
   - Download and install Xcode from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835).
   - For detailed instructions on setting up Xcode, refer to [Apple's official documentation](https://developer.apple.com/support/xcode/).

2. **OpenAI API Key:**
   - Sign up or log in to [OpenAI](https://beta.openai.com/docs/) to obtain your API key.
   - Ensure that your API key is set up in the app's corresponding required file (`ChatView.swift`,`ContactView.swift`,`MemoOpenAI.swift`).

3. **FMDB Package:**
   - This app uses [FMDB](https://github.com/ccgus/fmdb) for database management.
   - You can add FMDB to your project using Swift Package Manager:
     - In Xcode, go to `File > Swift Packages > Add Package Dependency`.
     - Enter the FMDB repository URL: `https://github.com/ccgus/fmdb`.
     - Follow the prompts to add the package to your project.

### Project Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/selinag23/AIive.git
   
2. **Open the Project in Xcode:**

Navigate to the project directory and open ContactScheduleManager.xcodeproj.

3. **Configure OpenAI API Key:**

Replace all placeholder with your OpenAI API key in `ChatView.swift`,`ContactView.swift`,`MemoOpenAI.swift`.

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


# APIs and Database Controller

> Describe how your front-end would communicate with your engine: list and describe your APIs. This is only your initial design, you can change them again later, but you should start thinking about and designing how your front end will communicate with your engine. If you're using existing OS subsystem(s) or 3rd-party SDK(s) to implement your engine, describe how you will interact with these.


### Overview

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

**Future might use:**
**Google Cloud Speech-to-Text API**
- **Description**: Converts audio to text using Google's powerful neural network models.
- **Interaction**: The app will use this API to convert user voice inputs into text, which can then be processed by the AI agent.

**Microsoft Azure Speech API**
- **Description**: Converts spoken audio to text, translates spoken languages, and synthesizes speech from text.
- **Interaction**: Similar to Google Cloud Speech-to-Text, this API will be used to handle voice inputs and outputs within the app.





# View UI/UX

Designing the UI/UX for an AI agent that manages calendar, reminders, contacts, and memos, while adhering to iOS system guidelines, requires a focus on simplicity, style, and ease of use. The interface should leverage iOS's clean and minimalistic aesthetic, ensuring that users can navigate effortlessly. Key features like the calendar should present a clear and concise view of events, with easy-to-use navigation and quick access to detailed event information. Reminders should be visually distinct, utilizing simple toggles and intuitive input methods to set and manage tasks. Contacts should be organized in a clean, searchable format, with prominent action buttons for calling, messaging, or emailing. For memos, a sleek, note-taking interface with rich text support and organizational tools like folders or tags is essential. Throughout the design, consistent typography, spacing, and color schemes should be maintained to ensure a cohesive and stylish user experience, aligning with Apple's Human Interface Guidelines. This approach not only enhances usability but also ensures that the AI agent feels like a natural extension of the iOS ecosystem. The UI/UX design draft is shown below and the final product will show some minor changes but stick to the overall workflow and design.
![[UI/UX protytpe](UI/UX.png)](https://github.com/selinag23/AIive/blob/main/UI%3AUX.png)



