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

**Document how the narrative is present in the game via assets, gameplay systems, and gameplay.** 

### Descriptions
NOTE TO REMOVE BEFORE SUBMITTING: Maybe split these into sub-sub-headings

* For 37 story events, covered their creation, conversion into dialogic, and connection to the gameplay --> See all below sections
* * Dialogic was incredibly important in creating and displaying narrative - discussed [below](https://github.com/Iemontine/MonstersShift/blob/dev-bri-repo-setup/ProjectDocument.md#visual-design--user-interface-and-input-briana)
  
* StoryManager holds all events in an enum --> these enums are used to access different story events
  * Scene transition story events
  * Interactable story events
  * Area trigger story events
* Wrote almost all dialogue (edits and adjustments from other creators)
  * Dialogue gives most of the story, very important to read
  * Also is used to direct the player in the correct directions
  * Introduction was created in conjunction with Katherine who drew the pictures - gives player story set up
* Improving dialogue feel
  * Use of sound effects inside cutscenes
  * Use of animations & movement inside cutscenes (npc/player controllers --> added a few functions to what Darroll created)
* Use of Matthew's scene manager
  * Force switching scenes to get player to correct location for story
  * Day/night cycles used for passage of time
  * Used idea of transition in scene manager to make my own transitions inside dialogic when a player needs to teleport somehwere in a specific scene without being shown


### Assets Used:
* [Dialogic](https://github.com/dialogic-godot/dialogic)
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
