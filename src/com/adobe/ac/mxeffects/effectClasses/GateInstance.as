package com.adobe.ac.mxeffects.effectClasses
{
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	import com.adobe.ac.mxeffects.Gate;
	import com.adobe.ac.mxeffects.Lighting;
	
	import flash.geom.Rectangle;
	
	import mx.core.IFlexDisplayObject;
	
	public class GateInstance extends DistortBaseInstance
	{
		public var mode : String;
		public var horizontalLightingLocation : String;
		public var verticalLightingLocation : String;
		public var lightingStrength : Number;
		private var lighting : Lighting;		
		private var distortLeft : Distortion;
		private var distortRight : Distortion;
		private var distortBack : Distortion;
							
		public function GateInstance( target : Object )
		{
			super( target );
		}
		
		override public function play() : void
		{
			if( direction == null ) direction = Gate.defaultDirection;
			if( mode == null ) mode = Gate.defaultMode;
			if( buildMode == null ) buildMode = Gate.defaultBuildMode;
			lighting = new Lighting();
			lighting.direction = direction;
			lighting.horizontalLightingLocation = horizontalLightingLocation
			lighting.verticalLightingLocation = verticalLightingLocation;
			lighting.lightingStrength = lightingStrength;
						
			super.play();
			startAnimation();
		}
		
		private function startAnimation() : void
		{
			initializeNextTarget();
			nextAnimation();
		}
		
		private function nextAnimation() : void
		{
			if( mode == Gate.OPEN )
			{
				initializeNextTarget();
				distortBack = new Distortion( currentTarget );
				applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling - 1 ] ) );
				applyDistortionMode( distortBack );
				distortBack.renderSides( 100, 100, 100, 100 );
				initializePreviousTarget();
				startOpen();
			}
			else if( mode == Gate.CLOSE )
			{
				distortBack = new Distortion( currentTarget );
				applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling ] ) );
				applyDistortionMode( distortBack );
				distortBack.renderSides( 100, 100, 100, 100 );
				initializeNextTarget();
				startClose();
				initializePreviousTarget();				
			}
			distortBack.container.x -= distortBack.offsetRect.x;
		}
		
		private function startOpen() : void
		{
			initLeftAndRightDistortions();
			distortLeft.openDoor( 0, direction, distortion );
			distortRight.openDoor( 0, direction, distortion );
			
			var updateMethod : Function = lighting.getUpdateMethod( updateWithLightingFromWhite, 
																				updateWithLightingToBlack, 
																				updateOpenAnimation );			
			
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
		
		private function updateOpenAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distortLeft.openDoor( Number( value ), direction, distortion );
			distortRight.openDoor( Number( value ), 
										distortRight.reverseDirection( direction ), 
										distortion );
		}
		
		private function updateWithLightingToBlack( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateOpenAnimation( updateValue );
			lighting.setBrightness( distortLeft.container, lighting.toBlack( updateValue ) );
			lighting.setBrightness( distortRight.container, lighting.toBlack( updateValue ) );
			lighting.setBrightness( distortBack.container, lighting.fromBlack( updateValue ) );
		}
		
		private function updateWithLightingFromWhite( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateOpenAnimation( updateValue );
			lighting.setBrightness( distortLeft.container, lighting.fromWhite( updateValue ) );
			lighting.setBrightness( distortRight.container, lighting.fromWhite( updateValue ) );
			lighting.setBrightness( distortBack.container, lighting.fromBlack( updateValue ) );
		}
		
		private function endAnimation( value : Object ) : void
		{
			if( mode == Gate.OPEN )
			{
				distortBack.destroy();
				distortLeft.destroy( false );
				distortRight.destroy( false );
			}
			else if( mode == Gate.CLOSE )
			{
				distortBack.destroy( false );
				distortLeft.destroy();
				distortRight.destroy();
			}
			
			currentSibling++;
			var hasSiblings : Boolean = ( siblings.length > currentSibling + 1 );
			if( hasSiblings )
			{
				currentSibling--;
				startAnimation();
			}
			else
			{
				super.onTweenEnd( value );
			}
		}
		
		private function startClose() : void
		{
			initLeftAndRightDistortions();
			
			var updateMethod : Function = lighting.getUpdateMethod( updateWithLightingToWhite, 
																				updateWithLightingFromBlack, 
																				updateCloseAnimation );
																							
			animate( 0, 100, siblingDuration, updateMethod, endAnimation );
		}
		
		private function updateCloseAnimation( value : Object ) : void
		{
			if( liveUpdate ) distortBack.renderSides( 100, 100, 100, 100 );
			distortLeft.closeDoor( Number( value ), direction, distortion );
			distortRight.closeDoor( Number( value ), 
										distortRight.reverseDirection( direction ), 
										distortion );			
		}
		
		private function updateWithLightingToWhite( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateCloseAnimation( updateValue );
			lighting.setBrightness( distortLeft.container, lighting.toWhite( updateValue ) );
			lighting.setBrightness( distortRight.container, lighting.toWhite( updateValue ) );
			lighting.setBrightness( distortBack.container, lighting.toBlack( updateValue ) );
		}
		
		private function updateWithLightingFromBlack( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateCloseAnimation( updateValue );
			lighting.setBrightness( distortLeft.container, lighting.fromBlack( updateValue ) );
			lighting.setBrightness( distortRight.container, lighting.fromBlack( updateValue ) );
			lighting.setBrightness( distortBack.container, lighting.toBlack( updateValue ) );
		}		
		
		private function initLeftAndRightDistortions() : void
		{
			var leftRect : Rectangle;
			var rightRect : Rectangle;
			if( direction == DistortionConstants.LEFT || direction == DistortionConstants.RIGHT )
			{
				leftRect = getVerticalLeftRectangle( currentTarget );
				rightRect = getVerticalRightRectangle( currentTarget );
			}
			else if( direction == DistortionConstants.TOP || direction == DistortionConstants.BOTTOM )
			{
				leftRect = getHorizontalLeftRectangle( currentTarget );
				rightRect = getHorizontalRightRectangle( currentTarget );									
			}
			distortLeft = new Distortion( currentTarget, leftRect );
			distortRight = new Distortion( currentTarget, rightRect );

			applyCoordSpaceChange( distortLeft, getContainerChild( siblings[ currentSibling ] ) );
			applyCoordSpaceChange( distortRight, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distortLeft );
			applyDistortionMode( distortRight );
			applyBlur( distortLeft.container );
			applyBlur( distortRight.container );					
		}
		
		private function getVerticalLeftRectangle( currentTarget : IFlexDisplayObject ) : Rectangle
		{
			var leftRect : Rectangle = new Rectangle( 0, 0 );
			leftRect.width = currentTarget.width / 2;
			leftRect.height = NaN;
			return leftRect;
		}
		
		private function getVerticalRightRectangle( currentTarget : IFlexDisplayObject ) : Rectangle
		{
			var rightRect : Rectangle = new Rectangle( currentTarget.width / 2, 0 );
			rightRect.width = currentTarget.width / 2;
			rightRect.height = NaN;
			return rightRect;		
		}
		
		private function getHorizontalLeftRectangle( currentTarget : IFlexDisplayObject ) : Rectangle
		{
			var leftRect : Rectangle = new Rectangle( 0, 0 );
			leftRect.width = currentTarget.width;
			leftRect.height = currentTarget.height / 2;
			return leftRect;
		}
		
		private function getHorizontalRightRectangle( currentTarget : IFlexDisplayObject ) : Rectangle
		{
			var rightRect : Rectangle = new Rectangle( 0, currentTarget.height / 2 );
			rightRect.width = currentTarget.width;
			rightRect.height = currentTarget.height / 2;
			return rightRect;
		}
	}
}