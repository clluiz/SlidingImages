package slidingimages {
	
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.containers.Canvas;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	
	public class SlidingImages extends Canvas {
		
		private var last:Slide;
		private var first:Slide;
		private var _itemsWidth:Number;
		private var _dataProvider:IList;
		private var _initialPercentageVisible:Number;
		
		private function buildDoubleLinkedList():void {
			
			if( _dataProvider ) {
				
				for(var i:int = 0; i < _dataProvider.length; i++) {
					
					if( i == 0 ) 
						first = _dataProvider[i];
					
					if( i < _dataProvider.length - 1 ) {
						
						_dataProvider[i].next = _dataProvider[i+1];
						_dataProvider[i + 1].previous = _dataProvider[i];
					} 
					
					if( i == _dataProvider[ _dataProvider.length - 1] )
						last = _dataProvider[i];
				}
			}
		}
		
		private function drawItems():void {
			
			if( _dataProvider ) {
				
				var distancia:Number = ( _initialPercentageVisible / 100 ) * _itemsWidth;
				for ( var i:int = 0; i < _dataProvider.length; i++ ) {
					
					var item:Slide = _dataProvider.getItemAt(i) as Slide;
					
					item.x = item.defaultPosition = i * distancia;
					item.minX = item.defaultPosition / 2;
					
					if( item.previous != null  ) {
						
						item.maxX = item.previous.minX + itemsWidth;
					}
					
					item.y = 0;
					addElement( item );
				}
			}
		} 
		
		private function mouseOut( event : MouseEvent ):void {
			
			for each(var item:Slide in _dataProvider) {
				
				item.moveToDefaultPosition();
			}
		}
		
		override protected function createChildren():void {
			
			super.createChildren();
		}
		
		override protected function commitProperties():void {
			
			super.commitProperties();
			buildDoubleLinkedList();
			drawItems();
		}
		
		override protected function measure():void {
			
			super.measure();
		}
		
		protected function propertyChange( event : PropertyChangeEvent ):void {
			
			invalidateProperties();
		}
		
		protected function collectionChange( event : CollectionEvent ):void {
			
			invalidateProperties();
			invalidateSize();
		}

		public function get initialPercentageVisible():Number {
			
			return _initialPercentageVisible;
		}

		/**
		 * A porcentagem de cada item que será exibida quando eles estivem em suas 
		 * posições padrão, somente valores no intervalo 0 < x <= 100, se for passado
		 * 0, define o valor minimo para 1 
		 */ 
		public function set initialPercentageVisible(value:Number):void {
			
			if( value > 100 )
				value = 100;
			
			if( value == 0 )
				value = 1;
			
			_initialPercentageVisible = value;
			invalidateProperties();
			invalidateSize();
		}

		public function get itemsWidth():Number {

			return _itemsWidth;
		}

		/**
		 * Determina a largura de cada um dos items do menu 
		 */
		public function set itemsWidth( value : Number ):void {
			
			_itemsWidth = value;
			invalidateProperties();
		}
		
		public function get dataProvider():IList {
			
			return _dataProvider;
		}
		
		[Bindable]
		public function set dataProvider( value : IList ):void {
			
			_dataProvider = value;
			if( _dataProvider ) {
				
				_dataProvider.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, propertyChange );
				_dataProvider.addEventListener( CollectionEvent.COLLECTION_CHANGE, collectionChange );
			}
			invalidateProperties();
		}

		public function SlidingImages() {
			
			super();
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
		}
	}
}