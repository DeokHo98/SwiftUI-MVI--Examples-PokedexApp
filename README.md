# SwiftUI-MVI--Examples-PokedexApp
      
## Getting Started
- The app is a very simple example with three main features: a basic list, a filtering function for the list, and navigation to a detail screen.    
- The code was written as first-party as much as possible.     
- Test code is also included.    
- If you want to focus on the architecture, please pay attention to the PokemonModule.    
- architecture pattern may not be perfect and is not the definitive answer. I am a junior iOS developer with only two years of experience.    
- Feel free to open an issue if there's something missing or you'd like to discuss further.     
    
## Example App Photo
<p align="center">
  <img src="https://github.com/user-attachments/assets/d1eb833a-0735-4473-8504-b105fce2cc7a" width="450" height="800" alt="Simulator Screenshot - Clone 1 of iPhone 15 Pro - 2024-09-10 at 16 34 19">
</p>
    
## MVI (Model-View-Intent) OverView
MVI is one of the latest state management architecture patterns widely used in Android development.       
While MVI itself is not commonly used in iOS app development, architecture patterns that apply its concepts, such as ReactorKit and The Composable Architecture (TCA), are widely adopted.      
The roles of each component in MVI are as follows:     
    
### Model 
In MVVM or other architecture patterns, the Model serves as a link to the data from the server.      
In contrast, the MVI Model represents the state of the app. Therefore, it’s more common to refer to this as "State" rather than "Model."       
(Data models that serve as the actual data connection exist separately.)      
The state refers to various situations, such as when the app is loading data from the server, successfully completing a communication, or encountering a failure.      
    
In MVI, the Model is immutable. This immutability has several advantages.      
It is easy to predict. When the state is immutable, you can clearly see the differences from the previous state, making it easier to understand the flow of state changes.      
This also simplifies debugging. Furthermore, having both the previous and next states allows you to implement features like Undo/Redo.      
      
When the state is immutable, it guarantees that it cannot be modified elsewhere.      
By ensuring that state changes can only occur in functions that accept Intents and combine new states based on different situations, it prevents modifications from happening elsewhere.       
This reduces the risk of bugs caused by unexpected changes to the state due to mistakes.        
      
Finally, when the state is immutable, thread safety of the state is ensured. This eliminates the possibility of data races caused by multiple threads altering internal values.      
         
To maintain immutability in the project, we declared DexState as let, preventing it from being modified externally.      
Instead, we implemented a copy() method to allow state changes.       
Additionally, the state variable inside the ViewModel was declared as private(set) var, making it readable from the View but not modifiable.      
       
### View 
The View performs the same role as in MVVM or other architectures, which is to render the user interface.      
    
### Intent 
Intents represent actions that occur from the user or within the app.             
These are actions that change the app's state. For example, an action occurs when a user taps a button. The View conveys these Intents,      
and an object typically named ViewModel or Presenter processes the data in response to these Intents. (If so, isn't the name MVIP or MVIVM correct? 😀😀😀😀)       
      
## Advantages of MVI 
### State Management 
MVI simplifies complex data management issues by handling them through state management, which reduces the risk of bugs.      
Unidirectional Data Flow: Since data flows in one direction, it becomes easier to predict and track changes in the app's state. This is advantageous for debugging.    
Immutability: The state (Model) is immutable, providing thread safety. It also reduces side effects, helping to prevent unpredictable behavior.     
    
## Disadvantage of MVI
### Learning Curve
Understanding and implementing complex state management logic requires a certain level of learning.   
      
### Many Files and Objects
Even for simple functionality, it may be necessary to create multiple files and objects.   
     
## MVI Flow Diagram
     
<img width="721" alt="스크린샷 2024-09-23 오전 10 12 39" src="https://github.com/user-attachments/assets/acc67f31-21be-47ba-b536-24a45d85a9b0">

## Key points in MVI
    
### State-Centric Design 
The View is rendered based on the state, and all state changes must occur through actions called Intent.     
This state-centric design makes it easier to control the flow of the app.  
     
### Immutability of State 
In MVI, the state should be kept immutable, meaning that the previous state is not directly modified; instead, a new state is always created.      



