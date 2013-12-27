/**
 * Class: Container
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.engine.IDrawable;
	import com.octadecimal.breeze.graphics.DisplayNode;
	import com.octadecimal.breeze.modules.Module;
	import com.octadecimal.breeze.util.Debug;
	import flash.geom.Rectangle;
	
	/**
	 * Serves as a base container to put other containers inside of. Handles the positioning, loading, updating
	 * and drawing for all of it's children.
	 */
	public class Container extends Module implements IDrawable
	{
		/**
		 * Enumerations
		 */ 
		public static const HORIZONTAL:uint = 0;
		public static const VERTICAL:uint 	= 1;
		public static const LEFT:uint		= 0;
		public static const TOP:uint		= 0;
		public static const CENTER:uint		= 1;
		public static const RIGHT:uint		= 2;
		public static const BOTTOM:uint		= 2;
		
		/**
		 * Name.
		 */
		public function get name():String						{ return _name; }
		private var _name:String;
		
		/**
		 * Container direction. Uses one of the container enumerations.
		 */
		public function get direction():uint					{ return _direction; }
		public function set direction(a:uint):void				{ _direction = a; }
		private var _direction:uint;
		
		/**
		 * Set to true if container should fit itself to it's parent.
		 */
		public function get autofit():Boolean					{ return _autofit; }
		public function set autofit(a:Boolean):void				{ _autofit = a; }
		private var _autofit:Boolean = false;
		
		/**
		 * Horizontal alignment to parent.
		 */
		public function get alignH():uint		{ return _alignH; }
		public function set alignH(a:uint):void	{ _alignH = a; }
		private var _alignH:uint = LEFT;
		
		/**
		 * Vertical alignment to parent.
		 */
		public function get alignV():uint		{ return _alignV; }
		public function set alignV(a:uint):void	{ _alignV = a; }
		private var _alignV:uint=TOP;
		
		/**
		 * Children list.
		 */
		public function get children():Vector.<Container>		{ return _children; }
		private var _children:Vector.<Container> = new Vector.<Container>();
		
		/**
		 * Root container. The deepest node in this container tree.
		 */
		public function get root():Container					{ return _root; }
		public function set root(a:Container):void				{ _root = a; } 
		private var _root:Container;
		
		/**
		 * Parent container.
		 */
		public function get parent():Container					{ return _parent; }
		public function set parent(a:Container):void			{ _parent = a; }
		private var _parent:Container;
		
		/**
		 * Previous sibling container.
		 */
		public function get previousSibling():Container			{ return _previousSibling; }
		public function set previousSibling(a:Container):void	{ _previousSibling = a; }
		private var _previousSibling:Container;
		
		/**
		 * Container with focus. Not directly used by the Container class, but allows extended
		 * objects to manage focus with this property.
		 */
		public function get focus():Container		{ return _focus; }
		public function set focus(a:Container):void	{ _focus = a; }
		private var _focus:Container;
		
		/**
		 * Display node.
		 */
		public var display:DisplayNode = new DisplayNode();
		
		/**
		 * Debug
		 */
		private var _randColor:uint = Math.random() * uint.MAX_VALUE;
		public var verbose:Boolean = false;
		public static var debugDraw:Boolean = false;
		public var debug:Boolean = true;
		
		/**
		 * Original dimensions, before generation
		 */
		private var _originalWidth:int=int.MAX_VALUE, _originalHeight:int=int.MAX_VALUE;
		
		
		
		/**********************************************************************************************************************
		 *  Initialization
		 */
		
		/**
		 * 
		 * @param	name		Name of this container. Name should be unique for clarity, but isn't required as of now.
		 * @param	type
		 */
		public function Container(name:String, direction:uint=HORIZONTAL)
		{
			// Arguments
			_name = name;
			_direction = direction;
			
			super();
		}
		
		override public function initialize():void 
		{
			super.initialize();
		}
		
		
		
		/**********************************************************************************************************************
		 *  Adding
		 */
		
		/**
		 * Adds a child to this container and initializes and values required before container generation.
		 * @param	child	Child to add.
		 * @return
		 */
		public function add(child:Container, autofit:Boolean=false, alignH:uint=LEFT, alignV:uint=TOP):Container
		{
			if (child == null) new Error("Null child passed, whatchu doin foo");
			
			// Save align and autofit
			child.autofit = autofit;
			child.alignH = alignH;
			child.alignV = alignV;
				
			// Save parent reference
			child.parent = this;
			
			// Find previous siblings
			if (_children.length > 0)
				child.previousSibling = _children[_children.length - 1];
				
			// Find root
			var r:Container = this;
			while (r.parent) 
				r = r.parent;
				
			// Save root references
			child.root = r;
			this.root = r;
			
			// Push
			_children.push(child);
			
			// Output
			if (Breeze.DEBUG && verbose)  
			{
				var node:Container = this;
				var nodeChain:String = child.name +"->" + this.name;
				while (node.parent) 
				{
					node = node.parent
					nodeChain += "->" + node.name;
				}
				
				Debug.print(this,"Added child: " + nodeChain);
			}
			
			return child;
		}
		
		
		
		/**********************************************************************************************************************
		 *  Generation
		 */
		
		/**
		 * Generates this and all it's children's (and it's children, etc) dimensions and position. This only needs to
		 * be called once per change, and not every frame.
		 */
		public function generate():void
		{
			if(verbose && Breeze.DEBUG) { Debug.print(this, "Generating: "+_name); }
			
			autoSize();
			autoFit();
			autoPosition();
		}
		
		
		/**
		 * Automatically determines the width and height for this object. Before it does so, it calls autoSize() for all
		 * children first, effectively causing the loop to bubble up. After the children (and it's children) have exited
		 * their respective autoSize(), this object's width and height are derived from it's children. Note this should
		 * be called before and seperately of any auto-fitting passes.
		 */
		private function autoSize():void
		{
			// Traverse children
			for each(var child:Container in _children)
			{
				// Cause loop to bubble up so that children may derive their dimensions before we derive ours.
				child.autoSize();
				
				// Padded and marginized dimensions
				var childWidth:Number  = child.display.width + display.paddingX;
				var childHeight:Number = child.display.height + display.paddingY;
				
				// Derive self's width and height from children
				if (_direction == HORIZONTAL)
				{
					// Add to width
					_childrenWidth += childWidth;
					if (verbose && Breeze.DEBUG) { Debug.print(this, "Added to width: " + _name + " from: "+child.name+" "+childWidth+"->"+_childrenWidth); }
					
					// Use max height
					if (_childrenHeight < childHeight)
					{
						if (verbose && Breeze.DEBUG) { Debug.print(this, "Replacing max height for: " + _name + " " + _childrenHeight+"->"+childHeight); }
						_childrenHeight = childHeight;
					}
				}
				else
				{
					// Add to height
					_childrenHeight += childHeight;
					if (verbose && Breeze.DEBUG) { Debug.print(this, "Added to height: " + _name + " from: " + child.name + " " + childHeight + "->" + _childrenHeight); }
					
					// Use max width
					if (_childrenWidth < childWidth)
					{
						if (verbose && Breeze.DEBUG) { Debug.print(this, "Replacing max width for: " + _name + " " + _childrenWidth+"->"+childWidth); }
						_childrenWidth = childWidth;
					}
				}
			}
			
			// Add to dimensions if children dimensions are larger than this'
			if (_childrenWidth > display.width) display.width += (_childrenWidth + display.paddingX) - display.width;
			if (_childrenHeight > display.height) display.height += (_childrenHeight + display.paddingY) - display.height;
			if (verbose && Breeze.DEBUG) Debug.print(this, "Final dimensions for " + _name + " " + display.width + "," + display.height);
		}
		private var _childrenWidth:int, _childrenHeight:int;
		
		
		/**
		 * 	Autofits children to self if child is set to autoset.
		 */
		private function autoFit():void
		{
			var knownChildrenWidth:uint = 0;
			var knownChildrenHeight:uint = 0;
			var childrenToAutofit:uint = 0;
			
			// Get known children dimensions
			for each(var child:Container in _children)
			{
				knownChildrenWidth += child.display.width + display.paddingX;
				knownChildrenHeight += child.display.height + display.paddingY;
				if (child.autofit) childrenToAutofit++;
			}
			
			// Autofit children to this
			for each(child in _children)
			{
				if (child.autofit)
				{
					if (_direction == HORIZONTAL)
					{
						if (verbose && Breeze.DEBUG) Debug.print(this, "Auto fitting to horizontal parent: " + _name + "<-" + child.name);
						child.display.width += (display.width - (knownChildrenWidth + display.paddingX)) / childrenToAutofit;
						child.display.height = display.height - (display.paddingY * 2);
					}
					else
					{
						if (verbose && Breeze.DEBUG) Debug.print(this, "Auto fitting to vertical parent: " + _name + "<-" + child.name);
						child.display.width = display.width - (display.paddingX * 2);
						child.display.width += (display.height - (knownChildrenHeight + display.paddingY)) / childrenToAutofit;
					}
				}
			
				// Traverse
				child.autoFit();
			}
		}
		
		
		/**
		 * Automatically determines position for this object, taking parent and sibling positions, and sibling dimensions
		 * into account. It then calls autoChild() for all children, effectively looping throughout the entire container network.
		 */
		private function autoPosition():void
		{
			// Is first child and has parent
			if (!_previousSibling && _parent)
			{
				if (alignH == LEFT)
					display.x = parent.display.x + parent.display.paddingX;
					
				else if (alignH == CENTER)
					display.x = parent.display.x + (parent.display.width * 0.5) - (display.width * 0.5);
					
				else if (alignH == RIGHT)
					display.x = parent.display.x + parent.display.width - display.width - parent.display.paddingX;
					
				if (alignV == TOP)
					display.y = parent.display.y + parent.display.paddingY;
				
				else if (alignV == CENTER)
					display.y = parent.display.y + (parent.display.height * 0.5) - (display.height * 0.5);
					
				else if (alignV == BOTTOM)
					display.y = parent.display.y + parent.display.height - display.height - parent.display.paddingY;
					
				if(verbose && Breeze.DEBUG) { Debug.print(this, "Auto positioned to parent: "+_parent.name+"<-"+_name); }
			}
			// Is Sibling
			else if(_previousSibling && _parent)
			{
				// Position
				if (_parent.direction == HORIZONTAL)
				{
					// Constrain x to previous sibling, and add sibling's width and paddingX, plus this paddingX
					display.x = _previousSibling.display.x + _previousSibling.display.width;
					
					// Constrain y to previous sibling
					display.y = _previousSibling.display.y;
					
					// Pad x if parent exists
					if (_parent) display.x += _parent.display.paddingX;
					
					// Output
					if (verbose && Breeze.DEBUG) { Debug.print(this, "Auto positioned to sibling horizontally: " + _previousSibling.name + "(" + _previousSibling.display.x + "+" + _previousSibling.display.width + ")" + "<-" + _name + "(" + display.x + ")"); }
				}
				else
				{
					// Constrain x to previous sibling
					display.x = _previousSibling.display.x;
					
					// Constrain y to previous sibling, and add sibling's height
					display.y = _previousSibling.display.y + _previousSibling.display.height;
					
					// Pad y if parent exists
					if (_parent) display.y += _parent.display.paddingY;
					
					// Output
					if(verbose && Breeze.DEBUG) { Debug.print(this, "Auto positioned to sibling vertically: "+_previousSibling.name+ "(" + _previousSibling.display.y + "+" + _previousSibling.display.height + ")" + "<-" + _name + "(" + display.y + ")"); }
				}
			}
			else if (verbose && Breeze.DEBUG) Debug.print(this, "Auto positioning ignored on root node: " + _name);
			
			// Self's position derived, traverse children
			for each(var child:Container in _children)
				child.autoPosition();
		}
		
		
		
		/**********************************************************************************************************************
		 *  Engine
		 */
		
		/**
		 * Updates all of this object's children.
		 * @param	change	Milliseconds passed since last update.
		 */
		public function update(change:uint):void
		{
			// Update children
			for each(var child:Container in _children)
				child.update(change);
				
			autoPosition();
		}
		
		/**
		 * Updates all of this object's children.
		 * @param	change	Milliseconds passed since last draw.
		 */
		public function draw(change:uint):void
		{
			// Debug draw
			if (Breeze.DEBUG && debugDraw && debug)
				Breeze.screen.buffer.fillRect(new Rectangle(display.x, display.y, display.width, display.height), _randColor);
			
			// Draw children
			for each(var child:Container in _children)
				child.draw(change);
		}
	}
}