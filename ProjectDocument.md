# Monsters' Shift - Project Document #

## Summary ##

Genre: Town Life Sim x Horror

Concept: An unassuming little city, with the protagonist’s estranged brother’s home, whose inhabitants turn into random themed monsters during the night.

Your estranged brother has died, and left his assets solely to you. Confused and resentful, you leave town to find out what happened when he abandoned you all those years ago. You arrive in an average, unassuming city and find his lone treehouse in the nearby forest. Determined to find out more, you discover that your brother may have not left you for no good reason… turns out, he left to help people who needed him more than you did. You discover your brother’s old friends are somehow afflicted and can turn into monsters. It’s your responsibility to finish what he started in this town that may be more than meets the eye.

## Project Resources

[Web-playable version of your game.](https://itch.io/)  
[Press Kit](https://lifeofpear.notion.site/Monsters-Shift-Press-Kit-15a82e252f01808e9f50e468f1cfeb79)
[Trailer]()
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

## Producer/Game Logic (Darroll)

My main role was organizing discussion about game development and ideation, integrating group ideas into the larger project while facilitating the discussion of project development as a whole.
* I also managed the GitHub repository, creating file management standards, merging changes and taking care of the **over 400 commits** it took to bring the project to a satisfying state.
* Managing 5 other teammates' branches involved thorough communication and understanding of what is within each repo and commit history, in addition to quickly and efficiently review changes, ensuring minimal code breaking during a merge.
* What often works best is to communiate to your teammates what you expect from a merge. Committing frequently is important to denote what exactly you changed, helping reviewers merge faster. Additionally, ensuring that only files that one intends to change, are actually committed with changes, is also a nice bonus for the person who has to merge branches together. It is MOST easy if developers merge main into their branch before requesting their branch be merged, as this accelerates the merging process significantly.

Wanting to start as early as possible, I led the team in an **Agile software development process**. 
* This involved creating a rough plan of what we wanted to accomplish early on, with more specific and numerous goals written down as to be completed ASAP during a weekly/biweekly sprint.
* I managed workflow and work distribution as best as I could given our busy schedules, throwing up TODOs and potential venues for development by the team's artists and developers.
* Although I investigated using a Kanban, what worked best for the team was this organizational calendar, which clearly showed how much we had done and how many weeks we had left to get things done:

| **Week 1 — November 4 to November 10** | **Week 2 — November 11 to 17** | **Week 3 — November 18 to November 24** | **Week 4 — November 25 to December 1** | **Week 5 — December 2 to December 8** | **Week 6 — December 10-13** |
|----------------------------------------|----------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|-------------------------|
| * darroll: movement, interaction with objects & object framework, imported dialogic textboxes, object framework, set up autotiles <br> * kat: rough town/world layout <br> * duy: transitioning between scenes | * briana/kat: writing intro cutscenes, some dialog <br> * darroll: create a test minigame scene <br> * kat: fill up the design documents <br> * matthew: minigame/quest manager <br> * darroll: framework for characters with different clothing options & colors <br> * darroll: map dev, simple day-night effects, fleshing out load zones <br> * duy: figure out cutscene manager workflow | * everyone: flesh out both minigame mechanics <br> * kat/bri: choose art style (for drawings & ui) <br> * darroll: create sprites for each character <br> * briana: set up dialogue boxes in ui, add dialogue and add sound effects/music to it <br> * matthew: save manager <br> * darroll: town collisions completed, added interactable click+hold behavior, item factories, carryable items, crafting system, improved cutscene authoring tools <br> * bri: character sketches <br> * kat: documentation <br> * duy: baker minigame proof of concept | * briana: finish drawing character photos, start implementing the code to run cutscenes <br> * noel: implement main menu <br> * matthew: setting up quests including: starting the baker/widow full day interactions, night time, work with writers to line up with story <br> * kat: edit character photos <br> * darroll: implement widow game <br> * duy: implement the npcs movement & ordering the baker game | horror mechanics at night time <br> * duy: finish baker & night time <br> * darroll: finish widow & night time <br> * bri: finish writing cutscenes, adding triggers for cutscenes, managing story <br> * kat: draw cutscene photos, widow minigame art (?), finish up the treehouse interior, additional documentation(?) <br> * matthew: help bri connect cutscenes together <br> * noel: add background to main menu <br> * side tasks: matthew: investigate music | * kat: press kit <br> testing, polish, debugging, and final adjustments for submission <br> * styling <br> * someone: music, sound effects <br> *  [more things we didn't write down in the final week] |

I also developed many of the important infrastructure tools from the ground up that made our project surrounding around a narrative and minigames, a success:
### **[Interactables](https://github.com/Iemontine/MonstersShift/tree/3a2e94b41a7945ed5247a9bd1240382e1b072555/interactable)**
Common superclass that allows for objects to be interacted with by the player, including carryable items, NPCs, and objects. I also made a nice interface for interactables that you have to hold the interact key on to use, which only ended up being used for the Cuttingboard in the Baker minigames but it was as nice addition. I also implemented the ability to carry objects (as seen in the Bakery minigames), utilizing the factory pattern to generate an endless stream of carryable items in those minigames. 

<img width="500" alt="Character Designer" src="https://github.com/user-attachments/assets/d7c237ff-dc23-4e7f-89eb-641cf48c656f" />

### **Cutscene Authoring Tools**
I created the interfaces for player and NPC movement, and further implemented two Controller classes that allow cutscene authors to produce animated character interactions and cutscenes. These controller classes were based on Duy's early attempts to prompt the player to move in certain ways during a Dialogic cutscene in reaction to a signal released telling the player to then play a predefined set of actions. I revamped this to use the function calling feature of Dialogic to allow cutscene authors to directly write in the cutscene performance into a cutscene file (.dtl). I also used the NPCController for interesting effects during the Widow game such as when they jumpscare or divert the player away from the treehouse. As easy as I might be making it sound, it was extremely complicated to handle various player and NPC states, juggling the necessary constraints required for animations and movement animations to play in different conditions and minigame scenarios. These tools evolved as Bri, the primary cutscene designer, found need for more features.
### **Character Designer**
Using the assets provided in a character asset pack we acquired, I imported the necessary animation trees and sprites and further implmented an easy way to set the clothing style of and clothing shader of our three main characters. I translate rough character ideas and sketches into sprite designs, which ended up being used as their final character designs.
<img width="600" alt="Character Designer" src="https://github.com/user-attachments/assets/51543b46-988f-4d53-9b8c-4aa9712873a7" />
<img width="250" alt="Character Designer" src="https://github.com/user-attachments/assets/b5353e68-2c82-4000-88c2-63f581f935b7" />
### **[Story Manager](https://github.com/Iemontine/MonstersShift/blob/3a2e94b41a7945ed5247a9bd1240382e1b072555/scripts/story_manager.gd)**
Manages current position in the story, allows for enabling/disabling of cutscene triggers or interactables. The enum list style of managing the current event was nice because it allowed for easy comparisons between the current event in relation to other events in the linear story.
### **[Scene Switcher](https://github.com/Iemontine/MonstersShift/blob/3a2e94b41a7945ed5247a9bd1240382e1b072555/scripts/scene_manager.gd)**
Based on Duy's early loadzone dev, I created a robust scene switching framework supporting doors and loadzones. The scene switching code can be called directly, emitting a "_on_scene_transition_complete" signal that was paramount in controlling the state, music, and appearance of the scene being loaded into. I revamped the loadzone code to be more robust against different entry directions, and also wrote the necessary code for doors, which leverage Interactable to allow a player to not only tranisition into a new scene, but teleport to a specific defined location (e.g. the other end of the door).
### Map development
Using the Interior and Exterior game assets we acquired, I helped create the world and game environments through a very iterative ideation-improve process. An easily overlookable part of this is having to set up the y-sorting (making it so the player properly renders above or below a sprite depending on how far above or below they are in the sprite, giving the illusion of depth) and collisions **per sprite, per level**. I often had to backtrack to optimize the tileset for size and complexity. Grouping together sprites, putting physics on Tileset entities themsleve,s and also ensuring that only the sprites being used are registered within the atlas were realizations I wish I had made early on, and would have helped avoid uselessly lost time. Here are some of the exteriors I mapped out and designed, with the help of Kat in ideation:
#### Treehouse Exterior
<img width="600" alt="Treehouse Exterior" src="https://github.com/user-attachments/assets/a199e1d7-fd5a-41f7-9556-12f486b6a44e" />

#### Conbini
<img width="600" alt="" src="https://github.com/user-attachments/assets/379a6e0f-4cfb-45a3-b1e0-379dc6281efc" />

#### City/Town
<img width="600" alt="" src="https://github.com/user-attachments/assets/40bcb381-1c55-4b38-8c11-5572e18795da" />

### Widow Minigames
Inside the Conbini which is a part of the Widow minigame, the player has to respond to popups for them to choose an item from the grocery store. These popups taught me how to use Tweening, an extremely useful tool that can animate any or most properties of a variety of node types between two values. This was particularly helpful for moving the paper and hint up and down, setting the transparency of the Widow when she attacks the player, or fading the music in/out during that sequence. Tweening also supports different transition effects, including EASE_IN, BOUNCE, or ELASTIC.

https://github.com/user-attachments/assets/4bcb89d7-ca86-4230-b3f7-346d8ed68bd3

I also made this cool flickering lights effect when visiting the Conbini at Night time, where I sampled a noise texture over time to provide the energy level of the lights that flicker.

![Conbini at Night](https://github.com/user-attachments/assets/41ad77da-0c87-4fc5-8ea2-ef35af18cd6f)

On the note of the Widow encounter and minigames, I created this QTE popup that animates onto the screen. The way I implemented this was by defining a speed curve at which the arrow we travel at each of the possible x values it can take along the length of the bar, then when the player clicks Interact, the arrow stops and I check for collisions. I implemented a game timer and QTE timer, such that I track how many second have passed in total useful for queueing up a new QTE and how many seconds the player has left in the current QTE before they automatically fail. Duy created the pixel art for both the daytime and nightime bar, and created the cool nighttime arrow. I extended the QTE day logic, which a simpler version of the night time version that does not involve getting killed or attacked, for the QTE at night version.
![QTE in the editor, hitboxes visible](https://github.com/user-attachments/assets/17d8b90e-65b4-4b19-9e2c-45536a4f93de)

Finally, I fully implemented the Widow night time sequence, complete with NPC animations, music transitions, and sound effects. I found time to introduce this binaural panning thing when the Widow is attacking the player on the left and right side of the screen, matching up to which ear they hear the widow coming from.

https://github.com/user-attachments/assets/15aa1f12-de69-4b9e-a38f-6237236cfb72

### Bug/Helping Fixes
In the final week of development when the game was finally fully playable, I learned to quickly stress test the different minigames and optimize for game feel, fixing bugs along the way this included:
1) Integrating necessary code that allowed Dialogic to be used throughout development
2) Reorganizing baker interior to make the game more interesting (previously all ingredients were just sitting next to each other)
3) Making it so three customer NPCs spawn, who each order something unique so the player practices creating the different recipes for the upcoming Boss version of the same minigame
4) Adding interesting sprites to the convenience store grocery items
5) Fixing issues like the wrong cutscene playing in the wrong location, testing sequence breaking
6) Decreasing the width of the arrow hitbox during the Bar QTE, as a thick hitbox for the arrow meant it was easy to mishit or at least feel that you were
7) Fixing and reworking the Baker as an interactable with pathfinding
8) Determining missing assets, file organization
   
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
The scene transition story events were done using a combination of the story manager and the scene manager (developed by Darroll, Duy, and Matthew). The story manager was connected to the scene manager so when a scene transition occurs, a story event may or not play. Using the enums I created earlier, I determined which events needed to play on scene transitions and implemented them in the function [here](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L37). Using a [match to current event](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L39) statement, I found what event was the last to occur. If it was a scene transition event, I would check the new scene, and if it was the correct scene, the story would transition to the new event and a cutscene would played. For example, after leaving the bakery in evening, the player sleep cutscene will only play once the player goes inside the treehouse ([see here](https://github.com/Iemontine/MonstersShift/blob/f053284fc774f766537662e667e152f7b516716d/scripts/story_manager.gd#L76-L79)).

### Other Transitions
For time passage, Matthew created a day to evening to night function that I used in certain parts throughout the story. This made it feel like your actions actually took time and made the game more atmospheric.
  
<img width="398" alt="Screenshot 2024-12-12 at 12 35 14 AM" src="https://github.com/user-attachments/assets/93b50d45-2e74-4d5b-bcaf-39e609c4f879" />

To make the walking time between places not feel so arduous, I created transitions in scenes that worked like the scene manager's scene switcher. Inside the player controller function, created by Darroll, I added a function that [teleports the player inside a scene](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/scripts/player_controller.gd#L107-L108). By using a basic black image and the Dialogic background feature, I would black out the screen, teleport the player to a new place, and then clear the background. An example of that is when the player grabs a drink on night two and goes to offer it to the widow ([see here](https://github.com/Iemontine/MonstersShift/blob/e72b6e0bedc9d966082f1007a6f095cb668ae593/dialogic/Timelines/Widow/widows_house_night.dtl)).

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
