/*
 *  __  __      
 * /\ \/\ \  __________   
 * \ \ \_\ \/_______  /\   
 *  \ \  _  \  ____/ / /  
 *   \ \_\ \_\ \ \/ / / 
 *    \/_/\/_/\ \ \/ /  
 *             \ \  /
 *              \_\/
 *
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2010-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package
{
	import as3.hv.components.tooltip.ITooltip;
	import as3.hv.components.tooltip.AbstractTooltip;

	import flash.text.TextField;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	[IconFile("tooltipIcon.png")]
	
	// =========================================================================
	// Class TooltipComicBubble
	// =========================================================================
	// Base class for TooltipComicBubble.swc 
	//
	// Based on Tooltip.as from Dan Carr (dan@dancarrdesign.com) 
	// used in his article
	// "Deconstructing the ActionScript 3 Flash video gallery application" 
	// @see http://www.adobe.com/devnet/flash/articles/vidgal_structure.html
	//
	// Changes I made:
	// - delay functionality
	// - alignments
	// - multiline support
	// - converted into SWC
	//
	public class TooltipComicBubble 
			extends AbstractTooltip 
			implements ITooltip
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		// Component Version
		public static const VERSION:String = "1.1.0";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
				
		private var defaultWidth:Number = 0;
		private var defaultHeight:Number = 0;
		
		private var cursorXOffset:Number = -16;
		private var cursorYOffset:Number = -3;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function TooltipComicBubble():void
		{
			super();
			
			// Assign the internal vars to the real component parameters.
			// Due to a bug in Flash CS3. the default values you set for
			// component parameters are only used if at least one of them is
			// changed in your movieclip.
			
			// component var = internal var 
			fillColor = this.myFillColor;
			fillAlpha = this.myFillAlpha;
			
			outlineColor = this.myOutlineColor;
			outlineAlpha = this.myOutlineAlpha;
			
			(this as MovieClip).myLabel.autoSize = "left";
			(this as MovieClip).myLabel.multiline = true;
			
			labelColor = this.myTextColor;
			
						
			this.defaultWidth = (this as MovieClip).skinLeftUpFilling.width;
			this.defaultHeight = (this as MovieClip).skinLeftUpFilling.height;
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**		
		 * ---------------------------------------------------------------------
		 * setLabel
		 * ---------------------------------------------------------------------
		 * update Label text
		 *
		 * @param lbl		The new text.
		 */
		public function setLabel(lbl:String):void
		{
			(this as MovieClip).myLabel.htmlText = lbl;
			// Flash Bug: after setting the text you have to set the 
			// textcolor again, otherwise the coloring is lost.
			(this as MovieClip).myLabel.textColor = this.myTextColor;
			
			var scaleWidth:Number = (Math.round(
					(this as MovieClip).myLabel.textWidth) + 24) 
					/ this.defaultWidth;
					
			var scaleHeight:Number = (Math.round(
					(this as MovieClip).myLabel.textHeight) + 24) 
					/ this.defaultHeight;
			
			// scale left top skin
			(this as MovieClip).skinLeftUpFilling.scaleX = scaleWidth;
			(this as MovieClip).skinLeftUpOutline.scaleX = scaleWidth;

			(this as MovieClip).skinLeftUpFilling.scaleY = scaleHeight;
			(this as MovieClip).skinLeftUpOutline.scaleY = scaleHeight;
			
			// scale right top skin
			(this as MovieClip).skinRightUpFilling.scaleX = scaleWidth;
			(this as MovieClip).skinRightUpOutline.scaleX = scaleWidth;

			(this as MovieClip).skinRightUpFilling.scaleY = scaleHeight;
			(this as MovieClip).skinRightUpOutline.scaleY = scaleHeight;
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * showTooltip
		 * ---------------------------------------------------------------------
		 * prepares the tooltip to be shown.
		 * add enterFrameHandler and mouseMoveHandler from AbstractTooltip here.
		 *
		 *
		 * @param dShow		Delay in Secounds after the tooltip is shown.
		 *					If it is 0 the tooltip is shown immediately.
		 * @param dHide		Delay in Secounds after the tooltip is hiddden.
		 *					Default is -1, which means there is no autohide.
		 */
		public function showTooltip(
				dShow:int=0,
				dHide:int=-1
			):void
		{
			this.delayShow = dShow;
			this.delayAutoHide = dHide;
			
			// convert secounds in to frames
			this.timerShow = this.delayShow * stage.frameRate;
			
			if( this.delayAutoHide > 0 ) {
				// convert secounds in to frames
				this.timerAutoHide = this.delayAutoHide * stage.frameRate;
				
				// add EventListener from AbtractTooltip
				stage.addEventListener(
						MouseEvent.MOUSE_MOVE, 
						mouseMoveHandler
					);
			
			} else {
				this.timerAutoHide = -1;
			}
			
			// add EventListener from AbtractTooltip
			this.addEventListener(
					Event.ENTER_FRAME, 
					enterFrameHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * align
		 * ---------------------------------------------------------------------
		 * manages the tooltips Position relative to the mouse position.
		 * also changes the bubble alignment if the tooltip reaches the left
		 * or right edge of the stage.
		 */
		public function align():void
		{
			var posMouseX:int = this.stage.mouseX;
			var posMouseY:int = this.stage.mouseY;
				
			var bubbleWidth:int = (this as MovieClip).skinLeftUpOutline.width;
			var bubbleHeight:int = (this as MovieClip).skinLeftUpOutline.height;
				
			var stageWidth:int = this.stage.stageWidth;
								
			if ( (posMouseX + this.cursorXOffset + bubbleWidth ) > stageWidth ) 
			{
				// align right
				(this as MovieClip).skinLeftUpOutline.visible = false;
				(this as MovieClip).skinLeftUpFilling.visible = false;
				
				(this as MovieClip).skinRightUpOutline.visible = true;
				(this as MovieClip).skinRightUpFilling.visible = true;
					
				this.x = posMouseX - bubbleWidth + (this.cursorXOffset*-1);
				this.y = posMouseY + this.cursorYOffset - bubbleHeight;
					
			} else {
				// align left (default)
					
				(this as MovieClip).skinLeftUpOutline.visible = true;
				(this as MovieClip).skinLeftUpFilling.visible = true;
				
				(this as MovieClip).skinRightUpOutline.visible = false;
				(this as MovieClip).skinRightUpFilling.visible = false;
				
				this.x = posMouseX + this.cursorXOffset;
				this.y = posMouseY + this.cursorYOffset - bubbleHeight;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hide
		 * ---------------------------------------------------------------------
		 * hides the tooltip and removes all listeners.
		 */
		public function hide():void
		{
			stage.removeEventListener(
					MouseEvent.MOUSE_MOVE, 
					mouseMoveHandler
				);
			
			this.removeEventListener(
					Event.ENTER_FRAME, 
					enterFrameHandler
				);
			
			this.visible = false;
		}
		
		
		// =====================================================================
		// Component Parameters
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * fillColor
		 * ---------------------------------------------------------------------
		 * get/set the bubbles background color
		 */
		[Inspectable(name="Bubble Filling Color", type=Color, defaultValue="#888888")]
		public function set fillColor(newcolor:uint)
		{
			this.myFillColor = newcolor;
			this.recolorElement(
					(this as MovieClip).skinLeftUpFilling, 
					this.myFillColor, 
					this.myFillAlpha
				);
			this.recolorElement(
					(this as MovieClip).skinRightUpFilling, 
					this.myFillColor, 
					this.myFillAlpha
				);
		}

		public function get fillColor():uint
		{
			return this.myFillColor;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * fillAlpha
		 * ---------------------------------------------------------------------
		 * get/set the bubbles background alpha 
		 */
		[Inspectable(name="Bubble Filling Alpha", type=Number, defaultValue=100)]
		public function set fillAlpha(val:int)
		{
			if( val < 0 ) {
				val = 0;
			} else if( val > 100 ) {
				val = 100;
			} 
			
			this.myFillAlpha = val;
			this.recolorElement(
					(this as MovieClip).skinLeftUpFilling, 
					this.myFillColor, 
					this.myFillAlpha
				);
			this.recolorElement(
					(this as MovieClip).skinRightUpFilling, 
					this.myFillColor, 
					this.myFillAlpha
				);
		}

		public function get fillAlpha():int
		{
			return this.myFillAlpha;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * outlineColor
		 * ---------------------------------------------------------------------
		 * get/set the bubbles outline color
		 */
		[Inspectable(name="Bubble Outline Color", type=Color, defaultValue="#ffffff")]
		public function set outlineColor(newcolor:uint)
		{
			this.myOutlineColor = newcolor;
			this.recolorElement(
					(this as MovieClip).skinLeftUpOutline, 
					this.myOutlineColor, 
					this.myOutlineAlpha
				);
			this.recolorElement(
					(this as MovieClip).skinRightUpOutline, 
					this.myOutlineColor, 
					this.myOutlineAlpha
				);
		}

		public function get outlineColor():uint
		{
			return this.myOutlineColor;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * outlineAlpha
		 * ---------------------------------------------------------------------
		 * get/set the bubbles outline alpha
		 */
		[Inspectable(name="Bubble Outline Alpha", type=Number, defaultValue=100)]
		public function set outlineAlpha(val:int)
		{
			if( val < 0 ) {
				val = 0;
			} else if( val > 100 ) {
				val = 100;
			} 
			
			this.myOutlineAlpha = val;
			this.recolorElement(
					(this as MovieClip).skinLeftUpOutline, 
					this.myOutlineColor, 
					this.myOutlineAlpha
				);
			this.recolorElement(
					(this as MovieClip).skinRightUpOutline, 
					this.myOutlineColor, 
					this.myOutlineAlpha
				);
		}

		public function get outlineAlpha():int
		{
			return this.myOutlineAlpha;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * labelColor
		 * ---------------------------------------------------------------------
		 * get/set the labels text color
		 */
		[Inspectable(name="Label Text Color", type=Color, defaultValue="#000000")]
		public function set labelColor(newcolor:uint)
		{
			this.myTextColor = newcolor;
			(this as MovieClip).myLabel.textColor = myTextColor;
		}

		public function get labelColor():uint
		{
			return this.myTextColor;
		}
		
		
		
		
		
	}
}