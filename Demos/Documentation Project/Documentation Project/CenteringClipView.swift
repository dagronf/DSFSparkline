/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Contains the definition for `CenteringClipView` which is a specialized clip view subclass to center its document.
*/

import Cocoa

/**
    `CenteringClipView` is a clip view subclass that centers smaller documents views
    within its inset clip bounds (as described by the set `contentInsets`).
*/
class CenteringClipView: NSClipView {
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        guard let documentView = documentView else { return super.constrainBoundsRect(proposedBounds) }

        var newClipBoundsRect = super.constrainBoundsRect(proposedBounds)

        // Get the `contentInsets` scaled to the future bounds size.
        let insets = convertedContentInsetsToProposedBoundsSize(newClipBoundsRect.size)

        // Get the insets in terms of the view geometry edges, accounting for flippedness.
        let minYInset = isFlipped ? insets.top : insets.bottom
        let maxYInset = isFlipped ? insets.bottom : insets.top
        let minXInset = insets.left
        let maxXInset = insets.right

        /*
            Get and outset the `documentView`'s frame by the scaled contentInsets.
            The outset frame is used to align and constrain the `newClipBoundsRect`.
        */
        let documentFrame = documentView.frame
        let outsetDocumentFrame = NSRect(x: documentFrame.minX - minXInset,
                                         y: documentFrame.minY - minYInset,
                                     width: (documentFrame.width + (minXInset + maxXInset)),
                                    height: documentFrame.height + (minYInset + maxYInset))

        if newClipBoundsRect.width > outsetDocumentFrame.width {
            /*
                If the clip bounds width is larger than the document, center the
                bounds around the document.
            */
            newClipBoundsRect.origin.x = outsetDocumentFrame.minX - (newClipBoundsRect.width - outsetDocumentFrame.width) / 2.0
        }
        else if newClipBoundsRect.width < outsetDocumentFrame.width {
            /*
                Otherwise, the document is wider than the clip rect. Make sure that 
                the clip rect stays within the document frame.
            */
            if newClipBoundsRect.maxX > outsetDocumentFrame.maxX {
                // The clip rect is outside the maxX edge of the document, bring it in.
                newClipBoundsRect.origin.x = outsetDocumentFrame.maxX - newClipBoundsRect.width
            }
            else if newClipBoundsRect.minX < outsetDocumentFrame.minX {
                // The clip rect is outside the minX edge of the document, bring it in.
                newClipBoundsRect.origin.x = outsetDocumentFrame.minX
            }
        }

        if newClipBoundsRect.height > outsetDocumentFrame.height {
            /*
                If the clip bounds height is larger than the document, center the 
                bounds around the document.
            */
            newClipBoundsRect.origin.y = outsetDocumentFrame.minY - (newClipBoundsRect.height - outsetDocumentFrame.height) / 2.0
        }
        else if newClipBoundsRect.height < outsetDocumentFrame.height {
            /*
                Otherwise, the document is taller than the clip rect. Make sure 
                that the clip rect stays within the document frame.
            */
            if newClipBoundsRect.maxY > outsetDocumentFrame.maxY {
                // The clip rect is outside the maxY edge of the document, bring it in.
                newClipBoundsRect.origin.y = outsetDocumentFrame.maxY - newClipBoundsRect.height
            }
            else if newClipBoundsRect.minY < outsetDocumentFrame.minY {
                // The clip rect is outside the minY edge of the document, bring it in.
                newClipBoundsRect.origin.y = outsetDocumentFrame.minY
            }
        }

        return backingAlignedRect(newClipBoundsRect, options: .alignAllEdgesNearest)
    }

    /**
        The `contentInsets` scaled to the scale factor of a new potential bounds
        rect. Used by `constrainBoundsRect(NSRect)`.
    */
	fileprivate func convertedContentInsetsToProposedBoundsSize(_ proposedBoundsSize: NSSize) -> NSEdgeInsets {
        // Base the scale factor on the width scale factor to the new proposedBounds.
        let fromBoundsToProposedBoundsFactor = bounds.width > 0 ? (proposedBoundsSize.width / bounds.width) : 1.0

        // Scale the set `contentInsets` by the width scale factor.
        var newContentInsets = contentInsets
        newContentInsets.top *= fromBoundsToProposedBoundsFactor
        newContentInsets.left *= fromBoundsToProposedBoundsFactor
        newContentInsets.bottom *= fromBoundsToProposedBoundsFactor
        newContentInsets.right *= fromBoundsToProposedBoundsFactor

        return newContentInsets
    }
}


/*
Sample code project: Exhibition: An Adaptive OS X App
Version: 1.2

IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2016 Apple Inc. All Rights Reserved.

*/
