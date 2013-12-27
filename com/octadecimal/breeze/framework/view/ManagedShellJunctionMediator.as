/*
 Medator:  ManagedShellJunctionMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view 
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.interfaces.IJunctionMediator;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.framework.view.components.Module;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	
	/**
	 * ManagedShellJunctionMediator Mediator.
	 * ...
	 */
	public class ManagedShellJunctionMediator extends ManagedJunctionMediator implements IJunctionMediator
	{
		/**
		 * Mediator constructor.
		 */
		public function ManagedShellJunctionMediator(name:String) 
		{
			// Super
			super(name);
		}
		
		/**
		 * Register pipes.
		 */
		override public function onRegister():void 
		{
			super.onRegister();
			
			// Pipe: Standard Out
			junction.registerPipe(Module.STDOUT, Junction.OUTPUT, new TeeSplit());
			
			// Pipe: Standard In
			junction.registerPipe(Module.STDIN, Junction.INPUT, new TeeMerge());
			
			// Listener: Standard In
			junction.addPipeListener(Module.STDIN, this, handlePipeMessage);
		}
		
		
		
		// PIPE CONNECTING
		// =========================================================================================
		
		/**
		 * Creates and connects a pipe from the shell to the module.
		 */
		private function connectShellToModule(module:Module):void
		{
			// Create and accept module input pipe
			var shellToModule:Pipe = new Pipe();
			module.acceptInputPipe(Module.STDIN, shellToModule);
			
			// Connect fitting to shell output pipe
			var shellOut:IPipeFitting = junction.retrievePipe(Module.STDOUT) as IPipeFitting;
			shellOut.connect(shellToModule);
		}
		
		/**
		 * Creates and connects a pipe from the module to the shell.
		 */
		private function connectModuleToShell(module:Module):void
		{
			// Create and accept module output pipe
			var moduleToShell:Pipe = new Pipe();
			module.acceptOutputPipe(Module.STDOUT, moduleToShell);
			
			// Connect fitting to shell input pipe
			var shellIn:TeeMerge = junction.retrievePipe(Module.STDIN) as TeeMerge;
			shellIn.connectInput(moduleToShell);
		}
		
		
        
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 */
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			
			// Internal notifications
			interests.push(ApplicationFacade.MODULE_REGISTERED);
			
			return interests;
		}
		
		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {           
				
				case ApplicationFacade.MODULE_REGISTERED:
					handleModuleRegistered(note.getBody() as Module);
					break;
				
				default:
					super.handleNotification(note);		
			}
		}
		
		override public function handlePipeMessage(message:IPipeMessage):void 
		{
			super.handlePipeMessage(message);
			
			// Bounce all data
			junction.sendMessage(Module.STDOUT, message);
		}
		
		
		
		// HANDLERS
		// =========================================================================================
		
		private function handleModuleRegistered(module:Module):void
		{
			Debug.print(this, "Connecting: " + module);
			
			// Shell->Module
			connectShellToModule(module);
			
			// Module->Shell
			connectModuleToShell(module);
			
			// Module fully ready, dispatch module ready
			sendNotification(ApplicationFacade.MODULE_CONNECTED, module);
		}
	}
}
