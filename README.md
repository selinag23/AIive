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

### Data Flow
![db](https://github.com/selinag23/AIive/assets/116231204/beaa2d5a-ecfc-4964-8fe2-50164c925af9)


# APIs and Controller

> Describe how your front-end would communicate with your engine: list and describe your APIs. This is only your initial design, you can change them again later, but you should start thinking about and designing how your front end will communicate with your engine. If you're using existing OS subsystem(s) or 3rd-party SDK(s) to implement your engine, describe how you will interact with these.

**Request Parameters**
| Key        | Location | Type   | Description      |
| ---------- | -------- | ------ | ---------------- |
| `username` | Session Cookie| String | Current User |

**Response Codes**
| Code              | Description            |
| ----------------- | ---------------------- |
| `200 OK`     | Success                |
| `400 Bad Request` | Invalid parameters     |

**Returns**

*If no user is logged in or no posts created by user*
| Key        | Location       | Type   | Description  |
| ---------- | -------------- | ------ | ------------ |
| `popular_songs` | JSON | List of Spotify Track IDs | Top 25 songs on Spotify in the United States |

*For logged-in users with 1 or more posts created*
| Key        | Location       | Type   | Description  |
| ---------- | -------------- | ------ | ------------ |
| `attribute_recommendations` | JSON |List of Spotify Track IDs | Attribute-based recommendations (random genres) |
| `genre_recommendations` | JSON | List of Spotify Track IDs | Attribute and genre-based recommendations based on user's favorite genres |
| `artist_recommendations` | JSON | List of Spotify Track ID | Attribute and artist-based recommendations based on user's favorite artists | 
| `attribute_error` | JSON | Dictionary | contains the average error % for each attribute between recommendation and the user's attribute vector. | 

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
