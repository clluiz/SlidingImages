package slidingimages {
	
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.core.IVisualElement;
	import mx.events.EffectEvent;
	
	import spark.components.BorderContainer;
	import spark.effects.Fade;
	import spark.effects.Move;
	
	public class Slide extends BorderContainer {
		
		private var _image:Image;
		private var moveEffect:Move;
		private var fadeInEffect:Fade;
		private var focused:Boolean = false;
		private var _description:IVisualElement;
		
		public var minX:Number;
		public var maxX:Number;
		public var next:Slide;
		public var previous:Slide;
		public var defaultPosition:Number;
		
		private function setUpDescriptionShowEffect():void {
			
			fadeInEffect = new Fade( _description );
			fadeInEffect.alphaFrom = 0.0;
			fadeInEffect.alphaTo = 1.0;
			fadeInEffect.duration = 500;
		}
		
		private function setUpMovementEffect():void {
			
			moveEffect = new Move( this );
			moveEffect.duration = 500;
			moveEffect.addEventListener( EffectEvent.EFFECT_START, startMovement );
			moveEffect.addEventListener( EffectEvent.EFFECT_END, endMovement ); 
		}
		
		private function setUpDescription():void {
			
			_description.y = height - _description.height -  2 * getStyle( "borderWeight" ) as Number;
			_description.visible = false;
			setUpDescriptionShowEffect();
		}
		
		private function startMovement( event : EffectEvent ):void {
			
			if( !focused && _description ) {
				
				_description.alpha = 0.0;
			}
		}
		
		private function endMovement( event : EffectEvent ):void {
			
			if( fadeInEffect && focused ) {
				
				fadeInEffect.play();
				event.stopPropagation();
			}
		}
		
		private function mouseOver( event : MouseEvent ):void {
			
			focused = true;
			moveLeft();
			if(next != null)
				next.moveRight();
		}
		
		private function mouseOut( event : MouseEvent ):void {
			
			focused = false;
			if( fadeInEffect &&  fadeInEffect.isPlaying ) {
				
				fadeInEffect.stop();
			}
		}
		
		override protected function createChildren():void {
			
			super.createChildren();
		}
		
		override protected function commitProperties():void {
			
			super.commitProperties();
			setUpMovementEffect();
		} 
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			image.x = 0;
			image.y = 0;
			addElement( image );
			
			if( _description ) {
				
				setUpDescription();
				addElement( _description ); 
			}
		}
		
		override protected function measure():void {
			
			super.measure();
			var border:Number = getStyle( "borderWeight" );
			height = _image.height + 2 * border;
			width = _image.width + 2 * border;
		}
		
		public function Slide() {
			
			super();
			addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
		}
		
		public function get description():IVisualElement {
			
			return _description;
		}

		public function set description( value : IVisualElement ):void {
			
			_description = value;
			invalidateProperties();
		}

		public function get image():Image {
			
			return _image;
		}

		public function set image(value:Image):void {
			
			_image = value;
			_image.mouseEnabled = false;
			invalidateProperties();
		}
		
		public function moveRight():void {
			
			moveEffect.xFrom = x;
			moveEffect.xTo = maxX;
			moveEffect.play();
			if( next != null ) {
				next.moveRight();
			}
		}
		
		public function moveLeft():void {
			
			moveEffect.xFrom = x;
			moveEffect.xTo = minX;
			moveEffect.play();
			if( previous != null )
				previous.moveLeft();
		}
		
		public function moveToDefaultPosition():void {
			
			moveEffect.xFrom = x;
			moveEffect.xTo = defaultPosition;
			moveEffect.play();
		}
	}
}