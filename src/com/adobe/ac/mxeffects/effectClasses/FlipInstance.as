package com.adobe.ac.mxeffects.effectClasses
{
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	import com.adobe.ac.mxeffects.Flip;
	import com.adobe.ac.mxeffects.Lighting;
	
	public class FlipInstance extends DistortBaseInstance
	{		
		public var exceedBounds : Boolean;
		public var hasCustomExceedBounds : Boolean;		
		public var horizontalLightingLocation : String;
		public var verticalLightingLocation : String;
		public var lightingStrength : Number;
		private var lighting : Lighting;
		private var distortFront : Distortion;
		private var distortBack : Distortion;
				
		public function FlipInstance( target : Object )
		{
			super( target );
		}
		
		override public function play() : void
		{
			if( direction == null ) direction = Flip.defaultDirection;
			if( buildMode == null ) buildMode = Flip.defaultBuildMode;
			if( !hasCustomExceedBounds ) exceedBounds = true;
			lighting = new Lighting();
			lighting.direction = direction;
			lighting.horizontalLightingLocation = horizontalLightingLocation
			lighting.verticalLightingLocation = verticalLightingLocation;
			lighting.lightingStrength = lightingStrength;
			
			super.play();
			startFlipFront();
		}
				
		private function startFlipFront() : void
		{
			initializeNextTarget();		
			
			distortFront = new Distortion( currentTarget );
			applyCoordSpaceChange( distortFront, getContainerChild( siblings[ currentSibling ] ) );
			applyDistortionMode( distortFront );
			applyBlur( distortFront.container );
			
			var updateMethod : Function = lighting.getUpdateMethod( updateFrontWithLightingToBlack, 
																			updateFrontWithLightingFromWhite, 
																			updateFront );
			animate( 0, 100, siblingDuration / 2, updateMethod, endFront );
		}
		
		private function updateFront( value : Object ) : void
		{
			distortFront.flipFront( Number( value ), direction, distortion, exceedBounds );
		}
		
		private function updateFrontWithLightingToBlack( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateFront( updateValue );
			lighting.setBrightness( distortFront.container, lighting.toBlack( updateValue ) );
		}
						
		private function updateFrontWithLightingFromWhite( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateFront( updateValue );
			lighting.setBrightness( distortFront.container, lighting.fromWhite( updateValue ) );
		}
		
		private function endFront( value : Object ) : void
		{
			if( buildMode == DistortionConstants.REPLACE ) 
			{
				container.removeChild( distortFront.container );
			}			
			startFlipBack();
		}
		
		private function startFlipBack() : void
		{
			initializeNextTarget();
			distortBack = new Distortion( currentTarget );
			applyCoordSpaceChange( distortBack, getContainerChild( siblings[ currentSibling - 1 ] ) );
			applyDistortionMode( distortBack );
			applyBlur( distortBack.container );
			
			var updateMethod : Function = lighting.getUpdateMethod( updateBackWithLightingToWhite, 
																			updateBackWithLightingFromBlack, 
																			updateBack );
			animate( 0, 100, siblingDuration / 2, updateMethod, endBack );
		}
		
		private function updateBack( value : Object ) : void
		{
			distortBack.flipBack( Number( value ), direction, distortion, exceedBounds );
		}
		
		private function updateBackWithLightingToWhite( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateBack( updateValue );
			lighting.setBrightness( distortBack.container, lighting.toWhite( updateValue ) );
		}
			
		private function updateBackWithLightingFromBlack( value : Object ) : void
		{
			var updateValue : Number = Number( value );
			updateBack( updateValue );
			lighting.setBrightness( distortBack.container, lighting.fromBlack( updateValue ) );
		}
		
		private function endBack( value : Object ) : void
		{
			distortFront.destroy( false );
			var hasSiblings : Boolean = ( siblings.length > currentSibling + 1 );
			if( hasSiblings )
			{
				currentSibling--;
				delayDeletion( distortBack );
				startFlipFront();
			}
			else
			{
				distortBack.destroy();
				super.onTweenEnd( value );
			}
		}
	}
}