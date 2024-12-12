# Monsters' Shift - Project Document #

## Summary ##

**A paragraph-length pitch for your game.**

## Project Resources

[Web-playable version of the game!](https://itch.io/)  
[Trailer & Press Kit](https://youtube.com)  
[Proposal](https://docs.google.com/document/d/13rA_z6qEpbPbOANST8JtTClTLj1EfRgtfr3JS2eXfag/edit?usp=sharing)  

## Gameplay Explanation ##

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**


**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

# External Code, Ideas, and Structure #

If your project contains code that: 1) your team did not write, and 2) does not fit cleanly into a role, please document it in this section. Please include the author of the code, where to find the code, and note which scripts, folders, or other files that comprise the external contribution. Additionally, include the license for the external code that permits you to use it. You do not need to include the license for code provided by the instruction team.

If you used tutorials or other intellectual guidance to create aspects of your project, include reference to that information as well.


* Generally, we met once or twice a week in person to organize a general game plan and to discuss what we each were working on. We also maintained constant contact through Discord keeping each other up to date.

# Main Roles #

Your goal is to relate the work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

## Producer (Darroll)

**Describe the steps you took in your role as producer. Typical items include group scheduling mechanisms, links to meeting notes, descriptions of team logistics problems with their resolution, project organization tools (e.g., timelines, dependency/task tracking, Gantt charts, etc.), and repository management methodology.**

## Narrative Design (Briana)
Our game included approximately 40 story events. For about 95% of them, I covered creation, conversion into dialogic, and connection to the gameplay. Dialogic was incredibly important in creating and displaying our main narrative. Cutscenes would occur in three different cases:
* Scene transitions - works with the [Scene Manager](https://github.com/Iemontine/MonstersShift/blob/d0fbeeecea7af0c37b6bfc50e9f062485d4c9277/scripts/scene_manager.gd)
* Interactables - works with the [Interactable Class](https://github.com/Iemontine/MonstersShift/blob/d0fbeeecea7af0c37b6bfc50e9f062485d4c9277/interactable/interactable.gd)
* Area Triggers - works with Area2D nodes

### Story Content
Since our game is heavily story-based, we needed to find a way to communicate all important narrative and directions. Through the use of dialogue, the player can gleam everything they need to know about the game if they read carefully. Also, dialogue was used to lead the player in the correct direction. For example, after waking up on the second day, we encourage the player to visit the fountain in town so that they can initiate the next story event ([see here](https://github.com/Iemontine/MonstersShift/blob/287d32d56b9d9b47556dfe263e53960ffcba4708/dialogic/Timelines/Widow/day_two_morning.dtl)). For the [introduction](https://github.com/Iemontine/MonstersShift/blob/287d32d56b9d9b47556dfe263e53960ffcba4708/dialogic/Timelines/intro.dtl), I worked with Katherine, who drew the actual images, to give the player all necessary background.

<img width="472" alt="Screenshot 2024-12-11 at 11 35 45 PM" src="https://github.com/user-attachments/assets/39d7b620-4b27-4f9b-a1f1-f7d49e523c4c" />

### Story Manager
To better organize the story, Darroll created a basic template for a [story manager](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd). Since our story is generally linear, we created an enum to hold all the story events. As I created dialogue, I added events to this [enum list](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L5-L19) so that cutscenes could be called appropiately later. Play cutscene and story transition functions were used to change to these events and play them.

### Interactable Story Events
Darroll created an interactable class that let's players interact using the space bar. Using this class, I was able to create several npc and object interactables in the world that were connected to certain story events. Most could only be accessed if the player was in the correct story state (by use of an if statement that checks the current event) but some interactables just had different dialogue at different times. For example, if you talk to the baker on day two he will [tell you something different](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/Baker/baker_day_two.dtl) from what he told you on day one. 

### Area Trigger Story Events
For some cases, an area2D was used to trigger cutscenes when a player walked in a certain location. This works very similarly to the interactables where the event will only trigger if you are in a very specific story state. For example, on day two when walking into the little park, a [first interaction with the widow](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/cutscenes/WidowArea/widow_first_cutscene.gd) will occur. The cutscene will not play if the story is anywhere before or after that in the sequence.

### Scene Transition Story Events
The scene transition story events were done using a combination of the story manager and the scene manager (developed by Darroll, Duy, and Matthew). The story manager was connected to the scene manager so when a scene transition occurs, a story event may or not play. Using the enums I created earlier, I determined which events needed to play on scene transitions and implemented them in the function [here](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L37). Using a [match to current event](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L39) statement, I found what event was the last to occur. If it was a scene transition event, I would check the new scene, and if it was the correct scene, the story would transition to the new event and a cutscene would played. For example, after leaving the bakery in evening, the player sleep cutscene will only play once the player goes inside the treehouse ([see here](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L76-L79).

### Other Transitions
For time passage, Matthew created a day to evening to night function that I used in certain parts throughout the story. This made it feel like your actions actually took time and made the game more atmospheric.
  
<img width="398" alt="Screenshot 2024-12-12 at 12 35 14 AM" src="https://github.com/user-attachments/assets/93b50d45-2e74-4d5b-bcaf-39e609c4f879" />

To make the walking time between places not feel so arduous, I created transitions in scenes that worked like the scene manager's scene switcher. Inside the player controller function, created by Darroll, I added a function that [teleports the player inside a scene](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/scripts/player_controller.gd#L107-L108). By using a basic black image and the Dialogic background feature, I would black out the screen, teleport the player to a new place, and then clear the background. An example of that is when the player grabs a drink on night two and goes to offer it to the widow ([see here](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/Widow/widows_house_night.dtl).

In some cutscenes, there needed to be transitions from one scene to another in the middle of the dialogue. Using the [player controller's switch scene function](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/scripts/player_controller.gd#L43-L44), I was able to make seamless transitions in cutscenes that flowed naturally in the story. Also, this scene switcher was used to switch to the minigames ([see example here](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/Baker/baker_first_interaction.dtl#L49)).

### Dialogue Feel
To make the dialogue feel less static, I added sound effects, animations, and movement inside the cutscene.

I used functions inside the [npc](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/scripts/npc_controller.gd) and [player](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/scripts/player_controller.gd) controllers to select the animations and movement that would perfectly fit the context of the scene. This was a large trial and error process of making sure animations were facing the right way and that the player would move for the exact right amount of time. For example, when creating the going to bed sequences for [day one](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/Baker/baker_player_insomnia.dtl) and [day two](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/Widow/widow_player_insomnia.dtl), the staggered movement to the bed took closing and loading the game multiple times to find the appropiate wait seconds.
  
<img width="433" alt="Screenshot 2024-12-12 at 12 55 27 AM" src="https://github.com/user-attachments/assets/6ac04426-3202-4442-98ea-54455a532086" />

Sound effects were also important because they give each individual character more life and make the world feel dynamic. I tried to add a few sound effects in every scene but not too many to avoid overwhelming the player. Most sounds were from outside sources but I recorded the widow crying and signing using my own voice. The sounds were added to the cutscenes via Dialogic's built in audio buttons.

### Neat Tricks
Some neat tricks were used to stop unwanted story progression. Certain preventative dialogue options would stop a player from leaving areas. For example, if you do not explore the treehouse before going to town, an area trigger will tell you to go back to the house and forcibly turn you around ([see here](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/HouseAreaPostIntro/leave_early_postarrival.dtl)). Also, certain sprites were not visible to avoid confusion before their event. For example, the widow only appeared at the bench near her house once the day two morning event was reached.

### Assets Used:
* [Dialogic](https://github.com/dialogic-godot/dialogic) - License: [MIT License](https://github.com/dialogic-godot/dialogic/blob/main/LICENSE)
* [Zombie Sounds](https://terrorbytegames.itch.io/zombie-massacre-sound-effects-starter-pack) by itch.io user TerrorByteGames - License given by the creator
* [Voice Effects](https://nox-sound-design.itch.io/essentials-series-sfx-nox-sound) by itch.io user Nox_Sound_Design - License: [Creative Commons Zero v1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/deed.en)
* [Record Player Music](https://chillmindscapes.itch.io/free-chiptune-music-pack-4-chillmindscapes) by itch.io user ChillMindscapes - License: [Creative Commons Attribution v4.0 International](https://creativecommons.org/licenses/by/4.0/)
* [Character Animations](https://seliel-the-shaper.itch.io/farmer-base) by itch.io user Seliel the Shaper - License: [Mana Seed User License](https://selieltheshaper.weebly.com/user-license.html)

## Animation & Visuals (Katherine)

**List your assets, including their sources and licenses.**

**Describe how your work intersects with game feel, graphic design, and world-building. Include your visual style guide if one exists.**

## Game Logic & Game Feel (Matthew)

**Document the game states and game data you managed and the design patterns you used to complete your task.**
**Document what you added to and how you tweaked your game to improve its game feel.**

## Game Logic (Duy)

**Document the game states and game data you managed and the design patterns you used to complete your task.**

## User Interface and Input (Noel)

**Describe your user interface and how it relates to gameplay. This can be done via the template.**
**Describe the default input configuration.**
**Add an entry for each platform or input style your project supports.**


# Sub-Roles

## Gameplay Testing (Darroll)

**Add a link to the full results of your gameplay tests.**
**Summarize the key findings from your gameplay tests.**

## Visual Design & UI (Briana)

### Dialogic:
As mentioned in [Narrative Design](https://github.com/Iemontine/MonstersShift/blob/main/ProjectDocument.md#narrative-design-briana), Dialogic was our main tool to communicate narrative to the user through world interactions. Initially, the Dialogic template of "Speaker Textbox Style" was used to create basic textboxes but the following adjustments were made to make it more customzied:
  * The background was changed to a brown, slightly shadowed texture. This required making a custom layer inside the dialogue styles and adjusting the background and size of the pre-existing box.
  * Originally, there was not a clear border around the character portrait. So, I decided to find a frame asset that would stand out from the background but still be simple - leading to a white square frame.
  * We used a special font that looked like doodles the character might be making as if she was taking notes.
  * For the centered dialogue choices, I changed the background to be a similar brown to the large dialogue box.
    
<img width="1561" alt="Screenshot 2024-12-11 at 10 26 46 PM" src="https://github.com/user-attachments/assets/4ebe1ace-9b84-4811-8abc-b58f2f3bb5c2" />
All of these dialogue visual design choices were made to create a unique game feel.

  * General dialogue styles were made: one dialogue box would have a portrait for speakers while the other box was for general narration. [See here.](https://github.com/Iemontine/MonstersShift/tree/d0fbeeecea7af0c37b6bfc50e9f062485d4c9277/dialogic/Styles)
  * Character styles had to be set up for the three different characters: player, widow, and baker. This involved adding different portraits and changing their display name. [See here.](https://github.com/Iemontine/MonstersShift/tree/d0fbeeecea7af0c37b6bfc50e9f062485d4c9277/dialogic/Characters)
  <img width="999" alt="Screenshot 2024-12-11 at 10 29 16 PM" src="https://github.com/user-attachments/assets/4d71aef4-6633-47ca-aa78-91220fa0d720" />

### Portrait Creation
We wanted to follow the classic style of having a character portrait for dialogue, similar to how Stardew Valley has their portraits. This feature brings more life to the game because the higher detail helps the player see a full character and not just a simple sprite. After Darroll designed the sprites with the group's feedback, I was able to take them and design character portraits. The process was done all on paper and involved sketching, outlining, and coloring to fit the sprites.

![image](https://github.com/user-attachments/assets/44acd39a-ac0c-4454-9841-7141b9f91970)

After scanning in my drawings, I was able to send them to Katherine who placed them in game after she added pixelation and different facial expressions. Once in game, I was able to use Dialogic's character design feature to resize and move around the portraits to fit perfectly in the created frame.

### Assets Used:
* [Portrait Frames](https://gx310.itch.io/pxiel-art-ui-borders?download) by itch.io user GX310 - License given by the creator
* [Dialogue Box Background](https://srtoasty.itch.io/ui-assets-pack-2) by itch.io user Sr.Toasty - License: [Creative Commons Zero v1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/deed.en)
* [Friendly Scribbles Font](https://kmlgames.itch.io/friendly-scribbles) by itch.io user kmlgames - License: [Creative Commons Attribution v4.0 International](https://creativecommons.org/licenses/by/4.0/)

## Press Kit and Trailer & Narrative (Katherine)

**Include links to your presskit materials and trailer.**
**Describe how you showcased your work. How did you choose what to show in the trailer? Why did you choose your screenshots?**
**Document how the narrative is present in the game via assets, gameplay systems, and gameplay.** 

## Music (Matthew)

**List your assets, including their sources and licenses.**

**Describe the implementation of your audio system.**

**Document the sound style.** 

## Game Feel and Polish (Duy)

**Document what you added to and how you tweaked your game to improve its game feel.**

## Audio (Noel)

**List your assets, including their sources and licenses.**

**Describe the implementation of your audio system.**
