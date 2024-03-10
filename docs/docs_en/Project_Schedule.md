> This document was generated with the assistance of OpenAI GPT-4, for reference [link](https://chat.openai.com/).
# GPT4DST Complete Project Plan
![BG](../../assets/DSTBG_1.png )
## Project Overview
<!-- ![BG](../assets/logo_1.jpg) -->
### Background

GPT4DST is a secondary development application based on the langchain library calling OpenAI's GPT closed source model. The project aims to provide an intelligent interactive experience for the Don't Starve Together (DST) game by developing specialized mods to interact with players.

### Goals

- Develop an intelligent interaction mod based on the GPT model, integrated into the DST game.
- Deploy the application on Alibaba Cloud ECS and publish API interfaces for game mods to call.
- Implement natural language interaction with players to enhance the gaming experience.

## Solution Design

### Technology Stack

- **Programming Languages**: Python (for main application development), Lua (for DST mod development)
- **Frameworks and Libraries**: langchain (for calling the OpenAI GPT model), FastAPI (for API services)
- **Code Collaboration Tools**: GitHub
- **Server Environment**: Alibaba Cloud ECS (Elastic Compute Service)

### Architectural Design (Reference)

This project includes two main parts: a Python-based backend service and a Lua-based DST game mod. The backend service is responsible for interacting with the GPT model and processing logic, while the game mod is responsible for interacting with players and calling the backend API for responses.

```
GPT4DST/
│
├── app/ # Main application directory
│ ├── init.py # Initialize the application
│ ├── main.py # FastAPI application instance and routes
│ ├── dependencies.py # Define dependencies
│ ├── models.py # Data model definitions
│ ├── schemas.py # Request and response models
│ ├── crud.py # Database CRUD operations
│ └── routers/ # Routing directory
│   ├── init.py
│   ├── interaction.py # DST interaction interface routes
│   └── ... # Other routing files
│
├── tests/ # Testing directory
│ ├── init.py
│ ├── test_main.py # Main test file
│ └── ... # Other test files
│
├── docs/ # Documentation directory
│
├── .env # Environment variable file
├── .gitignore # Git ignore file
├── requirements.txt # Project dependencies
├── Dockerfile # Docker configuration file
├── docker-compose.yml # Docker compose configuration (optional)
└── README.md # Project README
```

<details>
<summary>View detailed explanation</summary>

- **app/**: The core directory of the application, containing all the main Python code.
  - **main.py**: Defines the FastAPI application instance and routes, serving as the entry point of the application.
  - **dependencies.py**: Defines the dependencies required for the project, such as database connections and query parameters.
  - **models.py**: Defines data models, typically used for ORM.
  - **schemas.py**: Defines Pydantic models for requests and responses, used for data validation and serialization.
  - **crud.py**: Defines CRUD operations for the database, abstracting database interactions.
  - **routers/**: Contains files that define various API routes, such as `interaction.py`, which handles API routes related to DST interaction.

- **tests/**: Directory containing unit and integration tests for the application.

- **docs/**: Directory for storing project documentation, which can include documentation generated with Sphinx.

- **.env**: Contains environment variables that should not be made public, such as API keys and database URIs.

- **requirements.txt**: Lists all project dependencies, which can be installed using `pip install -r requirements.txt`.

- **Dockerfile** and **docker-compose.yml**: Used for containerizing the application and services, simplifying the deployment process.

- **README.md**: Provides an overview of the project, installation and usage instructions, and contribution guidelines.

</details>

### Interface Design

The API will provide the following endpoints:

- `/interact`: Receives player input from the game and returns a response from the GPT model.

  - **Method**: POST
  - **Parameters**:
    - `player_input`: Player's input in the game
  - **Return Value**:
    - `model_response`: Response from the GPT model based on player input

## Development and Collaboration Process

See the [document](./Collaboration_Manual.md) in the same directory for details.

## Deployment and Publishing

### Server Configuration

- Choose an Alibaba Cloud ECS instance, such as ecs.g5.large, and install Ubuntu 20.04, ensuring there is sufficient storage and bandwidth to meet the requirements.

### Deployment Process

- Set up the Alibaba Cloud ECS instance and install necessary environments and dependencies.
- ~~Pull the latest code from the `main` branch on GitHub to the ECS instance.~~
- ~~Use Uvicorn as the ASGI server, in conjunction with Nginx as the reverse proxy server, to deploy the FastAPI application.~~
- Set environment variables, including OpenAI API keys, etc.

### Continuous Integration/Continuous Deployment (CI/CD)

- ~~Configure GitHub Actions to automatically deploy to Alibaba Cloud ECS when code is merged into the `main` branch.~~

## Risk Management

### Risk Identification

- OpenAI GPT model call restrictions and costs.
- Network latency and stability between the game mod and backend service.

### Risk Mitigation

- Optimize API call frequency and introduce caching mechanisms.
- Choose the appropriate ECS instance to ensure a good connection with the game server.

## Appendix

### A. Glossary

- **LLM**: Large Language Model
- **DST**: Don't Starve Together
- **API**: Application Programming Interface

### B. References

- [OpenAI](https://openai.com)
- [Langchain official documentation](https://python.langchain.com/docs/)
- [FastAPI official documentation](https://fastapi.tiangolo.com/)

