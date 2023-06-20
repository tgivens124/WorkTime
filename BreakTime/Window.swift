//
//  Window.swift
//  BreakTime
//
//  Created by Taylor Givens on 6/19/23.
//

import Cocoa

class Window: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        super.windowDidLoad()
               
               // Set the window level to a higher value
        window?.level = .floating
        window?.collectionBehavior = .canJoinAllSpaces

        window?.styleMask.remove( .resizable)
        window?.titleVisibility = .hidden
    
        
        

    }
   

}
