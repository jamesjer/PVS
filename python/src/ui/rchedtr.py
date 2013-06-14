

import wx
import codecs
import util
from styltxt import PVSStyledText


log = util.getLogger(__name__)

class RichEditor(wx.Panel):
    """RichEditor displays the content a file or buffer. It provides syntax highlighting, 
    as well as other functionalities like Copy, Paste, etc"""
    
    def __init__(self, parent, ID, data):
        wx.Panel.__init__(self, parent, ID)
        sizer = wx.BoxSizer()        
        self.styledText = PVSStyledText(self)
        sizer.Add(self.styledText, 1, wx.EXPAND, 0)
        self.SetSizer(sizer)
        
        self.data = data
        self.decode = codecs.lookup("utf-8")[1]
        
    def addRedMarker(self, lineN):
        self.MarkerAdd(lineN, 1)
    
    def OnDestroy(self, evt):
        wx.TheClipboard.Flush()
        evt.Skip()
        
    def setText(self, text):
        log.info("Setting content of the rich editor")
        if wx.USE_UNICODE:
            unitext = self.decode(text)[0]
            self.styledText.SetText(unitext)
        else:
            self.styledText.SetText(text)

    def getText(self):
        return self.styledText.GetText()

        
    