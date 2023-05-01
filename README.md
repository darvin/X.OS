# X.OS

Automate your Mac usage and increase productivity with **X.OS**. This macOS application uses advanced technology to help you streamline your workflow and save time. 



https://user-images.githubusercontent.com/309302/233943279-dc01f291-ca41-4ca9-8fcd-3cb9b658ed66.mp4

## Research

### Segment Anything Screenshot Inference
<img width="874" alt="Screenshot 2023-05-02 at 1 39 24 AM" src="https://user-images.githubusercontent.com/309302/235544099-ba077ee3-2809-4113-b736-fb3432e0c77b.png">
<img width="729" alt="Screenshot 2023-05-02 at 1 33 15 AM" src="https://user-images.githubusercontent.com/309302/235544126-08b54ed1-ae4c-41f8-8122-4071ec1ca882.png">

<img width="809" alt="Screenshot 2023-05-02 at 1 41 34 AM" src="https://user-images.githubusercontent.com/309302/235544150-b2e9ed19-e5be-4f06-967d-623d635d5c3e.png">

([more game inference](https://github.com/darvin/X.RetroGameAIRemaster/blob/main/README.md#segment-anything-screenshot-inference))


### Papers
- [An Empirical Investigation into the Use of Image Captioning for Automated Software Documentation](https://arxiv.org/pdf/2301.01224.pdf)
- [Screen2Vec: Semantic Embedding of GUI Screens and GUI Components](https://arxiv.org/pdf/2101.11103.pdf)
- [ScreenSeg: On-Device Screenshot Layout Analysis](https://arxiv.org/pdf/2104.08052.pdf)
- [Screen Parsing: Towards Reverse Engineering of UI Models from Screenshots](https://arxiv.org/pdf/2109.08763.pdf)
- [ScreenQA: Large-Scale Question-Answer Pairs Over Mobile App Screenshots](https://arxiv.org/pdf/2209.08199.pdf)
- [Scrapbook: Screenshot-Based Bookmarks for Effective Digital Resource Curation across Applications](https://arxiv.org/pdf/2209.12318.pdf)
- [Detecting and Summarizing GUI Changes in Evolving Mobile Apps](https://arxiv.org/pdf/1807.09440.pdf) *old but gold*
- [DroidBot-GPT: GPT-powered UI Automation for Android](https://arxiv.org/pdf/2304.07061v1.pdf)
- [Lexi: Self-Supervised Learning of the UI Language](https://arxiv.org/pdf/2301.10165v1.pdf)
- [Widget Captioning: Generating Natural Language Description for Mobile User Interface Elements](https://arxiv.org/pdf/2010.04295.pdf)
- [Interactive Task Learning from GUI-Grounded Natural Language Instructions and Demonstrations](https://aclanthology.org/2020.acl-demos.25.pdf)
- [Mapping Natural Language Instructions to Mobile UI Action Sequences](https://arxiv.org/pdf/2005.03776v2.pdf)
- [Fill in the Blank: Context-aware Automated Text Input Generation for Mobile GUI Testing](https://arxiv.org/pdf/2212.04732.pdf)
- [Understanding Mobile GUI: from Pixel-Words to Screen-Sentences](https://arxiv.org/pdf/2105.11941.pdf)
- [Text Extraction and Retrieval from Smartphone Screenshots: Building a Repository for Life in Media](https://arxiv.org/pdf/1801.01316.pdf) *old*
- [GUESS WHAT’S ON MY SCREEN? CLUSTERING SMARTPHONE SCREENSHOTS WITH ACTIVE LEARNING](https://arxiv.org/pdf/1901.02701.pdf) *old*
- [On-Device Information Extraction from Screenshots in form of tags](https://arxiv.org/pdf/2001.06094.pdf)
- [Help, It Looks Confusing: GUI Task Automation Through Demonstration and Follow-up Questions](https://arxiv.org/pdf/1611.03906.pdf) *very old*

### Datasets
 - [Clarity](https://sagelab.io/Clarity/)
 - [UI images paired with descriptions of their functionality](https://github.com/microsoft/uicaption)
 
 ### Similiar projects
 
  - [SUGILITE](https://github.com/tobyli/Sugilite_development)  is a programming-by-demonstration (PBD) system for Android
    - [Towards Effective Human-AI Collaboration in GUI-Based Interactive Task Learning Agents](https://arxiv.org/pdf/2003.02622.pdf)
  - [Seq2act](https://github.com/deepneuralmachine/seq2act-tensorflow)

## Features

1. Interactive tutorials
2. Request chat with GPT-3
3. Workflow annotation
4. Time logging and machine learning

### Interactive tutorials

Struggling to figure out how to do something on your Mac? No worries. With X.OS, you can request interactive tutorials for specific tasks. Simply type in your query, and the application's Language Model will generate a step-by-step tutorial with optional auto-clicking. You'll be a Mac pro in no time!

### Request chat with GPT-3

Get help with anything by requesting a chat with GPT-3. X.OS will take a screenshot of your current screen and send it to the Language Model, which will generate a response based on the content of the screen. This feature allows you to quickly get answers to any questions you have while working on your Mac.

### Workflow annotation

With the workflow annotation feature, you can log your time and annotate your workflow. This data is then used for machine learning purposes to optimize your workflow and suggest more efficient ways of performing tasks.

### Time logging and machine learning

X.OS logs all text that appears on your screen, including windows and user actions. This data is stored in a vector database, enabling you to search and analyze your usage history with ease. With the help of machine learning algorithms, X.OS can identify patterns in your usage history and suggest the most efficient ways to perform tasks.



## Implementation Details

X.OS is a macOS application developed with SwiftUI. It utilizes the ScreenCaptureKit and Vision framework to scrape text from the screen of the Mac computer, logs all text into a vector database. The Language Model is used to generate interactive tutorials and chat responses for specific tasks. Time logging and workflow annotation are implemented to optimize your workflow and suggest more efficient ways of performing tasks.


## Use cases

User wants to summarize text displayed on the screen. To do so, they press the X.OS hotkey and enter "summarize this". X.OS utilizes ChatGPT to summarize the text on the screen and saves the original text, summarization, and user's request into a database. It also copies the summarization to the clipboard and displays a notification indicating that the summarization has been copied to the clipboard.

User wants to learn how to make the background in Photoshop blurred. They press the X.OS hotkey and enter their query. X.OS responds by providing a step-by-step tutorial that includes visual markers highlighting the relevant menu items, buttons, and text fields necessary to achieve the desired effect. Additionally, X.OS can automate the clicking of certain UI elements if desired.

User is managing their Gmail in Chrome and is manually extracting phone numbers and names from emails and entering them into a Google Spreadsheet. After extracting information from the third email, X.OS prompts the user with a message: "I've noticed that you are extracting phone numbers and names from your Gmail inbox into a Google Spreadsheet. Would you like me to help with that?" If the user agrees, X.OS will repeat this action for subsequent emails, with the user only needing to press the 'Enter' key to process each email. The extracted information is then automatically added to the designated spreadsheet.



User is browsing a website in Safari and wants to extract data from a table. User presses the X.OS hotkey and enters "extract table data". X.OS captures the screen, identifies the table, and extracts the data into a CSV in clipboard. It also logs the table and data for future reference.

*User is writing a research paper and needs to gather information from various sources. They open multiple tabs in Chrome and start reading through them. X.OS detects that the user is researching a specific topic and starts to automatically highlight important sentences and paragraphs using natural language processing techniques. The user can then review the highlighted text and copy it to their document with a single click.*

*User is a content creator who spends a lot of time researching topics for their work. X.OS can automatically detect when the user is doing research by analyzing the text on the screen, and then capture the text and log it along with the source application and any relevant window titles. This data can then be used to create a database of research material that can be easily searched and referenced in the future. Additionally, X.OS can be set up to automatically extract important information from the captured text, such as URLs, names, and keywords, and log them separately for easier searching and categorization.*


*User is a data analyst who frequently copies and pastes data from one application to another. X.OS can automatically detect when the user has copied data to the clipboard and log the data along with the context, such as the source application and any relevant window titles. This data can then be analyzed using machine learning techniques to identify patterns in the user's workflow and suggest automation solutions.*


*User is watching a tutorial video on YouTube and needs to take notes on the content. User presses the X.OS hotkey and enters "capture screen and take notes". X.OS captures a screenshot of the video and opens up a new note-taking app, pre-populated with the video's title and URL, along with the timestamp of the screenshot. The user can then take notes on the content while referencing the captured screenshot.*

*User needs to extract specific data from a large text file. They activate the v hotkey and enter the search parameters, such as "all instances of dates in the format DD/MM/YYYY". X.OS highligths on the screen requested data, making it easy for the user to see the information they need.*


*User is working on a design project in Adobe Illustrator and needs to translate some text from English to Spanish. User selects the text and presses the X.OS hotkey, then enters "translate to Spanish". X.OS translates text and replaces it.*

*User is collaborating on a document with colleagues and wants to ensure that the text is consistent in tone and style. They activate the X.OS hotkey and enter the "style guide check" command. X.OS analyzes the text for adherence to the company's style guide and suggests changes as needed.*

*User is creating a presentation in Keynote and wants to make sure that their text is easy to read for their audience. They activate the X.OS hotkey and enter the "readability check" command. v analyzes the text for readability and displays a score along with any suggestions for improvement.*





*User is writing a piece of code and wants to ensure that it adheres to best practices and standards. They activate the X.OS hotkey and enter the "code review" command. X.OS analyzes the code for adherence to best practices and standards, and suggests improvements or changes as needed. It can also provide links to relevant documentation or tutorials for further learning.*




*User is working on a project that involves frequent communication with team members. They activate the X.OS hotkey and enter the "team communication" command. X.OS opens a chat window or communication platform and pre-populates it with the relevant team members and project information. It can also suggest meeting times based on everyone's schedules.*

*User needs to schedule a meeting with colleagues who work in different time zones. They activate the X.OS hotkey and enter the "time zone converter" command. X.OS displays a time zone converter tool, where the user can input the meeting time and the time zones of the attendees to find a time that works for everyone.*

*User is a writer who frequently uses a thesaurus. They activate the X.OS hotkey and enter the "thesaurus" command. X.OS displays a thesaurus tool, where the user can input a word and find synonyms and antonyms.*

*User is working on a spreadsheet and wants to quickly format the data. They activate the X.OS hotkey and enter the "format data" command. X.OS displays a menu of formatting options, such as currency, date, and percentage formats, and applies the selected format to the data.*

*User is working on a design project and wants to find inspiration. They activate the X.OS hotkey and enter the "design inspiration" command. X.OS displays a selection of design inspiration websites, such as Dribbble or Behance, for the user to browse.*

*User needs to send an email to multiple recipients. They activate the X.OS hotkey and enter the "send group email" command. X.OS opens a new email window and pre-populates it with the selected recipients, and can also suggest a subject line and email content based on previous email templates.*

*User is working on a task that involves repetitive actions. They activate the X.OS hotkey and enter the "task automation" command. X.OS can automate the repetitive task using macros or scripting, freeing up the user's time for more valuable work.*

*User needs to perform a calculation quickly. They activate the X.OS hotkey and enter the "calculator" command. X.OS displays a calculator tool for the user to perform the calculation.*

*User is a language learner and needs to practice their vocabulary. They activate the X.OS hotkey and enter the "flashcards" command. X.OS displays a flashcard tool with the user's selected vocabulary, and can provide prompts for the user to practice writing or speaking the words.*

*User is working on a document and wants to quickly find and replace certain words or phrases. They activate the X.OS hotkey and enter the "find and replace" command. X.OS displays a find and replace tool, where the user can input the word or phrase to be replaced and the replacement text.*




