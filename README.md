# TooltipComicBubble

-----------------------------------

*Flash SWC tooltip component*

Based on Tooltip from Dan Carr (dan@dancarrdesign.com)
used in his article:

[Deconstructing the ActionScript 3 Flash video gallery application](http://www.adobe.com/devnet/flash/articles/vidgal_structure.html)

New features I added:
-	delay functionality
-	autohide
- 	alignments
-	multiline support
- 	converted into SWC

-----------------------------------

![Tooltip](https://github.com/HerbertV/TooltipComicBubble/blob/master/images/tooltip.png?raw=true)

## How to use
Inside the demo dir you will find a Demo fla.

Code snippet:

	// set text
	tooltip.setLabel("Hello World!\n Foo bar");
	
	// show tooltip without autohide and delay
	tooltip.showTooltip();

	// show tooltip with 2 seconds delay
	// and auto hide it after 10 seconds
	tooltip.showTooltip(2,10);


## Installing and using SWCs

#### Generic path:
[Flash Root Dir]/[langdir]/Configuration/Components


#### Example path for WinXP:
C:\Programme\Adobe\Adobe Flash CS3\de\Configuration\Components


#### Brief Step-by-Step Installation:
1. 	Copy ProgressWingCS.swc into the folder from above.
2. 	Start your Flash 
3. 	Go to the Component Window: Menu->Window->Component
	ProgressWingsCS should appear there.
4.	now you can drag&drop the component on to your stage.

![Component Instpector](https://github.com/HerbertV/ProgressWingsCS/blob/master/images/ComponentInspector.png?raw=true)


Or see this tutorial how to create and install SWCs:

[http://www.adobe.com/devnet/flash/articles/creating_as3_components.html](http://www.adobe.com/devnet/flash/articles/creating_as3_components.html)