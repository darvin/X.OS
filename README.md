# OSXLogger

Automate your Mac usage and increase productivity with **OSXLogger**. This macOS application uses advanced technology to help you streamline your workflow and save time. 

## Features

1. Interactive tutorials
2. Request chat with GPT-3
3. Workflow annotation
4. Time logging and machine learning

### Interactive tutorials

Struggling to figure out how to do something on your Mac? No worries. With OSXLogger, you can request interactive tutorials for specific tasks. Simply type in your query, and the application's Language Model will generate a step-by-step tutorial with optional auto-clicking. You'll be a Mac pro in no time!

### Request chat with GPT-3

Get help with anything by requesting a chat with GPT-3. OSXLogger will take a screenshot of your current screen and send it to the Language Model, which will generate a response based on the content of the screen. This feature allows you to quickly get answers to any questions you have while working on your Mac.

### Workflow annotation

With the workflow annotation feature, you can log your time and annotate your workflow. This data is then used for machine learning purposes to optimize your workflow and suggest more efficient ways of performing tasks.

### Time logging and machine learning

OSXLogger logs all text that appears on your screen, including windows and user actions. This data is stored in a vector database, enabling you to search and analyze your usage history with ease. With the help of machine learning algorithms, OSXLogger can identify patterns in your usage history and suggest the most efficient ways to perform tasks.

## Use cases

User wants to summarize text displayed on the screen. To do so, they press the OSXLogger hotkey and enter "summarize this". OSXLogger utilizes ChatGPT to summarize the text on the screen and saves the original text, summarization, and user's request into a database. It also copies the summarization to the clipboard and displays a notification indicating that the summarization has been copied to the clipboard.

User wants to learn how to make the background in Photoshop blurred. They press the OSXLogger hotkey and enter their query. OSXLogger responds by providing a step-by-step tutorial that includes visual markers highlighting the relevant menu items, buttons, and text fields necessary to achieve the desired effect. Additionally, OSXLogger can automate the clicking of certain UI elements if desired.

User is managing their Gmail in Chrome and is manually extracting phone numbers and names from emails and entering them into a Google Spreadsheet. After extracting information from the third email, OSXLogger prompts the user with a message: "I've noticed that you are extracting phone numbers and names from your Gmail inbox into a Google Spreadsheet. Would you like me to help with that?" If the user agrees, OSXLogger will repeat this action for subsequent emails, with the user only needing to press the 'Enter' key to process each email. The extracted information is then automatically added to the designated spreadsheet.



User is browsing a website in Safari and wants to extract data from a table. User presses the OSXLogger hotkey and enters "extract table data". OSXLogger captures the screen, identifies the table, and extracts the data into a CSV in clipboard. It also logs the table and data for future reference.

User is writing a research paper and needs to gather information from various sources. They open multiple tabs in Chrome and start reading through them. OSXLogger detects that the user is researching a specific topic and starts to automatically highlight important sentences and paragraphs using natural language processing techniques. The user can then review the highlighted text and copy it to their document with a single click.

User is a content creator who spends a lot of time researching topics for their work. OSXLogger can automatically detect when the user is doing research by analyzing the text on the screen, and then capture the text and log it along with the source application and any relevant window titles. This data can then be used to create a database of research material that can be easily searched and referenced in the future. Additionally, OSXLogger can be set up to automatically extract important information from the captured text, such as URLs, names, and keywords, and log them separately for easier searching and categorization.


User is a data analyst who frequently copies and pastes data from one application to another. OSXLogger can automatically detect when the user has copied data to the clipboard and log the data along with the context, such as the source application and any relevant window titles. This data can then be analyzed using machine learning techniques to identify patterns in the user's workflow and suggest automation solutions.


User is watching a tutorial video on YouTube and needs to take notes on the content. User presses the OSXLogger hotkey and enters "capture screen and take notes". OSXLogger captures a screenshot of the video and opens up a new note-taking app, pre-populated with the video's title and URL, along with the timestamp of the screenshot. The user can then take notes on the content while referencing the captured screenshot.

User needs to extract specific data from a large text file. They activate the OSXLogger hotkey and enter the search parameters, such as "all instances of dates in the format DD/MM/YYYY". OSXLogger highligths on the screen requested data, making it easy for the user to see the information they need.


User is working on a design project in Adobe Illustrator and needs to translate some text from English to Spanish. User selects the text and presses the OSXLogger hotkey, then enters "translate to Spanish". OSXLogger translates text and replaces it.

User is collaborating on a document with colleagues and wants to ensure that the text is consistent in tone and style. They activate the OSXLogger hotkey and enter the "style guide check" command. OSXLogger analyzes the text for adherence to the company's style guide and suggests changes as needed.

User is creating a presentation in Keynote and wants to make sure that their text is easy to read for their audience. They activate the OSXLogger hotkey and enter the "readability check" command. OSXLogger analyzes the text for readability and displays a score along with any suggestions for improvement.






## Implementation Details

OSXLogger is a macOS application developed with SwiftUI. It utilizes the ScreenCaptureKit and Vision framework to scrape text from the screen of the Mac computer, logs all text into a vector database. The Language Model is used to generate interactive tutorials and chat responses for specific tasks. Time logging and workflow annotation are implemented to optimize your workflow and suggest more efficient ways of performing tasks.

## Requirements

- macOS 11.0 or later.
- Xcode 12.0 or later.

