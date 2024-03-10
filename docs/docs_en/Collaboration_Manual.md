# GPT4DST Project Collaboration Manual

> This document was assisted by OpenAI GPT-4, for reference [link](https://chat.openai.com/).

## Setting Up Development Environment

### Software Requirements

- **Python Version**: Python 3.8.
- **IDE**: VS Code/PyCharm.
- **Dependency Management**: Use `pip` with `virtualenv`, or manage dependencies within a `docker` environment.

### Environment Setup

<details>
<summary>pip+virtualenv</summary>

- Clone the project repository:

   ```bash
   git clone https://github.com/Bili-Sakura/GPT4DST.git
   cd GPT4DST
   ```
- Create and activate a virtual environment:

   ```bash
   python -m venv .venv/gpt4dst  
   source .ven/gpt4dst/bin/activate  # Unix-like systems
   .\.venv\gpt4dst\Scripts\activate  # Windows
   ```  
- Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```
- To deactivate the virtual environment:

   ```bash
   .\.venv\gpt4dst\Scripts\deactivate
   ```
  
</details>

<details>
<summary>docker</summary>

- Clone the project repository:

   ```bash
   git clone https://github.com/Bili-Sakura/GPT4DST.git
   cd GPT4DST
   ```
- Install `Docker`

   **Installation guide for Linux systems:**

   1. Update package index and install necessary dependencies:
      ```
      sudo apt update
      sudo apt install apt-transport-https ca-certificates curl software-properties-common
      ```

   2. Add Docker's official GPG key:
      ```
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      ```

   3. Set up the stable repository for Docker:
      ```
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      ```

   4. Install Docker:
      ```
      sudo apt update
      sudo apt install docker-ce
      ```

   5. Verify the installation:
      ```
      sudo systemctl status docker
      ```

   **Installation guide for Windows systems:**

   1. Download the Docker Desktop installer: [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

   2. Double-click the installer and follow the prompts to install.

   3. Start the Docker Desktop application.

   4. Verify the installation by opening a command prompt (CMD) or PowerShell and running:
      ```
      docker --version
      ```

- Create/check the `Dockerfile`:

   ```dockerfile
   # Use the official Python runtime as a parent image
   FROM python:3.8

   # Set the working directory to /app
   WORKDIR /app

   # Copy the current directory contents into the container at /app
   COPY . /app

   # Install any needed packages specified in requirements.txt
   RUN pip install --no-cache-dir -r requirements.txt

   # Make port 80 available to the world outside this container
   EXPOSE 80

   # Define environment variable (optional)
   # ENV NAME GPT4DST

   # Run app.py when the container launches
   CMD ["python", "app.py"]
   ```
   
- Using `docker`:  

   ```bash
   # Build the Docker image
   docker build -t gpt4dst .
   # Run the Docker container
   docker run -p 4000:80 gpt4dst
   ```

Here, `gpt4dst` is the name chosen for the image. The `docker build` command builds the image, where the `-t` flag tags or names your image. The `docker run` command starts a new container, with the `-p` flag mapping the container's port to a port on the host, in the format `<host-port>:<container-port>`.
</details>

## GitHub Collaboration Workflow

<details>
<summary>Handling virtual environments and Git collaboration</summary>

- Use `.gitignore`: Add your virtual environment folder to the project's `.gitignore` file so Git ignores it and doesn't include it in version control. For example, if your virtual environment is named gpt4dst, just add the following line to the `.gitignore` file:

   ```
   gpt4dst/
   ```

- Share `requirements.txt`: Ensure the `requirements.txt` file is included in Git version control. This allows team members to create and activate their own virtual environments and install all necessary dependencies.

   ```bash
   pip freeze > requirements.txt # Update environment dependencies
   ```
</details>

### Branch Strategy

- Main branch `main`: Contains the latest stable version for production.
- Development main branch `dev`: The latest stable version for daily development.
- Development branch for dev/TeamMember1: Development branch for TeamMember1.
- Development branch for dev/TeamMember2: Development branch for TeamMember2.
- ~~Feature branches feature/<feature-name>: Branched off dev, used for developing new features.~~
- ~~Fix branches fix/<fix-name>: Branched off dev, used for bug fixes.~~

### Basic Commit Syntax

<details>
<summary>View detailed explanation</summary>

A well-structured commit message can clearly describe the purpose and scope of changes, aiding team members in understanding and tracking project progress. A good commit message should follow this basic format:

```
<type>(<scope>): <description>
```

- **Type**: A keyword that signifies the purpose of the commit, such as `fix`, `feat`, `docs`, etc.
- **Scope**: An optional field that indicates the part of the project affected by the changes.
- **Description**: A brief and clear explanation of the changes made.

### Common Commit Types and Examples

Here are some common commit types along with corresponding examples:

- **Bug Fix**: The `fix` type is used for fixing bugs within the project.
  - Example: `fix(login): resolve login issue due to caching`
- **New Feature**: The `feat` type is used to introduce new features or functionalities.
  - Example: `feat(chart): add data visualization charts`
- **Documentation Change**: The `docs` type is used for updates to the project documentation.
  - Example: `docs(readme): update installation instructions`
- **Performance Improvement**: The `perf` type is used for code performance improvements.
  - Example: `perf(db): enhance database query efficiency`
- **Code Style**: The `style` type is used for changes that do not affect the meaning of the code (whitespace, formatting, missing semicolons, etc.).
  - Example: `style(format): format code`

</details>

### Multi-file Commit Syntax

<details>
<summary>View detailed explanation</summary>

When updating multiple files and each requires a different commit message, you can add and commit these files individually:

```bash
# Add and commit the first file
git add <path-to-file1>
git commit -m "<type1>(<scope1>): <description1>"

# Add and commit the second file
git add <path-to-file2>
git commit -m "<type2>(<scope2>): <description2>"

# Repeat the steps above until all files are processed
```
</details>

### Code Collaboration Workflow and Commands

<details>
<summary>View detailed explanation</summary>

1. **Clone the Repository**: Clone the project from the remote repository to your local machine.
   ```bash
   git clone <repository-URL>
   ```
2. **Create a New Branch**: Create a new working branch based on the latest main branch.
   ```bash
   git checkout -b <new-branch-name>
   ```
3. **Commit Changes**: After development is complete, commit the changes to the local repository.
   ```bash
   git add .
   git commit -m "<type>: <description>"
   ```
4. **Sync Remote Changes**: Regularly pull the latest changes from the remote repository to keep your local branch updated.
   ```bash
   git pull origin <base-branch>
   ```
5. **Push Branch**: Push your local branch to the remote repository.
   ```bash
   git push origin <branch-name>
   ```
~~6. **Create a Merge Request (MR/PR)**: Create a merge request in the remote repository, requesting to merge your changes into the base branch.~~

</details>

## Coding Standards

> Use Pylint - PEP 8

<details>
<summary>View detailed explanation</summary>

### Introduction to Pylint

Pylint is a Python static code analysis tool used to identify programming errors, help enforce coding standards, and recommend refactoring. Pylint offers multiple features, including checking for errors in the code, enforcing coding standards, identifying code smells, and suggesting improvements.

### Key Features of Pylint

- **Error Detection**: Pylint can identify syntax errors, runtime errors, inconsistent naming conventions, and more.
- **Enforcement of Coding Standards**: Pylint adheres to the PEP 8 coding standard by default and allows for custom rule configurations.
- **Code Quality Score**: Pylint assigns a score from 0 to 10 to the code, helping developers identify parts that may need refactoring.

### Configuring Pylint in VSCode

To use Pylint in VSCode, follow these steps:

1. **Install Pylint**:
   If you haven't installed Pylint yet, you can install it via pip in your Python environment:
   ```bash
   pip install pylint
   ```

2. **Install Python Extension**:
   Ensure the Python extension for VSCode is installed. You can find it in the VSCode extension marketplace by searching for "Python" and installing the extension provided by Microsoft.

3. **Configure Pylint**:
   The Python extension for VSCode will automatically find and use Pylint if it's installed. You can customize Pylint's behavior at the project level by creating or editing the `.vscode/settings.json` file.

   Open or create the `.vscode/settings.json` file and add the following configuration:

   ```json
   {
   "pylint.args": [
      "--disable=C0111" // For example, to disable warnings for missing function docstrings
      // Add other Pylint arguments here
   ]
   }
   ```

4. **Using Pylint**:
   After saving all changes, Pylint will automatically run on Python files you open. If Pylint finds any issues, they will be displayed in the "Problems" panel of VSCode and highlighted directly in the editor.

5. **Customizing Pylint Rules**:
   You can create a `pylintrc` file in the project's root directory to customize Pylint rules. For example:

   ```bash
   pylint --generate-rcfile > .pylintrc
   ```

   This will generate a default configuration file that you can edit as needed.

### Introduction to PEP 8 Coding Standards (Optional Reading)
> Already integrated into Pylint
PEP 8 is the official coding style guide for Python, aimed at improving the readability and consistency of Python code. Here are some key points from the PEP 8 coding standards:

#### Indentation

- Use 4 spaces per indentation level.
- Continued lines should align with the wrapped element, either by using Python's implicit line joining inside parentheses, brackets, and braces, or by using a hanging indent.

#### Maximum Line Length

- Limit all lines to a maximum of 79 characters to facilitate reading on small displays and allow for multiple code files to be viewed side by side.
- Long expressions can be broken over multiple lines by wrapping them in parentheses and adding extra indentation to improve readability.

#### Whitespace

- Use a single space around binary operators such as assignment (`=`), comparisons (`==`, `<`, `>`, `!=`, `<=`, `>=`, `in`, `not in`, `is`, `is not`), and booleans (`and`, `or`, `not`).
- Separate items with a space after a comma.
- Do not add extra spaces inside parentheses, brackets, or braces used for function calls, indexing or slicing.

#### Comments

- Comments should be complete sentences. If a comment is a phrase or a sentence, its first word should be capitalized, unless it begins with an identifier that starts with a lowercase letter.
- When using inline comments, ensure there is at least a two-space gap between the comment and the code statement.

#### Naming Conventions

- Function names and variable names should use lowercase letters with underscores between words (`snake_case`).
- Class names should follow the capitalization convention (`CamelCase`).
- For protected instance attributes, use a single leading underscore (`_variable`).
- For private instance attributes, use two leading underscores (`__variable`).

#### Imports

- Imports should always be placed at the top of the file.
- Each import should be on a separate line.
- Imports should be grouped in the following order:
  1. Standard library imports.
  2. Related third-party imports.
  3. Local application/library specific imports.

  Add a blank line between each group of imports.

#### Whitespace in Expressions and Statements

- Avoid extraneous whitespace in the following situations: inside parentheses, brackets, or braces, between a trailing comma and a following close parenthesis, immediately before a comma, semicolon, or colon.

#### Programming Recommendations

- Avoid using complex expressions, even if the expression could be written in one line. For readability, it's better to split them into multiple lines.
- Avoid using `else` blocks after `if`, `for`, `while` statements that contain a `break` or `return`.

#### More

This is just a brief overview of some PEP 8 guidelines. For the complete guide, please refer to [PEP 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/).

</details>

## Documentation
- Use the `README.md` file, which is intended for users, to provide an overview of the project and installation instructions.
- Use docstrings in the code to thoroughly document the purpose and parameters of functions and classes.
- Store project collaboration and development-related documents in the `docs` directory, intended for developers.

## Continuous Integration/Continuous Deployment (CI/CD)
- ~~Configure GitHub Actions or other CI/CD tools to automatically run tests.~~
- ~~Set up an automatic deployment process to deploy the code from the `main` branch to the production environment.~~


